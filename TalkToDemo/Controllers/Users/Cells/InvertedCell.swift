//
//  InvertedCell.swift
//  TalkToDemo
//
//  Created by Nurul Islam on 22/7/24.
//

import UIKit

class InvertedCell: UITableViewCell, UserCell {
    @IBOutlet weak var avatar: UIImageView!
    @IBOutlet weak var userName: UILabel!
    @IBOutlet weak var userDetails: UILabel!

    func configure(with user: User) {
        if let url = user.avatar, !url.isEmpty,
           let imageURL = URL(string: url) {
            self.downloadAndCache(imageURL)
        }
        
        self.userName.text = user.username
        self.userDetails.text = user.details ?? ""
        
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
        ImageDownloader.shared.downloadImage(from: url) { [weak self] image in
            guard let self = self else { return }
            if let invertedImage = image?.invertImage {
                self.avatar.image = invertedImage
            }
        }
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        self.avatar.image = UIImage(named: "avatar")
        self.avatar.tintColor = UIColor(named: "primaryColor")
    }
}
