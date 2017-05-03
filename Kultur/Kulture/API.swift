//
//  API.swift
//  Kulture
//
//  Created by bis on 5/2/17.
//  Copyright © 2017 FutureXInc. All rights reserved.
//

import Foundation
import Parse

typealias EmptyFunc = () -> ()
typealias ErrorFunc = (Error) -> ()


enum PostType : Int {
    case Text = 1
    case Image = 2
    case Video = 3
}

enum RelationShipType: String {
    case Kid = "KID"
    case Friend = "FRIEND"
}

enum ApprovalState: Int {
    case Unmoderated = 0
    case Approved = 1
    case Rejected = 2
}


class APIError: Error {
    var localizedDescription: String?
    
    init(_ description: String) {
        self.localizedDescription = description
    }
}

class API: NSObject {
 
    // USER //
    
    func currentUser() -> PFUser? {
        return  PFUser.current()
    }
    
    func userSignUp(email: String, password: String, userName: String,
                    successFunc:  Optional<(PFUser) -> ()> = nil,
                    errorFunc: ErrorFunc? = nil) {
        let user = PFUser()
        user.username = userName
        user.password = password
        user.email = email
        user.signUpInBackground { (success: Bool, error: Error?) in
            if let error = error {
                errorFunc?(error)
            }
            else {
                successFunc?(user)
            }
        }
    }
    
    func userLogin(password: String, userName: String,
                   successFunc: Optional<(PFUser) -> ()> = nil,
                   errorFunc: ErrorFunc? = nil
        ) {
        PFUser.logInWithUsername(inBackground: userName, password: password)
        { (user: PFUser?, error:Error?) in
            if let error = error {
                errorFunc?(error)
            }
            else if let user = user {
                successFunc?(user)
            }
            else {
                errorFunc?(APIError("Server error: User not found"))
            }
        }
    }
    
    func uesrLogOut() {
        if PFUser.current() != nil  {
            PFUser.logOut()
        }
    }
    
    // RELATIONSHIPS //
    func addRelationShip(userObjecId2: String, userObjectId2: String) {
        
    }
    
    // POST //
    
    func getPFFileFromImage(_ image: UIImage?) -> PFFile? {
        if let image = image {
            if let imageData = UIImagePNGRepresentation(image) {
                return PFFile(name: "image.png", data: imageData)
            }
        }
        return nil
    }

    func savePost(postType: PostType,
                  caption: String,
                  kidUserId: String,
                  text: String? = nil,
                  image: UIImage? = nil,
                  videoUrl: String? = nil,
                  successFunc: EmptyFunc? = nil,
                  errorFunc: ErrorFunc? = nil) {
        let post = PFObject(className: "Post")
        switch postType {
        case .Text:
            if let text = text {
                post["text"] = text
            }
            else {
                errorFunc?(APIError("Missing text in post"))
                return
            }
        case .Image:
            if let image = image {
                post["image"] = self.getPFFileFromImage(image)
            } else {
                errorFunc?(APIError("Missing Image in post"))
                return
            }
        case .Video:
            if let videoUrl = videoUrl {
                post["video"] = videoUrl
            }
            else {
                errorFunc?(APIError("Missing Video in post"))
                return
            }
        default:
            errorFunc?(APIError("Empty or Invalid post type"))
            return
        }
        post["familyMemberId"] = self.currentUser()!.objectId!
        post["kidUserId"] = kidUserId
        post["caption"] = caption
        post["likesCount"] = 0
        post["approvalState"] = ApprovalState.Unmoderated
        post.saveInBackground { (success: Bool, error: Error?) in
            if success {
                successFunc?()
            }
            else if let error = error {
                errorFunc?(error)
            }
        }
    }
    
    func _fetchPosts(predicate: String,
                     limit: Int?,
                     successFunc: @escaping ([PFObject]?) -> (),
                     errorFunc: ErrorFunc?) {
        let query = PFQuery(className: "Post", predicate: NSPredicate(format: predicate))
        if let limit = limit {
            query.limit = limit
        }
        query.order(byDescending: "createdAt")
        query.findObjectsInBackground { (posts: [PFObject]?, error: Error?) in
            if let error = error {
                errorFunc?(error)
            }
            else {
                successFunc(posts)
            }
        }
    }
    
    func fetchApprovedPostsForKid(kidUserId: String,
                                  limit: Int? = nil,
                                  successFunc: @escaping ([PFObject]?) -> (),
                                  errorFunc: ErrorFunc?) {
        let predicate = "kidUserId = \(kidUserId) AND approvalState = \(ApprovalState.Approved)"
        return _fetchPosts(predicate: predicate,
                           limit: limit,
                           successFunc: successFunc, errorFunc: errorFunc)
    }
    
    func fetchUnModeratedPostsForKid(kidUserId: String,
                                     limit: Int? = nil,
                                     successFunc: @escaping ([PFObject]?) -> (),
                                     errorFunc: ErrorFunc?) {
        let predicate = "kidUserId = \(kidUserId) AND approvalState = \(ApprovalState.Unmoderated)"
        return _fetchPosts(predicate: predicate,
                           limit: limit,
                           successFunc: successFunc, errorFunc: errorFunc)
    }
    
    func fetchPostsByFamilyMember(familyMemberId: String,
                                  limit: Int? = nil,
                                  successFunc: @escaping ([PFObject]?) -> (),
                                  errorFunc: ErrorFunc?) {
        let predicate = "familyMemberId = \(familyMemberId)"
        return _fetchPosts(predicate: predicate,
                           limit: limit,
                           successFunc: successFunc, errorFunc: errorFunc)
    }
    
    func ApprovePost(postId: String) {
        // todo
    }
    
    
}
