//
//  RequestedContentTableViewCell.swift
//  Kulture
//
//  Created by bis on 5/13/17.
//  Copyright © 2017 FutureXInc. All rights reserved.
//

import UIKit
import ParseUI
import Parse


class RequestedContentTableViewCell: UITableViewCell {

    @IBOutlet weak var kidNameLabel: UILabel!
    @IBOutlet weak var kidProfileImageView: PFImageView!
    @IBOutlet weak var messageLabel: UILabel!
    @IBOutlet weak var tagLabel: UILabel!
    var _contentRequest: PFObject?
    
    var contentRequest: PFObject? {
        set {
            _contentRequest = newValue
            let kid = UserCache.sharedInstance.getUser(newValue!["kidUserId"] as! String)!
            kidNameLabel.text = API.sharedInstance.toUpperCase(kid.firstName)
            kidProfileImageView.setImageWith(kid.profileImageURL)
            messageLabel.text = newValue!["message"] as? String
            tagLabel.text = newValue!["tag"] as? String

            kidProfileImageView.layer.cornerRadius = kidProfileImageView.frame.width / 2.0
            kidProfileImageView.layer.masksToBounds = true
        }
        get {
            return _contentRequest
        }
    }
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
