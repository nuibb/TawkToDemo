//
//  LoaderView.swift
//  TalkToDemo
//
//  Created by Nurul Islam on 20/7/24.
//

import SwiftUI

struct FeedbackView: View {
    @Environment(\.presentationMode) var presentationMode
    let message: String
    
    var body: some View {
        VStack(alignment: .leading) {
            Text(message)
                .defaultModifier(style: .subheadline, color: Color.white)
                .padding()
                .padding(.top, 70)
            
            Spacer()
        }
        .background(Color.clear)
        .edgesIgnoringSafeArea(.all)
        .onAppear() {
            Utils.after(seconds: 3) {
                self.dismiss()
            }
        }
    }
}

extension FeedbackView {
    private func dismiss() {
        presentationMode.wrappedValue.dismiss()
    }
}
