//
//  Misc.swift
//  TalkToDemo
//
//  Created by Nurul Islam on 20/7/24.
//

import SwiftUI

struct Utils {
    static func after(seconds: Double, callback:@escaping () -> Void) {
        DispatchQueue.main.asyncAfter(deadline: .now() + seconds) {
            withAnimation {
                callback()
            }
        }
    }
}
