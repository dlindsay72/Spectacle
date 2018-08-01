//
//  Comment.swift
//  Spectacle
//
//  Created by Dan Lindsay on 2018-07-31.
//  Copyright © 2018 Dan Lindsay. All rights reserved.
//

import Foundation

struct Comment {
    let text: String
    let uid: String
    
    init(dictionary: [String: Any]) {
        self.text = dictionary["text"] as? String ?? ""
        self.uid = dictionary["uid"] as? String ?? ""
    }
}
