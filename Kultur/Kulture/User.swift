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
    var role: UserRole = .None
    
    // This enum holds the set of roles a user can play in the system

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
                tempUser.role = .Kid
                
                _currentUser = tempUser
            }
            return _currentUser!
        }
        
        set (aUser){
            _currentUser = aUser
        }
    }
}
