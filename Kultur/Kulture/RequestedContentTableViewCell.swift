//
//  RequestedContentTableViewCell.swift
//  Kulture
//
//  Created by bis on 5/13/17.
//  Copyright © 2017 FutureXInc. All rights reserved.
//

import UIKit
import ParseUI

class RequestedContentTableViewCell: UITableViewCell {

    @IBOutlet weak var kidNameLabel: UILabel!
    @IBOutlet weak var kidProfileImageView: PFImageView!
    @IBOutlet weak var messageLabel: UILabel!
    @IBOutlet weak var tagLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
