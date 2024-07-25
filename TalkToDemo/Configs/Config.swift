//
//  Config.swift
//  TalkToDemo
//
//  Created by Nurul Islam on 20/7/24.
//

import Foundation

struct Config {
    static let shared = Config()
    private init() {}

    struct log {
        static let enabled = true
    }

    static var isProduction: Bool {
        #if DEBUG
            return false
        #else
            guard let appStoreReceiptURL = Bundle.main.appStoreReceiptURL else {
                return true
            }
        return !appStoreReceiptURL.lastPathComponent.contains("sandboxReceipt")
        #endif
    }

    private static var endpoint: String = BaseUrl.DEV.rawValue
    
    /// Static base url for each environment
    private enum BaseUrl: String {
        case DEV = "api.github.com"
        case PROD = "api.github-prod.com" ///not defined yet
    }

    struct url {
        static var scheme: String { "https" }
        static var host: String { endpoint }
        static var accessToken: String = ""
        static var applicationType: String {
            return "application/json"
        }
    }
}

// MARK: Constant
extension Config {
    struct constant {
        static var applicationGroupIdentifier: String {
            guard let applicationGroupIdentifier = Bundle.main.object(forInfoDictionaryKey: "applicationGroupIdentifier") as? String else {
                fatalError("applicationGroupIdentifier should be defined")
            }
            return applicationGroupIdentifier
        }

        static let loggerEncryptionKey = "Av+pFxM1WBVbgyAwguM1EdIcYhRTjYXVlN0O/QHzP0x+b4="
        static let maxLogFileSize = 1024 * 1024 /// 1 MB
    }
}
