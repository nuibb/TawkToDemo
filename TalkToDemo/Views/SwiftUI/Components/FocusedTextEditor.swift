//
//  FocusedTextEditor.swift
//  TalkToDemo
//
//  Created by Nurul Islam on 20/7/24.
//

import Foundation
import SwiftUI

@available(iOS 15.0, *)
struct FocusedTextEditor: View {
    @FocusState private var isFocused: Bool
    @Binding var text: String
    let placeHolder: String
    let linesAllowed: Int
    var keyboardType: UIKeyboardType = .default
    var focusedOnAppear: Bool = false

    var body: some View {
        ZStack(alignment: .topLeading) {
            TextEditor(text: $text)
                .padding(.leading, 8)
                .padding(.trailing, 5)
                .font(.circular(.subheadline))
                .foregroundColor(.primaryColor)
                .conditionalFrame(linesAllowed: linesAllowed)
                .focused($isFocused)
                .keyboardType(keyboardType)

            Text(placeHolder)
                .foregroundColor(.black.opacity(0.25))
                .padding(.leading, 12)
                .padding(.top, 5)
                .hidden(!text.isEmpty)
                .onTapGesture {
                    isFocused = true
                }
        }
        .background(Color.white)
        .cornerRadius(5)
        .onAppear {
            isFocused = focusedOnAppear
        }
    }
}




