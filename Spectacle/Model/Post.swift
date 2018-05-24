//
//  Post.swift
//  Spectacle
//
//  Created by Dan Lindsay on 2018-05-22.
//  Copyright © 2018 Dan Lindsay. All rights reserved.
//

import Foundation

struct Post {
    
    let imageUrl: String
    let user: User
    let caption: String
    
    init(user: User, dictionary: [String: Any]) {
        self.imageUrl = dictionary["imageUrl"] as? String ?? ""
        self.user = user
        self.caption = dictionary["caption"] as? String ?? ""
    }
}
