//
//  ImageFetcher.swift
//  TalkToDemo
//
//  Created by Nurul Islam on 12/8/24.
//

import Foundation
import UIKit

class ImageDownloadManager: ImageFetchable, ImageCaching {
    public static var shared = ImageDownloadManager()
    private let downloadQueue = DispatchQueue(
        label: "com.TalkToDemo.imageDownloadQueue", attributes: .concurrent
    )
    private var downloadTasks: [URL: Task<Void, Never>] = [:]
    private var cache: NSCache<NSURL, UIImage> = NSCache<NSURL, UIImage>()
    
    init() {
        /// Set memory limits for the cache
        cache.countLimit = 100 /// Max number of images to store in memory
        cache.totalCostLimit = 50 * 1024 * 1024 /// Max 50MB memory
    }
    
    // MARK: - ImageFetchable
    func downloadImage(from url: URL, completion: @escaping (UIImage?) -> Void) {
            /// Check memory cache first
            if let cachedImage = cache.object(forKey: url as NSURL) {
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
                        self.cache.setObject(image, forKey: url as NSURL)
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
    
    // MARK: - ImageCaching
    func cacheImage(_ image: UIImage, for url: URL) {
        cache.setObject(image, forKey: url as NSURL)
    }
    
    func loadImage(for url: URL) -> UIImage? {
        return cache.object(forKey: url as NSURL)
    }
}
