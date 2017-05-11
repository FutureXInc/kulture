//
//  DataManager.swift
//  Kulture
//
//  Created by Pattanashetty, Sadananda on 5/10/17.
//  Copyright © 2017 FutureXInc. All rights reserved.
//

import Foundation
import Parse

protocol DataManagerListener: class {
    func finishedFetchingData(result : Result)
}

enum Result {
    case Success([PFObject])
    case Failure(String)
}

class DataManager {

    var delegate: DataManagerListener?

    static var sharedInstance = DataManager()

    func getPosts(kidUserId: String = "") {

        let api = API()
        api.userLogin(password: "biswa", userName: "biswa", successFunc: { (user: PFUser) in

            api.fetchApprovedPostsForKid(kidUserId: "RM2F0AcPSo",
                                         successFunc: { (posts: [PFObject]?) in
                                            print("Data ready!")
                                            if let posts = posts {
                                                self.delegate?.finishedFetchingData(result: .Success(posts))
                                            }
                                            else {
                                                self.delegate?.finishedFetchingData(result: .Failure("Something went wrong!"))
                                            }

            },
              errorFunc: { (error) in
               print("\(error)")
               self.delegate?.finishedFetchingData(result: .Failure("Something went wrong!"))
            })
        })
        
    }

}
