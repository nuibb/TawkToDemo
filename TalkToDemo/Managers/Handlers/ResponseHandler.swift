//
//  ResponseHandler.swift
//  TalkToDemo
//
//  Created by Nurul Islam on 20/7/24.
//

import Foundation

protocol ResponseHandler: AnyObject {
    var showToast: Bool { get set }
    var isRequesting: Bool { get set }
    var toastMessage: String { get set }
    
    func handleResponse<T>(
        response: Swift.Result<T, RequestError>,
        callback: @escaping (T) -> Void) async
}

extension ResponseHandler {
    func handleResponse<T>(
        response: Swift.Result<T, RequestError>,
        callback: @escaping (T) -> Void) async {
        if case .success(let result) = response {
            DispatchQueue.main.async { [weak self] in
                guard let self else { return }
                self.isRequesting = false
                callback(result)
            }
        } else if case .failure(let error) = response {
            Logger.log(type: .error, "[API][Request] failed: \(error.status)")
            self.displayMessage(error.status)
        } else {
            Logger.log(type: .error, "[API][Request] failed")
            self.displayMessage(RequestError.unknown.status)
        }
    }
    
    private func displayMessage(_ msg: String) {
        DispatchQueue.main.async { [weak self] in
            guard let self else { return }
            self.isRequesting = false
            self.toastMessage = msg
            self.showToast = true
        }

        Utils.after(seconds: 5.0) { [weak self] in
            guard let self else { return }
            self.toastMessage = ""
        }
    }
}
