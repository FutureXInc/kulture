//
//  UserCache.swift
//  Kulture
//
//  Created by bis on 5/16/17.
//  Copyright © 2017 FutureXInc. All rights reserved.
//

import UIKit
import Parse

class UserCache: NSObject {
    
    static let sharedInstance =  UserCache()
    
    static var currentUser: User? = nil
    
    var me: String!
    var kidIds: [String] = []
    var parentIds: [String] = []
    var familyMemberIds: [String] = []
    var userForId: [String: User] = [:]
    var relationShips: [(id1: String, id2: String, relation: RelationShipType)] = []
    
    func processRelations(relations: [PFObject]) {
        for relation in relations {
            let relationshipType = RelationShipType(rawValue: relation["relation"] as! String)!
            let id1 = relation["id1"] as! String
            let id2 = relation["id2"] as! String
            relationShips.append((id1: id1, id2:id2, relation: relationshipType))
            if id1 == self.me {
                switch relationshipType {
                case .Kid:
                    kidIds.append(id2)
                case .Family:
                    familyMemberIds.append(id2)
                }
            }
            else if id2 == me {
                parentIds.append(id2)
            }
        }
    }
    
    func processUsers(users: [PFObject]) {
        for user in users {
            let userId = user["userId"] as! String
            let userObj = User(firstName: user["firstName"]  as! String,
                               lastName: user["lastName"]  as! String,
                               userName: user["userName"] as! String,
                               userId: userId,
                               age: user["age"] as! Int,
                               role: user["role"] as! Int,
                               profileImageURL: user["profileImageUrl"] as! String,
                               emailID: user["email"] as! String,
                               gender: user["gender"] as! String)
            userForId[user["userId"] as! String] = userObj
            if userId == me {
                UserCache.currentUser = userObj
            }
        }
    }
    
    func prePopulateCache(userId: String, successFunc: EmptyFunc?) {
        me = userId
        API.sharedInstance.getAllRelations(
            userId: userId, successFunc:{ (relations: [PFObject]?) in
                API.sharedInstance.getUsers(successFunc: { (users: [PFObject]?) in
                    if let users = users {
                        self.processUsers(users: users)
                        successFunc?()
                    }
                }) { (error: Error) in
                    print("\(error)")
                }
                if let relations = relations {
                    self.processRelations(relations: relations)
                }
        }) { (error: Error) in
            print("\(error)")
        }
        
    }
    
    func getUser(_ userId: String) -> User? {
        return userForId[userId]
    }
    
    func getParentForKid(kidId: String) -> User? {
        for tup in relationShips {
            if tup.id2 == kidId && tup.relation == .Kid {
                return getUser(tup.id1)
            }
        }
        return nil
    }
    
    
}
