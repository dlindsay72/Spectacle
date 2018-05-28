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
    
    let userSearchCellId = "userSearchCell"
    let userSearchBar: UISearchBar = {
        let searchBar = UISearchBar()
        searchBar.placeholder = "Enter username"
        searchBar.barTintColor = #colorLiteral(red: 0.9397994015, green: 0.939745148, blue: 0.9424306949, alpha: 1)
        UITextField.appearance(whenContainedInInstancesOf: [UISearchBar.self]).backgroundColor = #colorLiteral(red: 0.9397994015, green: 0.939745148, blue: 0.9424306949, alpha: 1)
        return searchBar
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        collectionView?.backgroundColor = #colorLiteral(red: 1, green: 1, blue: 1, alpha: 1)
        
        let navBar = navigationController?.navigationBar
        navigationController?.navigationBar.addSubview(userSearchBar)
        userSearchBar.anchor(top: navBar?.topAnchor, left: navBar?.leftAnchor, bottom: navBar?.bottomAnchor, right: navBar?.rightAnchor, paddingTop: 0, paddingLeft: 8, paddingBottom: 2, paddingRight: 8, width: 0, height: 0)
        collectionView?.register(UserSearchCell.self, forCellWithReuseIdentifier: userSearchCellId)
        collectionView?.alwaysBounceVertical = true
    }
    
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 5
    }
    
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: userSearchCellId, for: indexPath) as! UserSearchCell
        
        return cell
    }
    
}

extension UserSearchVC: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: view.frame.width, height: 66)
    }
}








