//
//  Array.swift
//  TalkToDemo
//
//  Created by Nurul Islam on 25/7/24.
//

import Foundation

extension Array where Element: Identifiable {
    mutating func formUnion(_ newElements: [Element]) {
        var uniqueElements = Dictionary(grouping: self, by: { $0.id }).mapValues { $0.last! }
        
        for element in newElements {
            uniqueElements[element.id] = element
        }
        
        self = Array(uniqueElements.values)
    }
    
    mutating func formUnion(for newElements: [Element]) {
        let existingIDs = Set(self.map { $0.id })
        for element in newElements {
            if !existingIDs.contains(element.id) {
                self.append(element)
            }
        }
    }
}
