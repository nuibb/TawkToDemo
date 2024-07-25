//
//  Constants.swift
//  TalkToDemo
//
//  Created by Nurul Islam on 20/7/24.
//

import Foundation

enum Constants {
    static let projectName = "TalkToDemo"
    static let profileNavTitle = "User"
    static let failedPhaseIcon = "ant.circle.fill"
    static let emptyPhaseIcon = "photo.circle.fill"
    
    /// Decoding Errors
    static let keyNotFound = "Key not found: {@}"
    static let typeMismatch = "Couldn't parse due to type mismatch!"
    static let valueNotFound = "Couldn't parse due to value not found."
    static let dataCorrupted = "Couldn't parse due to corrupted data!"
    static let dataNotFound = "Data Not Found"
    static let decodingError = "Couldn't decode for: {@}"
    
    /// Network Errors
    static let encodeError = "An error occurred while encoding the request data."
    static let invalidURLError = "The provided URL is not valid."
    static let requestFailedError = "The API request failed. Please try again later."
    static let noResponseError = "The API response timed out. Please check your internet connection and try again."
    static let unauthorizedError = "Your session has expired. Please log in again."
    static let unexpectedStatusCodeError = "Received an unexpected status code from the server."
    static let networkNotAvailable = "You are in offline mode. Please connect to the internet to proceed."
    static let tokenNotFoundError = "Token couldn't be found."
    static let parsingFailedError = "Data parsing failed!"
    static let defaultError = "An unknown error occurred."
    
    /// DB Transaction Status
    static let savingSucceed = "Successfully saved!"
    static let savingFailed = "Failed to save in DB!"
    static let insertionFailed = "Failed to insert in DB!"
    static let loadingFailed = "Failed to load from DB!"
    static let editingFailed = "Failed to edit the record in DB!"
    static let deletingFailed = "Failed to delete the record from DB!"
    static let existsInDB = "Record already exists in DB."
    static let notExistsInDB = "Record doesn't exists in DB to edit or delete!"
    static let noteSavingSucceed = "Successfully saved notes!"
    
    /// Others
    static let notes = "Notes"
    static let enterNotes = "Enter Notes"
    static let save = "Save"
}
