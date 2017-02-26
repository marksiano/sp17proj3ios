//
//  User.swift
//  FirebaseDemoWeek3
//
//  Created by Sahil Lamba on 2/17/17.
//  Copyright © 2017 Sahil Lamba. All rights reserved.
//

import Foundation
import UIKit

class User {
    
    var email: String?
    var firstname: String?
    var lastname: String?
    var username: String?
    var id: String?
    
    init(id: String, userDict: [String:Any]?) {
        self.id = id
        if userDict != nil {
            if let firstname = userDict!["firstname"] as? String {
                self.firstname = firstname
            }
            if let email = userDict!["email"] as? String {
                self.email = email
            }
            if let lastname = userDict!["lastname"] as? String {
                self.lastname = lastname
            }
            if let username = userDict!["username"] as? String {
                self.username = username
            }
            
        }
    }
    
    
}
