//
//  Text.swift
//  TalkToDemo
//
//  Created by Nurul Islam on 20/7/24.
//

import SwiftUI

extension Text {
    func defaultModifier(
        style: UIFont.TextStyle,
        color: Color) -> some View {
        self
            .font(.circular(style))
            .foregroundColor(color)
            .multilineTextAlignment(.leading)
    }
    
    func boldModifier(
        style: UIFont.TextStyle,
        color: Color) -> some View {
        self
            .font(.circular(style).bold())
            .foregroundColor(color)
            .multilineTextAlignment(.leading)
    }
    
    func textModifier(width: CGFloat) -> some View {
        self
            .font(.circular(.footnote))
            .frame(width: width, alignment: .leading)
            .fixedSize(horizontal: true, vertical: false)
            .frame(maxHeight: .infinity, alignment: .topLeading)
    }
    
    func textModifierCenter(width: CGFloat, style: UIFont.TextStyle) -> some View {
        self
            .font(.circular(style))
            .frame(width: width, alignment: .leading)
            .fixedSize(horizontal: true, vertical: false)
            .frame(maxHeight: .infinity, alignment: .center)
    }
    
    func textModifierWithOverlay(style: UIFont.TextStyle, color: Color) -> some View {
        self
            .font(.circular(style))
            .foregroundColor(color)
            .padding(.horizontal)
            .padding(.vertical, 8)
            .overlay(
                RoundedRectangle(cornerRadius: 8)
                    .stroke(
                        Color.textColor,
                        lineWidth: 1
                    )
            )
    }
}
