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
        let image = UIImage(systemName: "pencil.circle.fill")
        if let image = image, let invertedImage = image.invertImage {
            self.avatar.image = invertedImage
        } else {
            self.avatar.image = image
        }
        
        self.avatar.backgroundColor = UIColor.text
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
}
