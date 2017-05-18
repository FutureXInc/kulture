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


enum UserRole : Int {
    case None = 0
    case Parent = 1
    case Kid = 2
    case Family = 3
}


enum PostType : Int {
    case Text = 1
    case Image = 2
    case Video = 3
}

enum RelationShipType: String {
    case Kid = "KID"
    case Family = "FAMILY"
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


/* 
 Sample Usage: 
 ------------------------------------------------------------------------------------------------
 let api = API()
 api.userLogin(password: "biswa", userName: "biswa", successFunc: { (user: PFUser) in
    api.savePost(postType: .Text, caption: "text post", kidUserId: "kid1", text: "Hi")
    api.savePost(postType: .Image, caption: "image post", kidUserId: "kid2",
                 image: UIImage(named: "kultureTree"))
    api.savePost(postType: .Video, caption: "video post", kidUserId: "kid3",
                 videoId: "KnoWRBtJ2Fo")
 }) { (error: Error) in
 print("\(error)")
 }
 ------------------------------------------------------------------------------------------------
 */
class API: NSObject {
 
    static let sharedInstance = API()
    
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
    
    func getUsers(successFunc: @escaping (_ users: [PFObject]?) -> (),
                  errorFunc: ErrorFunc?) {
        let query = PFQuery(className: "UserProfile")
        query.findObjectsInBackground { ( users: [PFObject]?, error: Error?) in
            if let error = error {
                errorFunc?(error)
            }
            else {
                successFunc(users)
            }
        }
    }
    
    // RELATIONSHIPS //
    func addRelationShip(userObjecId2: String, userObjectId2: String) {
        
    }
    
    func getAllRelations(userId: String,
                         successFunc: @escaping ([PFObject]?) -> (),
                         errorFunc: ErrorFunc?) {
        let predicate = NSPredicate.init(format: "id1 ==[c] %@ OR id2 ==[c] %@", userId, userId)
        let query = PFQuery(className: "Relation", predicate: predicate)
        query.findObjectsInBackground { ( relations: [PFObject]?, error: Error?) in
            if let error = error {
                errorFunc?(error)
            }
            else {
                successFunc(relations)
            }
        }
    }
    
    // POST //
    
    func getPFFileFromImage(_ image: UIImage?) -> PFFile? {
        if let image = image {
            if let imageData = UIImageJPEGRepresentation(image, 0.1) {
                return PFFile(name: "image.jpg", data: imageData)
            }
        }
        return nil
    }

    
    
    
    // This is the fucntion to save a new category
    func saveContentCategory (aContentCategoryObject: ContentCategoryModel, successFunc: @escaping (ContentCategoryModel) -> (),
                       errorFunc: ErrorFunc?){
        let contentCategoryDBObject = PFObject(className: ContentCategoryAPI.TABLENAME)

        // set the details
        contentCategoryDBObject[ContentCategoryAPI.COLUMN_CATEGORY_NAME] = aContentCategoryObject.categoryName
        contentCategoryDBObject[ContentCategoryAPI.COLUMN_CATEGORY_DESCRIPTION] = aContentCategoryObject.categoryDescription
        
        contentCategoryDBObject.saveInBackground { (success: Bool, error: Error?) in
            if success {
                successFunc(aContentCategoryObject)
            }
            else if let error = error {
                errorFunc?(error)
            }
        }
    }

    func savePost(postType: PostType,
                  caption: String,
                  kidUserId: String,
                  text: String? = nil,
                  image: UIImage? = nil,
                  videoId: String? = nil,
                  successFunc: Optional<(String) -> ()> = nil,
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
            if let videoId = videoId {
                post["videoId"] = videoId
            }
            else {
                errorFunc?(APIError("Missing Youtube VideoId in post"))
                return
            }
        default:
            errorFunc?(APIError("Empty or Invalid post type"))
            return
        }
        post["postType"] = postType.rawValue
        post["familyMemberId"] = self.currentUser()!.objectId!
        post["kidUserId"] = kidUserId
        post["caption"] = caption
        post["likesCount"] = 0
        post["approvalState"] = ApprovalState.Unmoderated.rawValue
        post.saveInBackground { (success: Bool, error: Error?) in
            if success {
                successFunc?(post.objectId!)
            }
            else if let error = error {
                errorFunc?(error)
            }
        }
    }
    
