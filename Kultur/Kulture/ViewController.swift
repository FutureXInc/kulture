//
//  ViewController.swift
//  Kulture
//
//  Created by biswa on 4/29/17.
//  Copyright © 2017 FutureXInc. All rights reserved.
//

import UIKit
import Parse

class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.

        let api = API()
        api.userLogin(password: "biswa", userName: "biswa", successFunc: { (user: PFUser) in
//            api.savePost(postType: .Text, caption: "text post", kidUserId: "kid1", text: "Hi")
//            api.savePost(postType: .Image, caption: "image post", kidUserId: "kid2",
//                         image: UIImage(named: "kultureTree"))
//            api.savePost(postType: .Video, caption: "video post", kidUserId: "kid3",
//                         videoId: "KnoWRBtJ2Fo")

            api.fetchApprovedPostsForKid(kidUserId: "RM2F0AcPSo",
                                         successFunc: { (posts: [PFObject]?) in
                                            print()
                            }, errorFunc: { (error) in
                                print("\(error)")
                            })


        })
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


}

