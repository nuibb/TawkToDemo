//
//  CacheAsyncImage.swift
//  TalkToDemo
//
//  Created by Nurul Islam on 20/7/24.
//

import Foundation
import SwiftUI

@available(iOS 15.0, *)
struct CustomAsyncImage: View {
    let imageURL: URL
    let size: CGSize
    let isIcon: Bool
    
    init(imageURL: URL, size: CGSize, isIcon: Bool) {
        self.imageURL = imageURL
        self.size = size
        self.isIcon = isIcon
    }
    
    var body: some View {
        CacheAsyncImage(imageURL: imageURL, size: size, isIcon: isIcon) { phase in
            switch phase {
            case .success(let image):
                if !isIcon {
                    image.imageModifier(size: size)
                } else {
                    image.iconModifierFill(size: size)
                }
            case .failure(_):
                Image(systemName: Constants.failedPhaseIcon).iconModifier(size: size)
            case .empty:
                Image(systemName: Constants.emptyPhaseIcon).iconModifier(size: size)
            @unknown default:
                ProgressView()
            }
        }
    }
}

@available(iOS 15.0, *)
struct CacheAsyncImage<Content>: View where Content: View {
    let imageURL: URL
    let size: CGSize
    let isIcon: Bool
    let content: (AsyncImagePhase) -> Content
    
    private let scale: CGFloat = 3.0
    private let transaction = Transaction(animation: .spring(response: 0.5, dampingFraction: 0.6, blendDuration: 0.25))
    
    init(imageURL: URL, size: CGSize, isIcon: Bool, @ViewBuilder content: @escaping (AsyncImagePhase) -> Content) {
        self.imageURL = imageURL
        self.size = size
        self.isIcon = isIcon
        self.content = content
    }
    
    var body: some View {
        AsyncImage(url: imageURL, scale: scale, transaction: transaction) { phase in
            cacheAndRender(phase: phase)
        }
    }
    
    private func cacheAndRender(phase: AsyncImagePhase) -> some View {
        if case .success(_) = phase {
            imageURL.downloadAndCache()
        }
        return content(phase)
    }
}
