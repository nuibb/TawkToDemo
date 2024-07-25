//
//  StorageStatus.swift
//  TalkToDemo
//
//  Created by Nurul Islam on 21/7/24.
//

import Foundation

enum StorageStatus: Error, CustomStringConvertible {
    case succeed
    case savingFailed
    case insertionFailed
    case loadingFailed
    case editingFailed
    case deletingFailed
    case existsInDB
    case notExistsInDB
    case unknown
    
    var description: String {
        switch self {
        case .succeed:
            return Constants.savingSucceed
        case .savingFailed:
            return Constants.savingFailed
        case .insertionFailed:
            return Constants.insertionFailed
        case .loadingFailed:
            return Constants.loadingFailed
        case .editingFailed:
            return Constants.editingFailed
        case .deletingFailed:
            return Constants.deletingFailed
        case .existsInDB:
            return Constants.existsInDB
        case .notExistsInDB:
            return Constants.notExistsInDB
        default:
            return Constants.defaultError
        }
    }
}

