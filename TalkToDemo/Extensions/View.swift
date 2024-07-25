//
//  View.swift
//  TalkToDemo
//
//  Created by Nurul Islam on 20/7/24.
//

import Foundation
import SwiftUI

extension View {
    func conditionalFrame(linesAllowed: Int) -> some View {
        self.modifier(ConditionalFrameModifier(linesAllowed: linesAllowed))
    }
}

extension View {
    @ViewBuilder public func hidden(_ shouldHide: Bool) -> some View {
        switch shouldHide {
        case true: self.hidden()
        case false: self
        }
    }
}