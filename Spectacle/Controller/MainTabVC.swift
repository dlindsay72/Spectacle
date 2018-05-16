//
//  MainTabVC.swift
//  Spectacle
//
//  Created by Dan Lindsay on 2018-05-15.
//  Copyright © 2018 Dan Lindsay. All rights reserved.
//

import UIKit
import Firebase

class MainTabVC: UITabBarController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if Auth.auth().currentUser == nil {
            DispatchQueue.main.async {
                let loginVC = LoginVC()
                let navController = UINavigationController(rootViewController: loginVC)
                self.present(navController, animated: true, completion: nil)
            }
            return
        }
        
        let layout = UICollectionViewFlowLayout()
        let userProfileVC = UserProfileVC(collectionViewLayout: layout)
        let navController = UINavigationController(rootViewController: userProfileVC)
        
        navController.tabBarItem.image = #imageLiteral(resourceName: "profile_unselected")
        navController.tabBarItem.selectedImage = #imageLiteral(resourceName: "profile_selected")
        tabBar.tintColor = #colorLiteral(red: 0.4666666687, green: 0.7647058964, blue: 0.2666666806, alpha: 1)
        viewControllers = [navController, UIViewController()]
    }
}
