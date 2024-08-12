//
//  ImageLoader.swift
//  TalkToDemo
//
//  Created by Nurul Islam on 26/7/24.
//

import SwiftUI

struct ImageLoaderView: View {
    @ObservedObject var viewModel: ProfileViewModel
    @State var image: Image?

    let size: CGSize = CGSize(width: UIScreen.main.bounds.width/3, height: UIScreen.main.bounds.width/3)
    
    var body: some View {
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
    }
}

extension ImageLoaderView {
    private func downloadAndCache(_ url: URL) {
        ImageDownloadProvider.shared.downloadImage(from: url) { image in
            guard let uiImage = image else { return }
            self.image = Image(uiImage: uiImage)
        }
    }
}
