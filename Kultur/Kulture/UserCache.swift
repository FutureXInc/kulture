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
    
    var me: String!
    var kidIds: [String] = []
    var parentIds: [String] = []
    var familyMemberIds: [String] = []
    var userForId: [String: User] = [:]
    
    func processRelations(relations: [PFObject]) {
        for relation in relations {
            let relationshipType = RelationShipType(rawValue: relation["relation"] as! String)!
            let id1 = relation["id1"] as! String
            let id2 = relation["id2"] as! String
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
            userForId[user["userId"] as! String] = User(firstName: user["firstName"]  as! String,
                                             lastName: user["lastName"]  as! String,
                                             userName: user["userName"] as! String,
                                             userId: user["userId"] as! String,
                                             age: user["age"] as! Int,
                                             role: user["role"] as! Int,
                                             profileImageURL: user["profileImageUrl"] as! String,
                                             emailID: user["email"] as! String,
                                             gender: user["gender"] as! String)
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
        return nil
    }
    
    
}