    func _fetchPosts(predicate: NSPredicate,
                     limit: Int?,
                     successFunc: @escaping ([PFObject]?) -> (),
                     errorFunc: ErrorFunc?) {
        let query = PFQuery(className: "Post", predicate: predicate)
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
    
    func fetchKidWithID (predicate: NSPredicate,
                       successFunc: @escaping (PFObject) -> (),
                       errorFunc: ErrorFunc?) {
        let query = PFQuery(className: "User", predicate: predicate)
        
        query.findObjectsInBackground { (posts: [PFObject]?, error: Error?) in
            if let error = error {
                errorFunc?(error)
            }
            else {
                successFunc((posts?[0])!)
            }
        }

    }
    
    func fetchApprovedPostsForKid(kidUserId: String,
                                  limit: Int? = nil,  filter: Filter,
                                  successFunc: @escaping ([PFObject]?) -> (),
                                  errorFunc: ErrorFunc?) {

        var predicate = NSPredicate.init(format: "kidUserId ==[c] %@ AND approvalState = %d", kidUserId, ApprovalState.Approved.rawValue)

        switch filter {
            case .fun:
                predicate = NSPredicate.init(format: "kidUserId ==[c] %@ AND approvalState = %d AND tag = 'FUN'", kidUserId, ApprovalState.Approved.rawValue)

            case .latest:
                predicate = NSPredicate.init(format: "kidUserId ==[c] %@ AND approvalState = %d", kidUserId, ApprovalState.Approved.rawValue)

            case .liked:
                predicate = NSPredicate.init(format: "kidUserId ==[c] %@ AND approvalState = %d AND isLiked = true", kidUserId, ApprovalState.Approved.rawValue)
        }

        return _fetchPosts(predicate: predicate,
                           limit: limit,
                           successFunc: successFunc, errorFunc: errorFunc)
    }
    
    func fetchUnModeratedPostsForParent(parentId: String,
                                        limit: Int? = nil,
                                        successFunc: @escaping ([PFObject]?) -> (),
                                        errorFunc: ErrorFunc?) {
        let predicate = NSPredicate.init(format: "parentId ==[c] %@ AND approvalState = %d", parentId, ApprovalState.Unmoderated.rawValue)
        return _fetchPosts(predicate: predicate,
                           limit: limit,
                           successFunc: successFunc, errorFunc: errorFunc)
    }
    
    func fetchPostsForParent(parentId: String,
                             limit: Int? = nil,
                             successFunc: @escaping ([PFObject]?) -> (),
                             errorFunc: ErrorFunc?) {
        let predicate = NSPredicate.init(format: "parentId ==[c] %@  AND approvalState = %d", parentId,
                                         ApprovalState.Approved.rawValue)
        return _fetchPosts(predicate: predicate,
                           limit: limit,
                           successFunc: successFunc, errorFunc: errorFunc)
    }

    func fetchPostsByFamilyMember(familyMemberId: String,
                                  limit: Int? = nil,
                                  successFunc: @escaping ([PFObject]?) -> (),
                                  errorFunc: ErrorFunc?) {
        let predicate = NSPredicate.init(format: "familyMemberId ==[c] %@", familyMemberId)
        return _fetchPosts(predicate: predicate,
                           limit: limit,
                           successFunc: successFunc, errorFunc: errorFunc)
    }
    
    func changePostApproval(post: PFObject, approved: Bool,
                            successFunc: EmptyFunc? = nil,
                            errorFunc: ErrorFunc? = nil) {
        post["approvalState"] = approved ? ApprovalState.Approved.rawValue : ApprovalState.Rejected.rawValue
        post.saveInBackground()
    }
    
    func fetchContentCategory (successFunc: @escaping ([PFObject]?) -> (),
                               errorFunc: ErrorFunc?) {
        let query = PFQuery(className: "contentCategory")
        
        query.findObjectsInBackground { (categories: [PFObject]?, error: Error?) in
            if let error = error {
                errorFunc?(error)
            }
            else {
                successFunc(categories)
            }
        }
    }
    
    func fetchNewContentRequests(userId: String,
                                 successFunc: @escaping ([PFObject]?) -> (),
                                 errorFunc: ErrorFunc?) {
        let predicate = NSPredicate.init(format: "familyMemberId == [c] %@ AND postId = nil ",
                                         userId)
        let query = PFQuery(className: "ContentRequest", predicate: predicate)
        query.findObjectsInBackground { ( contentRequests: [PFObject]?, error: Error?) in
            if let error = error {
                errorFunc?(error)
            }
            else {
                successFunc(contentRequests)
            }
        }
    }
    
    func saveContentRequest(kidUserId: String,
                            familyMemberId: String,
                            msg: String,
                            tag: String,
                            errorFunc: ErrorFunc?,
                            successFunc: EmptyFunc?) {
        let contentRequest = PFObject(className: "ContentRequest")
        contentRequest["kidUserId"] = kidUserId
        contentRequest["tag"] = tag
        contentRequest["message"] = msg
        contentRequest["familyMemberId"] = familyMemberId
        contentRequest["parentId"] = UserCache.sharedInstance.me
        contentRequest.saveInBackground { (success: Bool, error: Error?) in
            if success {
                successFunc?()
            }
            else if let error = error {
                errorFunc?(error)
            }
        }
    }

    func toUpperCase(_ nameOfString: String) -> String {
        return String(nameOfString.characters.prefix(1)).uppercased() + String(nameOfString.characters.dropFirst())
    }


}
