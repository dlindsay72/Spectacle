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
    
    init(dictionary: [String: Any]) {
        self.imageUrl = dictionary["imageUrl"] as? String ?? ""
    }
}
