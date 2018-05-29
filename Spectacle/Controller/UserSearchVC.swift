//
//  UserSearchVC.swift
//  Spectacle
//
//  Created by Dan Lindsay on 2018-05-28.
//  Copyright © 2018 Dan Lindsay. All rights reserved.
//

import UIKit
import Firebase

class UserSearchVC: UICollectionViewController {
    
    //MARK: - Class Properties
    var users = [User]()
    var filteredUsers = [User]()
    let userSearchCellId = "userSearchCell"
    lazy var userSearchBar: UISearchBar = {
        let searchBar = UISearchBar()
        searchBar.placeholder = "Enter username"
        searchBar.barTintColor = #colorLiteral(red: 0.9397994015, green: 0.939745148, blue: 0.9424306949, alpha: 1)
        
        UITextField.appearance(whenContainedInInstancesOf: [UISearchBar.self]).backgroundColor = #colorLiteral(red: 0.9397994015, green: 0.939745148, blue: 0.9424306949, alpha: 1)
        searchBar.delegate = self
        return searchBar
    }()
    
    //MARK: - Class Methods
    override func viewDidLoad() {
        super.viewDidLoad()
        collectionView?.backgroundColor = #colorLiteral(red: 1, green: 1, blue: 1, alpha: 1)
        
        let navBar = navigationController?.navigationBar
        navigationController?.navigationBar.addSubview(userSearchBar)
        userSearchBar.anchor(top: navBar?.topAnchor, left: navBar?.leftAnchor, bottom: navBar?.bottomAnchor, right: navBar?.rightAnchor, paddingTop: 0, paddingLeft: 8, paddingBottom: 2, paddingRight: 8, width: 0, height: 0)
        collectionView?.register(UserSearchCell.self, forCellWithReuseIdentifier: userSearchCellId)
        collectionView?.alwaysBounceVertical = true
        collectionView?.keyboardDismissMode = .onDrag
        
        fetchUsers()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        userSearchBar.isHidden = false
    }
    
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return filteredUsers.count
    }
    
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: userSearchCellId, for: indexPath) as! UserSearchCell
        cell.user = filteredUsers[indexPath.item]
        return cell
    }
    
    override func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        userSearchBar.isHidden = true
        userSearchBar.resignFirstResponder()
        
        let user = filteredUsers[indexPath.item]
        print(user.username)
        
        let userProfileVC = UserProfileVC(collectionViewLayout: UICollectionViewFlowLayout())
        userProfileVC.userId = user.uid
        navigationController?.pushViewController(userProfileVC, animated: true)
    }
    
    //MARK: - Custom Methods
    fileprivate func fetchUsers() {
        let ref = Database.database().reference().child("users")
        ref.observeSingleEvent(of: .value, with: { (snapshot) in
            guard let dictionaries = snapshot.value as? [String: Any] else { return }
            
            dictionaries.forEach({ (key, value) in
                if key == Auth.auth().currentUser?.uid {
                    print("Found myself, omit from list")
                    return
                }
                
                guard let userDictionary = value as? [String: Any] else { return }
                let user = User(uid: key, dictionary: userDictionary)
                self.users.append(user)
            })
            
            self.users.sort(by: { (user1, user2) -> Bool in
                return user1.username.compare(user2.username) == .orderedAscending
            })
            
            self.filteredUsers = self.users
            self.collectionView?.reloadData()
        }) { (error) in
            print("Failed to fetch users for search:", error)
        }
    }
    
}

//MARK: - UICollectionViewDelegateFlowLayout Extension
extension UserSearchVC: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: view.frame.width, height: 66)
    }
}

//MARK: - UISearchBarDelegate
extension UserSearchVC: UISearchBarDelegate {
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        if searchText.isEmpty {
            filteredUsers = users
        } else {
            filteredUsers = self.users.filter { (user) -> Bool in
                return user.username.lowercased().contains(searchText.lowercased())
            }
        }
        
        self.collectionView?.reloadData()
    }
}








