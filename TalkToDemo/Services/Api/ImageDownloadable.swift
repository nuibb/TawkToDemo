//
//  ImageDownloader.swift
//  TalkToDemo
//
//  Created by Nurul Islam on 12/8/24.
//

import UIKit

protocol ImageDownloadable {
    func downloadImage(from url: URL, completion: @escaping (UIImage?) -> Void)
    func cancelDownload(for url: URL)
}
