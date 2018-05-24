//
//  FirebaseDatabase+Ext.swift
//  Spectacle
//
//  Created by Dan Lindsay on 2018-05-24.
//  Copyright © 2018 Dan Lindsay. All rights reserved.
//

import UIKit
import Firebase

extension Database {
    static func fetchUserWith(uid: String, completion: @escaping (User) -> ()) {
        Database.database().reference().child("users").child(uid).observeSingleEvent(of: .value, with: { (snapshot) in
            guard let userDictionary = snapshot.value as? [String: Any] else { return }
            
            let user = User(uid: uid, dictionary: userDictionary)
            completion(user)
        }) { (error) in
            print("Failed to fetch user for posts:", error)
        }
    }
}
