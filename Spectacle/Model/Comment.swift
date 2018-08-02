//
//  Comment.swift
//  Spectacle
//
//  Created by Dan Lindsay on 2018-07-31.
//  Copyright © 2018 Dan Lindsay. All rights reserved.
//

import Foundation

struct Comment {
    
    let user: User
    let text: String
    let uid: String
    
    init(user: User, dictionary: [String: Any]) {
        self.user = user
        self.text = dictionary["text"] as? String ?? ""
        self.uid = dictionary["uid"] as? String ?? ""
    }
}
