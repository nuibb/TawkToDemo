//
//  UserCell.swift
//  TalkToDemo
//
//  Created by Nurul Islam on 19/7/24.
//

import UIKit

class NormalCell: UITableViewCell, UserCell {
    @IBOutlet weak var avatar: UIImageView!
    @IBOutlet weak var userName: UILabel!
    @IBOutlet weak var userDetails: UILabel!
    
    func configure(with user: User) {
        self.avatar.image = UIImage(systemName: "pencil.circle.fill")
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
