//
//  User.swift
//  TestProject
//
//  Created by Jake Tran on 8/7/17.
//  Copyright © 2017 Jake Tran. All rights reserved.
//

import Foundation
import FirebaseDatabase

class User: NSObject {
    var uid: String!
    var email: String!
    var name: String!
    
    init(uid: String, email: String, name: String) {
        self.uid = uid
        self.email = email
        self.name = name
        
        super.init()
    }
    
    init?(snapshot: DataSnapshot) {
        guard let userDict = snapshot.value as? [String: Any],
            let emailFromSnapshot = userDict["email"] as? String,
            let nameFromSnapshot = userDict["name"] as? String else {
            return nil
        }
        
        self.uid = snapshot.key
        self.email = emailFromSnapshot
        self.name = nameFromSnapshot
    }
    
    //Singleton
    
    private static var _current: User?
    
    static var current: User {
        guard let currentUser = _current else {
            fatalError("Error: current user doesn't exist")
        }
        
        return currentUser
    }
    
    //Class Methods
    
    static func setCurrent(_ user: User) {
        _current = user
    }

    
    
}
