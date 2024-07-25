//
//  Color.swift
//  TalkToDemo
//
//  Created by Nurul Islam on 20/7/24.
//

import Foundation
import SwiftUI

extension Color {
    init(hex: String) {
        var value = hex
        if value.hasPrefix("#") {
            value.remove(at: value.startIndex)
        }
        
        let scanner = Scanner(string: value)
        scanner.currentIndex = scanner.string.startIndex
        var rgbValue: UInt64 = 0
        scanner.scanHexInt64(&rgbValue)
        
        let r = (rgbValue & 0xff0000) >> 16
        let g = (rgbValue & 0xff00) >> 8
        let b = rgbValue & 0xff
        
        self.init(red: Double(r) / 0xff, green: Double(g) / 0xff, blue: Double(b) / 0xff)
    }
}

// Define Semantic Colors
extension Color {
    static let textColor = Color("TextColor")
    static let backgroundColor = Color("BackgroundColor")
    static let borderColor = Color(hex: "E4E4E4")
}
