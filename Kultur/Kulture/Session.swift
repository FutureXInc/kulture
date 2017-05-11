//
//  Session.swift
//  Kulture
//
//  Created by Bhalla, Kapil on 5/7/17.
//  Copyright © 2017 FutureXInc. All rights reserved.
//

import UIKit

class Session: NSObject {

    
    var currentUser : User?
    
    static var _currentSession: Session?
    
    class var currentSession: Session? {
        get {
            if (_currentSession == nil) {
                // read session from user defaults
                
                // create a session
                
                let tempUser: User = User()
                tempUser.firstName = "KapiL"
                tempUser.lastName = "Bhalla"
                tempUser.emailID = "kapil_bhalla@intuit.com"
                tempUser.role = User.UserRole.Parent
                
                _currentSession = Session(aUser: tempUser)
            }
            return _currentSession
        }
        
        set (aSession){
            // store session in user defaults
            
            _currentSession = aSession
        }
    }
    
    init (aUser :User){
        currentUser = aUser
    }
}
