//
//  CellIdentifier.swift
//  TalkToDemo
//
//  Created by Nurul Islam on 24/7/24.
//

import Foundation
import UIKit

internal enum CellIdentifier: String, CustomStringConvertible, CaseIterable {
    case normal
    case notes
    case inverted
    
    var description: String {
        switch self {
        case .normal:
            return "NormalCell"
        case .notes:
            return "NotesCell"
        case .inverted:
            return "InvertedCell"
        }
    }
    
    var identifier: String {
        switch self {
        case .normal:
            return "NormalCellIdentifier"
        case .notes:
            return "NotesCellIdentifier"
        case .inverted:
            return "InvertedCellIdentifier"
        }
    }
}
                            
