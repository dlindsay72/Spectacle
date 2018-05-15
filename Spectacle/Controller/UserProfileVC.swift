//
//  UserProfileVC.swift
//  Spectacle
//
//  Created by Dan Lindsay on 2018-05-15.
//  Copyright © 2018 Dan Lindsay. All rights reserved.
//

import UIKit
import Firebase

class UserProfileVC: UICollectionViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        collectionView?.backgroundColor = #colorLiteral(red: 1, green: 1, blue: 1, alpha: 1)
        collectionView?.delegate = self
        
      //  navigationItem.title = Auth.auth().currentUser?.uid
        
        fetchUser()
        
    }
        
    fileprivate func fetchUser() {
        
        guard let uid = Auth.auth().currentUser?.uid else { return }
        Database.database().reference().child("users").child(uid).observeSingleEvent(of: .value, with: { (snapshot) in
            print(snapshot.value ?? "")
            guard let dictionary = snapshot.value as? [String: Any] else { return }
            let username = dictionary["username"] as? String
            
            self.navigationItem.title = username?.capitalized
        }) { (error) in
            print("Failed to fetch user:", error)
        }
    }
    
    
}
