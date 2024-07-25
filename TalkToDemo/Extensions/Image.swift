//
//  Image.swift
//  TalkToDemo
//
//  Created by Nurul Islam on 20/7/24.
//

import Foundation
import SwiftUI

extension Image {
    func imageModifier(size: CGSize) -> some View {
        self
            .resizable()
            .scaledToFill()
            .frame(width: size.width, height: size.height, alignment: .center)
            .clipShape(RoundedRectangle(cornerRadius: 8))
    }
    
    func iconModifier(size: CGSize) -> some View {
        self
            .resizable()
            .scaledToFit()
            .frame(width: size.width, height: size.height, alignment: .center)
            .clipShape(Circle())
    }
    
    func iconModifierFill(size: CGSize) -> some View {
        self
            .resizable()
            .scaledToFill()
            .frame(width: size.width, height: size.height, alignment: .center)
            .clipShape(Circle())
    }
    
    func rectangleOverlay(size: CGSize, lineWidth: CGFloat) -> some View {
        self
            .resizable()
            .scaledToFit()
            .frame(width: size.width, height: size.height, alignment: .center)
            .padding()
            .overlay(
                RoundedRectangle(cornerRadius: 4)
                    .stroke(
                        Color.borderColor.opacity(0.6),
                        lineWidth: lineWidth
                    )
            )
            .transition(.scale)
    }
}
