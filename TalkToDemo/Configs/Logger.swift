//
//  Logger.swift
//  TalkToDemo
//
//  Created by Nurul Islam on 20/7/24.
//

import Foundation
import CryptoKit

extension Optional where Wrapped == String {
    var unwrapped: String {
        return (self ?? "").trimmingCharacters(in: .whitespacesAndNewlines)
    }
}

struct Logger {
    enum LogType: String, CustomStringConvertible {
        case debug = "🤖"
        case success = "🟢"
        case error = "🔴"
        case warning = "🟡"
        case info = "🟣"
        
        var description: String {
            return rawValue
        }
    }
    
    private static let encryptionKey: SymmetricKey = {
        let keyData = Data(base64Encoded: Config.constant.loggerEncryptionKey)!
        return SymmetricKey(data: keyData)
    }()
    
    private static var logFileURL: URL? {
        guard let documentsDirectory = FileManager.default.containerURL(forSecurityApplicationGroupIdentifier: Config.constant.applicationGroupIdentifier) else {
            return nil
        }
        return documentsDirectory.appendingPathComponent("logger.encrypted")
    }
    
    private static func encryptData(_ data: Data) throws -> Data {
        let sealedBox = try ChaChaPoly.seal(data, using: encryptionKey)
        return sealedBox.combined
    }
    
    private static func decryptData(_ data: Data) throws -> Data {
        let sealedBox = try ChaChaPoly.SealedBox(combined: data)
        return try ChaChaPoly.open(sealedBox, using: encryptionKey)
    }
    
    static func clearLogs() {
        guard let logFile = logFileURL else {
            return
        }
        try? FileManager.default.removeItem(at: logFile)
    }
    
    static func log(type: LogType = .info,
                    _ message: Any,
                    file: String = #file,
                    function: String = #function,
                    line: Int = #line,
                    toFile: Bool = false) {
        
        guard Config.log.enabled && !Config.isProduction else { return }
        
        var output = "\(type) \(Date().toString())"
        let filename = file.components(separatedBy: "/").last.unwrapped
        output += " \(filename):\(function):\(line) \(message)"
        
        print(output)
        
        if toFile {
            logToFile(output)
        }
    }
    
    private static func logToFile(_ message: String) {
        guard let logFile = logFileURL else {
            return
        }
        
        let data = message.data(using: .utf8)!
        let encryptedData: Data
        
        do {
            encryptedData = try encryptData(data)
        } catch {
            print("Error encrypting log data: \(error)")
            return
        }
        
        if FileManager.default.fileExists(atPath: logFile.path) {
            if let fileHandle = try? FileHandle(forWritingTo: logFile) {
                fileHandle.seekToEndOfFile()
                fileHandle.write(encryptedData)
                fileHandle.closeFile()
            }
        } else {
            try? encryptedData.write(to: logFile, options: .atomicWrite)
        }
        
        manageLogFileSize(logFile)
    }
    
    private static func manageLogFileSize(_ logFile: URL) {
        let maxLogFileSize = Config.constant.maxLogFileSize
        guard let fileAttributes = try? FileManager.default.attributesOfItem(atPath: logFile.path),
              let fileSize = fileAttributes[FileAttributeKey.size] as? Int,
              fileSize > maxLogFileSize else {
            return
        }
        
        /// Implement log rotation logic here
        /// Create a new log file and delete the old one
        clearLogs()
    }
}

