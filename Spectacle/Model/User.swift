//
//  User.swift
//  Spectacle
//
//  Created by Dan Lindsay on 2018-05-23.
//  Copyright © 2018 Dan Lindsay. All rights reserved.
//

import UIKit

struct User {
    let uid: String
    let username: String
    let profileImageUrl: String
    
    init(uid: String, dictionary: [String: Any]) {
        self.username = dictionary["username"] as? String ?? ""
        self.profileImageUrl = dictionary["profileImageUrl"] as? String ?? ""
        self.uid = uid
    }
}
