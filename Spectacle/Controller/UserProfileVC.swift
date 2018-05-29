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
    
    //MARK: - Class Properties
    var user: User?
    var userId: String?
    let headerIdentifier = "header"
    let userProfileCellIdentifier = "userProfileCell"
    var posts = [Post]()
    
    //MARK: - Class Methods
    override func viewDidLoad() {
        super.viewDidLoad()
        
        collectionView?.backgroundColor = #colorLiteral(red: 1, green: 1, blue: 1, alpha: 1)
        collectionView?.delegate = self
        collectionView?.register(UserProfileHeader.self, forSupplementaryViewOfKind: UICollectionElementKindSectionHeader, withReuseIdentifier: headerIdentifier)
        collectionView?.register(UserProfilePhotoCell.self, forCellWithReuseIdentifier: userProfileCellIdentifier)
        
        fetchUser()
        setupLogoutButton()
     //   fetchOrderedPosts()
    }
    
    override func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        let header = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: headerIdentifier, for: indexPath) as! UserProfileHeader
        header.user = self.user
        return header
    }
    
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return posts.count
    }
    
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: userProfileCellIdentifier, for: indexPath) as! UserProfilePhotoCell
        cell.post = posts[indexPath.item]
        return cell
    }
    
    fileprivate func setupLogoutButton() {
        navigationItem.rightBarButtonItem = UIBarButtonItem(image: #imageLiteral(resourceName: "gear").withRenderingMode(.alwaysOriginal), style: .plain, target: self, action: #selector(logoutUser))
    }
    
    fileprivate func fetchOrderedPosts() {
        guard let uid = self.user?.uid else { return }
        let ref = Database.database().reference().child("posts").child(uid)
        
        ref.queryOrdered(byChild: "creationDate").observe(.childAdded, with: { (snapshot) in
            guard let dictionary = snapshot.value as? [String: Any] else { return }
            
            guard let user = self.user else { return }
            let post = Post(user: user, dictionary: dictionary)
            self.posts.insert(post, at: 0)
   //         self.posts.append(post)
            self.collectionView?.reloadData()
        }) { (error) in
            print("Failed to fetch ordered posts:", error)
        }
    }
        
    fileprivate func fetchUser() {
        let uid = userId ?? Auth.auth().currentUser?.uid ?? ""
      //  guard let uid = Auth.auth().currentUser?.uid else { return }
        
        Database.fetchUserWith(uid: uid) { (user) in
            self.user = user
            self.navigationItem.title = self.user?.username.capitalized
            self.collectionView?.reloadData()
            self.fetchOrderedPosts()
        }
    }
    
    @objc func logoutUser() {
        let alertController = UIAlertController(title: nil, message: nil, preferredStyle: .actionSheet)
        alertController.addAction(UIAlertAction(title: "Log Out", style: .destructive, handler: { (_) in
            do {
                try Auth.auth().signOut()
                
                let loginVC = LoginVC()
                let navController = UINavigationController(rootViewController: loginVC)
                self.present(navController, animated: true, completion: nil)
                
            } catch let signOutError {
                print("Failed to sign out:", signOutError)
            }
            
        }))
        alertController.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))
        present(alertController, animated: true, completion: nil)
    }
}

//MARK: - UICollectionViewDelegateFlowLayout
extension UserProfileVC: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForHeaderInSection section: Int) -> CGSize {
        return CGSize(width: view.frame.width, height: 200)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let width = (view.frame.width - 2) / 3
        return CGSize(width: width, height: width)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 1
    }
}















