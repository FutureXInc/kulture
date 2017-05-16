//
//  UserProfileTableViewCell.swift
//  Kulture
//
//  Created by Bhalla, Kapil on 5/15/17.
//  Copyright © 2017 FutureXInc. All rights reserved.
//

import UIKit

class UserProfileTableViewCell: UITableViewCell {

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    @IBOutlet weak var userName: UILabel!

    @IBOutlet weak var userNameLabel: NSLayoutConstraint!
    @IBOutlet weak var userImage: UIImageView!
}
