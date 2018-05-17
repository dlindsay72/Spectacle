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
        self.delegate = self
        
        if Auth.auth().currentUser == nil {
            DispatchQueue.main.async {
                let loginVC = LoginVC()
                let navController = UINavigationController(rootViewController: loginVC)
                self.present(navController, animated: true, completion: nil)
            }
            return
        }
        setupViewControllers()
    }
    
    func setupViewControllers() {
        //home
        let homeNavController = setupNavController(withUnselectedImage: #imageLiteral(resourceName: "home_unselected"), andSelectedImage: #imageLiteral(resourceName: "home_selected"), rootViewController: UserProfileVC(collectionViewLayout: UICollectionViewFlowLayout()))
        //search
        let searchNavController = setupNavController(withUnselectedImage: #imageLiteral(resourceName: "search_unselected"), andSelectedImage: #imageLiteral(resourceName: "search_selected"))
        //plus
        let plusNavController = setupNavController(withUnselectedImage: #imageLiteral(resourceName: "plus_unselected"), andSelectedImage: #imageLiteral(resourceName: "plus_unselected"))
        //like
        let likeNavController = setupNavController(withUnselectedImage: #imageLiteral(resourceName: "like_unselected"), andSelectedImage: #imageLiteral(resourceName: "like_selected"))
        
        //user profile
        let layout = UICollectionViewFlowLayout()
        let userProfileVC = UserProfileVC(collectionViewLayout: layout)
        let userProfileNavController = UINavigationController(rootViewController: userProfileVC)
        
        userProfileNavController.tabBarItem.image = #imageLiteral(resourceName: "profile_unselected")
        userProfileNavController.tabBarItem.selectedImage = #imageLiteral(resourceName: "profile_selected")
        tabBar.tintColor = #colorLiteral(red: 0, green: 0, blue: 0, alpha: 1)
        viewControllers = [homeNavController, searchNavController, plusNavController, likeNavController, userProfileNavController]
        
        //modify tab bar item insets
        guard let items = tabBar.items else { return }
        
        for item in items {
            item.imageInsets = UIEdgeInsets(top: 4, left: 0, bottom: -4, right: 0)
        }
    }
    
    fileprivate func setupNavController(withUnselectedImage image: UIImage, andSelectedImage selectedImage: UIImage, rootViewController: UIViewController = UIViewController()) -> UINavigationController {
        let viewController = rootViewController
        let navController = UINavigationController(rootViewController: viewController)
        navController.tabBarItem.image = image
        navController.tabBarItem.selectedImage = selectedImage
        return navController
    }
}

extension MainTabVC: UITabBarControllerDelegate {
    func tabBarController(_ tabBarController: UITabBarController, shouldSelect viewController: UIViewController) -> Bool {
        
        let index = viewControllers?.index(of: viewController)
        if index == 2 {
            let layout = UICollectionViewFlowLayout()
            let photoSelectorVC = PhotoSelectorVC(collectionViewLayout: layout)
            let navController = UINavigationController(rootViewController: photoSelectorVC)
            present(navController, animated: true, completion: nil)
            return false
        }
        
        return true
    }
}






