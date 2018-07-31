//
//  Post.swift
//  Spectacle
//
//  Created by Dan Lindsay on 2018-05-22.
//  Copyright © 2018 Dan Lindsay. All rights reserved.
//

import Foundation

struct Post {
    
    var id: String?
    let imageUrl: String
    let user: User
    let caption: String
    let creationDate: Date
    
    init(user: User, dictionary: [String: Any]) {
        self.imageUrl = dictionary["imageUrl"] as? String ?? ""
        self.user = user
        self.caption = dictionary["caption"] as? String ?? ""
        
        let secondsFrom1970 = dictionary["creationDate"] as? Double ?? 0
        self.creationDate = Date(timeIntervalSince1970: secondsFrom1970)
    }
}
