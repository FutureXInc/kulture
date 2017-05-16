//
//  KidContentViewController.swift
//  Kulture
//
//  Created by Pattanashetty, Sadananda on 5/12/17.
//  Copyright © 2017 FutureXInc. All rights reserved.
//

import UIKit
import Parse
import AFNetworking
import ParseUI

class KidImageContentViewController: UIViewController {

    @IBOutlet weak var imageContent: PFImageView!

    @IBOutlet weak var contentDesc: UILabel!
    @IBOutlet weak var back: UIImageView!

    @IBOutlet weak var contentHeader: UILabel!
    
    @IBOutlet weak var likeImage: UIImageView!
    @IBOutlet weak var heightCons: NSLayoutConstraint!
    @IBOutlet weak var relation: UILabel!
    @IBOutlet weak var agentName: UILabel!
    @IBOutlet weak var avatar: UIImageView!
    @IBOutlet weak var likeImg: UIImageView!
    var isLiked: Bool = false

    var post: PFObject!

    override func viewDidLoad() {
        super.viewDidLoad()
        loadStuff()

        let gesture = UITapGestureRecognizer()
        gesture.addTarget(self, action: #selector(backTap))
        self.back.addGestureRecognizer(gesture)

        let gestureX = UITapGestureRecognizer()
        gestureX.addTarget(self, action: #selector(likeTapped))
        self.likeImg.addGestureRecognizer(gestureX)

    }

    func backTap() {
        self.dismiss(animated: true, completion: nil)
    }

    func likeTapped() {
        if isLiked {
            likeImg.image = #imageLiteral(resourceName: "Like")
        }
        else {
            likeImg.image = #imageLiteral(resourceName: "Liked")

        }
    }

    func loadStuff() {
        let type = post["postType"]! as! Int16

        switch type {

        case 1:
            agentName.text = "Sada"
            //heightCons.constant = 1
            
             isLiked = post["isLiked"] as? Bool ?? false
            imageContent.image = #imageLiteral(resourceName: "treegreen")
            if isLiked {
                likeImg.image = #imageLiteral(resourceName: "Liked")
            }
            else {
                likeImg.image = #imageLiteral(resourceName: "Like")
            }


        case 2:
            agentName.text = "Sada"
            let img = post["image"] as! PFFile
            
            imageContent.file = img
            imageContent.loadInBackground()
             isLiked = post["isLiked"] as? Bool ?? false

            if isLiked {
                likeImg.image = #imageLiteral(resourceName: "Liked")
            }
            else {
                likeImg.image = #imageLiteral(resourceName: "Like")
            }

 
            
        default:

            print()
           
        }

    }



    
}
