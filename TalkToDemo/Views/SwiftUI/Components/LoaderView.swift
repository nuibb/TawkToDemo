//
//  LoaderView.swift
//  TalkToDemo
//
//  Created by Nurul Islam on 20/7/24.
//

import SwiftUI

struct LoaderView: View {
    @Environment(\.presentationMode) var presentationMode
    
    var body: some View {
        ZStack(alignment: .center) {
            Rectangle()
                .fill(Color.clear)
                .contentShape(Rectangle())
                .onTapGesture {
                    dismiss()
                }
                .zIndex(0)
            
            ProgressView()
                .progressViewStyle(CircularProgressViewStyle(tint: .purple))
                .zIndex(1)
        }
        .background(Color.black.opacity(0.5))
        .edgesIgnoringSafeArea(.all)
    }
}

extension LoaderView {
    func dismiss() {
        presentationMode.wrappedValue.dismiss()
    }
}
