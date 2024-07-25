//
//  Modifiers.swift
//  TalkToDemo
//
//  Created by Nurul Islam on 20/7/24.
//

import SwiftUI

struct ConditionalFrameModifier: ViewModifier {
    let linesAllowed: Int
    
    @ViewBuilder
    func body(content: Content) -> some View {
        if linesAllowed > 0 {
            content
                .frame(height: CGFloat(linesAllowed) * UIFont.preferredFont(forTextStyle: .body).lineHeight)
                .fixedSize(horizontal: false, vertical: true)
        } else {
            content
        }
    }
}
