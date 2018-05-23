//
//  User.swift
//  Spectacle
//
//  Created by Dan Lindsay on 2018-05-23.
//  Copyright © 2018 Dan Lindsay. All rights reserved.
//

import UIKit

struct User {
    let username: String
    let profileImageUrl: String
    
    init(dictionary: [String: Any]) {
        self.username = dictionary["username"] as? String ?? ""
        self.profileImageUrl = dictionary["profileImageUrl"] as? String ?? ""
    }
}
