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

    func getPosts(filter: Filter = .latest) {
        API.sharedInstance.fetchApprovedPostsForKid(
            kidUserId: UserCache.sharedInstance.me,
            filter: filter,
            successFunc: { (posts: [PFObject]?) in
                print("Data ready for getPosts! \(posts?.count ?? 0) rows")
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
    }

    func getUnapprovedPosts(filter: Filter = .latest) {
        API.sharedInstance.fetchUnModeratedPostsForParent(
            parentId: UserCache.sharedInstance.me,
            successFunc: { (posts: [PFObject]?) in
                print("Data ready for getUnapprovedPosts! \(posts?.count ?? 0) rows")
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
    }
}
