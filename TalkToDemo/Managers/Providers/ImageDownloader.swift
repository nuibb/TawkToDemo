//
//  ImageFetcher.swift
//  TalkToDemo
//
//  Created by Nurul Islam on 12/8/24.
//

import Foundation
import UIKit

class ImageDownloader: ImageDownloadable {
    public static var shared = ImageDownloader()
    private let downloadQueue = DispatchQueue(
        label: "com.TalkToDemo.imageDownloadQueue", attributes: .concurrent
    )
    private var downloadTasks: [URL: Task<Void, Never>] = [:]
    
    // MARK: - ImageFetchable
    func downloadImage(from url: URL, completion: @escaping (UIImage?) -> Void) {
        /// Check memory cache first
        if let cachedImage = url.loadImage() {
            completion(cachedImage)
            return
        }
        
        /// Use sync on the concurrent queue to ensure thread safety
        downloadQueue.sync {
            /// Prevent redundant requests
            if let existingTask = downloadTasks[url] {
                existingTask.cancel()
            }
            
            /// Create and start a new download task
            let task = Task {
                defer {
                    self.downloadQueue.async(flags: .barrier) {
                        self.downloadTasks.removeValue(forKey: url)
                    }
                }
                
                do {
                    let image = try await url.downloadImage()
                    try url.cache(image)
                    DispatchQueue.main.async {
                        completion(image)
                    }
                } catch {
                    Logger.log(type: .error, "Image download failed: \(error.localizedDescription)")
                    DispatchQueue.main.async {
                        completion(nil)
                    }
                }
            }
            
            downloadTasks[url] = task
        }
    }
    
    func cancelDownload(for url: URL) {
        /// Use sync on the concurrent queue to ensure thread safety
        downloadQueue.sync {
            downloadTasks[url]?.cancel()
            downloadTasks.removeValue(forKey: url)
        }
    }
}
