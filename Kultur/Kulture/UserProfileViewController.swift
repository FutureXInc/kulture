//
//  UserProfileViewController.swift
//  Kulture
//
//  Created by Bhalla, Kapil on 5/15/17.
//  Copyright © 2017 FutureXInc. All rights reserved.
//

import UIKit
import AFNetworking

class UserProfileViewController: UIViewController {

    var user: User!

    @IBOutlet weak var closeImage: UIImageView!
    @IBOutlet weak var name: UILabel!
    @IBOutlet weak var avatar: UIImageView!

    override func viewDidLoad() {
        super.viewDidLoad()

        if let user = user {
            name.text = API.sharedInstance.toUpperCase(user.firstName)

            avatar.setImageWith(user.profileImageURL)

            avatar.layer.cornerRadius = avatar.frame.width / 2.0
            avatar.layer.masksToBounds = true
        }

        let gesture1 = UITapGestureRecognizer()
        gesture1.addTarget(self, action: #selector(closeTap))
        self.closeImage.addGestureRecognizer(gesture1)
    }

    func closeTap() {
        self.dismiss(animated: true, completion: nil)
    }

    



}
