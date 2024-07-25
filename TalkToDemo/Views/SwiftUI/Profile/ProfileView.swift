//
//  ProfileView.swift
//  TalkToDemo
//
//  Created by Nurul Islam on 20/7/24.
//

import SwiftUI

struct ProfileView: View {
    @ObservedObject var viewModel: ProfileViewModel
    @State var image: Image?
    
    let size: CGSize = CGSize(width: UIScreen.main.bounds.width/3, height: UIScreen.main.bounds.width/3)
    
    var body: some View {
        ZStack(alignment: .center) {
            ScrollView(.vertical, showsIndicators: false) {
                VStack(alignment: .center, spacing: 16) {
                    if let url = viewModel.user.avatar, !url.isEmpty,
                       let imageURL = URL(string: url) {
                        
                        /// Show cached image first if available
                        if let uiImage = imageURL.loadImage() {
                            Image(uiImage: uiImage)
                                .rectangleOverlay(size: size, lineWidth: 1.0)
                            
                        } else {
                            if viewModel.remoteDataProvider.networkMonitor.isConnected {
                                if #available(iOS 15.0, *) {
                                    CustomAsyncImage(
                                        imageURL: imageURL,
                                        size: size,
                                        isIcon: false
                                    )
                                } else {
                                    if let image = image {
                                        image /// downloaded image
                                            .rectangleOverlay(size: size, lineWidth: 1.0)
                                    } else {
                                        /// show default first, then download and cache latest
                                        Image("avatar")
                                            .rectangleOverlay(size: size, lineWidth: 1.0)
                                            .onAppear() {
                                                downloadAndCache(imageURL)
                                            }
                                    }
                                }
                            } else {
                                Image("avatar") /// show default
                                    .rectangleOverlay(size: size, lineWidth: 1.0)
                            }
                        }
                    } else {
                        Image("avatar") /// show default
                            .rectangleOverlay(size: size, lineWidth: 1.0)
                    }
                    
                    HStack(alignment: .center) {
                        Spacer()
                        Text("Followers: \(viewModel.user.followers ?? 0)")
                            .defaultModifier(style: .subheadline, color: .textColor)
                        
                        Spacer()
                        
                        Text("Following: \(viewModel.user.following ?? 0)")
                            .defaultModifier(style: .subheadline, color: .textColor)
                        Spacer()
                    }
                    .padding(.top, 8)
                    .padding(.bottom)
                    
                    if shouldDetailSectionVisible {
                        VStack(alignment: .leading, spacing: 8) {
                            if let name = viewModel.user.name, !name.isEmpty {
                                HStack(spacing: 4) {
                                    Text("Name: ")
                                        .defaultModifier(style: .callout, color: .textColor)
                                    
                                    Text(name)
                                        .boldModifier(style: .callout, color: .textColor)
                                    
                                    Spacer()
                                }
                            }
                            
                            if let company = viewModel.user.company, !company.isEmpty {
                                HStack(spacing: 4) {
                                    Text("Company: ")
                                        .defaultModifier(style: .callout, color: .textColor)
                                    
                                    Text(company)
                                        .boldModifier(style: .callout, color: .textColor)
                                    
                                    Spacer()
                                }
                            }
                            
                            if let blog = viewModel.user.blog, !blog.isEmpty {
                                HStack(spacing: 4) {
                                    Text("Blog: ")
                                        .defaultModifier(style: .callout, color: .textColor)
                                    
                                    Text(blog)
                                        .boldModifier(style: .callout, color: .textColor)
                                    
                                    Spacer()
                                }
                            }
                        }
                        .padding()
                        .overlay(
                            RoundedRectangle(cornerRadius: 8)
                                .stroke(
                                    Color.textColor,
                                    lineWidth: 1
                                )
                        )
                        .padding()
                    }
                    
                    VStack(alignment: .leading, spacing: 8) {
                        Text(Constants.notes)
                            .defaultModifier(style: .callout, color: .textColor)
                        
                        DynamicTextEditor(
                            text: $viewModel.user.notes,
                            placeHolder: Constants.enterNotes,
                            linesAllowed: 5
                        )
                        .overlay(
                            RoundedRectangle(cornerRadius: 8)
                                .stroke(
                                    Color.textColor,
                                    lineWidth: 1
                                )
                        )
                    }
                    .padding()
                    
                    SwiftUI.Button(action: {
                        viewModel.updateNotes()
                    }) {
                        Text(Constants.save)
                            .textModifierWithOverlay(style: .callout, color: .textColor)
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
    func downloadAndCache(_ url: URL) {
        Task {
            do {
                let uiImage = try await url.downloadImage()
                self.image = Image(uiImage: uiImage)
                try url.cache(uiImage)
            } catch {
                Logger.log(type: .error, "Image download failed with error: \(error.localizedDescription)")
            }
        }
    }
    
    var shouldDetailSectionVisible: Bool {
        let name =  viewModel.user.name ?? ""
        let company =  viewModel.user.company ?? ""
        let blog =  viewModel.user.blog ?? ""
        if name.isEmpty, company.isEmpty, blog.isEmpty {
            return false
        } else {
            return true
        }
    }
}

#Preview {
    let user = UserData(login: UUID().uuidString, nodeId: nil, avatarUrl: nil, grAvatarId: nil, url: nil, htmlUrl: nil, followersUrl: nil, followingUrl: nil, gistsUrl: nil, starredUrl: nil, subscriptionsUrl: nil, organizationsUrl: nil, reposUrl: nil, eventsUrl: nil, receivedEventsUrl: nil, type: nil, siteAdmin: nil)
    
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
