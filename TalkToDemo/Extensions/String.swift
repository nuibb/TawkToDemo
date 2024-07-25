//
//  String.swift
//  TalkToDemo
//
//  Created by Nurul Islam on 20/7/24.
//

import Foundation

extension String {
    var trimmed: String {
        return self.trimmingCharacters(in: .whitespacesAndNewlines)
    }
    
    func replace(with text: String) -> String {
        return self.replacingOccurrences(of: "{@}", with: text)
    }
}
