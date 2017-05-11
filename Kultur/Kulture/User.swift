//
//  User.swift
//  Kulture
//
//  Created by Bhalla, Kapil on 5/7/17.
//  Copyright © 2017 FutureXInc. All rights reserved.
//

import UIKit

class User: NSObject {

    var firstName: String = ""
    var lastName: String = ""
    var emailID: String = ""
    var role: UserRole = UserRole.none
    
    
    // This enum holds the set of roles a user can play in the system
    enum UserRole {
        case Parent, Kid, Family, none
    }
    
    static var _currentUser: User?
    
    class var currentUser: User {
        get {
            if (_currentUser == nil) {
                // read currentUser from user defaults
                
                // create a user
                
                let tempUser: User = User()
                tempUser.firstName = "KapiL"
                tempUser.lastName = "Bhalla"
                tempUser.emailID = "kapil_bhalla@intuit.com"
                tempUser.role = User.UserRole.Kid
                
                _currentUser = tempUser
            }
            return _currentUser!
        }
        
        set (aUser){
            // store session in user defaults
            
            _currentUser = aUser
        }
    }
}
