//
//  User.swift
//  Kulture
//
//  Created by Bhalla, Kapil on 5/7/17.
//  Copyright © 2017 FutureXInc. All rights reserved.
//

import UIKit

class User: NSObject {

    var userId: String
    var userName: String
    var profileImageURL: URL
    var role: UserRole
    var firstName: String
    var lastName: String
    var emailID: String
    var gender: String
    
    init(firstName: String, lastName: String,
         userName: String, userId: String,
         age: Int, role: Int,
         profileImageURL: String,
         emailID: String,
         gender: String) {
        self.userId = userId
        self.firstName = firstName
        self.profileImageURL = URL(string: profileImageURL)!
        self.role = UserRole(rawValue: role)!
        self.firstName = firstName
        self.lastName = lastName
        self.emailID = emailID
        self.gender = gender
        self.userName = userName
    }
    
    static var _currentUser: User?
    
    class var currentUser: User {
        get {
            if (_currentUser == nil) {
                // read currentUser from user defaults
                
                // create a user
                
                let tempUser: User = User(firstName: "KapiL",
                                          lastName: "Bhalla",
                                          userName: "kapil",
                                          userId: "blah",
                                          age: 2,
                                          role: UserRole.Kid.rawValue,
                                          profileImageURL: "http://aa.com/aa",
                                          emailID: "kapil_bhalla@intuit.com",
                                          gender: "M")
                
                _currentUser = tempUser
            }
            return _currentUser!
        }
        
        set (aUser){
            _currentUser = aUser
        }
    }
}
