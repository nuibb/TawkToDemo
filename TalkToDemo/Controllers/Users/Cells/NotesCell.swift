//
//  NotesCell.swift
//  TalkToDemo
//
//  Created by Nurul Islam on 22/7/24.
//

import UIKit

class NotesCell: UITableViewCell, UserCell  {
    @IBOutlet weak var avatar: UIImageView!
    @IBOutlet weak var userName: UILabel!
    @IBOutlet weak var userDetails: UILabel!
    @IBOutlet weak var noteIcon: UIImageView!
    
    func configure(with user: User) {
        
        if let url = user.avatar, !url.isEmpty,
           let imageURL = URL(string: url) {
            
            /// Show cached image first if available
            if let image = imageURL.loadImage() {
                self.avatar.image = image
            } else {
                self.downloadAndCache(imageURL)
            }
            
        } else {
            self.avatar.image = UIImage(named: "avatar")
        }
        
        self.userName.text = user.username
        self.userDetails.text = user.details
        
        if user.seen {
            self.avatar.alpha = 0.3
            self.userName.alpha = 0.3
            self.userDetails.alpha = 0.3
        } else {
            self.avatar.alpha = 1.0
            self.userName.alpha = 1.0
            self.userDetails.alpha = 1.0
        }
    }
    
    private func downloadAndCache(_ url: URL) {
        Task {
            do {
                let image = try await url.downloadImage()
                DispatchQueue.main.async { [weak self] in
                    guard let self else { return }
                    self.avatar.image = image
                }
                try url.cache(image)
            } catch {
                Logger.log(type: .error, "Image download failed with error: \(error.localizedDescription)")
            }
        }
    }
}
