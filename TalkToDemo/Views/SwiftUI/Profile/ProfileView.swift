//
//  ProfileView.swift
//  TalkToDemo
//
//  Created by Nurul Islam on 20/7/24.
//

import SwiftUI

struct ProfileView: View {
    @ObservedObject var viewModel: ProfileViewModel
    
    var body: some View {
        ZStack(alignment: .center) {
            ScrollView(.vertical, showsIndicators: false) {
                VStack(alignment: .center, spacing: 16) {
                    ImageLoader(viewModel: viewModel)
                    
                    HStack(alignment: .center) {
                        Spacer()
                        Text("Followers: \(viewModel.user.followers ?? 0)")
                            .defaultModifier(style: .subheadline, color: .primaryColor)
                        
                        Spacer()
                        
                        Text("Following: \(viewModel.user.following ?? 0)")
                            .defaultModifier(style: .subheadline, color: .primaryColor)
                        Spacer()
                    }
                    .padding(.top, 8)
                    .padding(.bottom)
                    
                    if shouldDetailSectionVisible {
                        VStack(alignment: .leading, spacing: 8) {
                            if let name = viewModel.user.name, !name.isEmpty {
                                HStack(spacing: 4) {
                                    Text("Name: ")
                                        .defaultModifier(style: .callout, color: .primaryColor)
                                    
                                    Text(name)
                                        .boldModifier(style: .callout, color: .primaryColor)
                                    
                                    Spacer()
                                }
                            }
                            
                            if let company = viewModel.user.company, !company.isEmpty {
                                HStack(spacing: 4) {
                                    Text("Company: ")
                                        .defaultModifier(style: .callout, color: .primaryColor)
                                    
                                    Text(company)
                                        .boldModifier(style: .callout, color: .primaryColor)
                                    
                                    Spacer()
                                }
                            }
                            
                            if let blog = viewModel.user.blog, !blog.isEmpty {
                                HStack(spacing: 4) {
                                    Text("Blog: ")
                                        .defaultModifier(style: .callout, color: .primaryColor)
                                    
                                    Text(blog)
                                        .boldModifier(style: .callout, color: .primaryColor)
                                    
                                    Spacer()
                                }
                            }
                        }
                        .padding()
                        .overlay(
                            RoundedRectangle(cornerRadius: 8)
                                .stroke(
                                    Color.primaryColor,
                                    lineWidth: 1
                                )
                        )
                        .padding()
                    }
                    
                    VStack(alignment: .leading, spacing: 8) {
                        Text(Constants.notes)
                            .defaultModifier(style: .callout, color: .primaryColor)
                        
                        DynamicTextEditor(
                            text: $viewModel.user.notes,
                            placeHolder: Constants.enterNotes,
                            linesAllowed: 5
                        )
                        .overlay(
                            RoundedRectangle(cornerRadius: 8)
                                .stroke(
                                    Color.primaryColor,
                                    lineWidth: 1
                                )
                        )
                    }
                    .padding()
                    
                    SwiftUI.Button(action: {
                        updateNotes()
                    }) {
                        Text(Constants.save)
                            .textModifierWithOverlay(style: .callout, color: .primaryColor)
                    }
                    .buttonStyle(.borderless)
                    
                    Spacer()
                }
            }
            .padding(.horizontal)
            .padding(.top, 8)
            
            if viewModel.isRequesting {
                ProgressView()
                    .progressViewStyle(CircularProgressViewStyle(tint: .pink))
                    .zIndex(1)
            }
        }
    }
}

extension ProfileView {
    private var shouldDetailSectionVisible: Bool {
        let name =  viewModel.user.name ?? ""
        let company =  viewModel.user.company ?? ""
        let blog =  viewModel.user.blog ?? ""
        if name.isEmpty, company.isEmpty, blog.isEmpty {
            return false
        } else {
            return true
        }
    }
    
    private func updateNotes() {
        self.hideKeyboard()
        self.viewModel.updateNotes()
    }
}

#Preview {
    let user = UserData(login: UUID().uuidString, userId: 1)
    
    return ProfileView(
        viewModel: ProfileViewModel(
            user: user,
            remoteDataProvider: ApiServiceProvider.shared,
            localDataProvider: StorageDataProvider(
                context: PersistentStorage.shared.context
            )
        )
    )
}
