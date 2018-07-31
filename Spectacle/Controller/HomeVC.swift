//
//  HomeVC.swift
//  Spectacle
//
//  Created by Dan Lindsay on 2018-05-23.
//  Copyright © 2018 Dan Lindsay. All rights reserved.
//

import UIKit
import Firebase

class HomeVC: UICollectionViewController {
    
    //MARK: - Class Properties
    let homeCellId = "homeCell"
    var posts = [Post]()
    
    //MARK: - Class Methods
    override func viewDidLoad() {
        super.viewDidLoad()
        
        NotificationCenter.default.addObserver(self, selector: #selector(updateFeed), name: SharePhotoVC.updateFeedNotificationName, object: nil)
        collectionView?.backgroundColor = #colorLiteral(red: 1, green: 1, blue: 1, alpha: 1)
        
        collectionView?.register(HomePostCell.self, forCellWithReuseIdentifier: homeCellId)
        let refreshControl = UIRefreshControl()
        refreshControl.addTarget(self, action: #selector(refreshCollectionView), for: .valueChanged)
        collectionView?.refreshControl = refreshControl
        
        setupNavigationItems()
        fetchAllPosts()
    }
    
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return posts.count
    }
    
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: homeCellId, for: indexPath) as! HomePostCell
        cell.post = posts[indexPath.item]
        cell.delegate = self
        
        return cell
    }
    
    //MARK: - Custom Methods
    
    @objc func refreshCollectionView() {
        posts.removeAll()
        collectionView?.reloadData()
        fetchAllPosts()
    }
    
    @objc func updateFeed() {
        refreshCollectionView()
    }
    
    @objc func activateCamera() {
        print("Showing camera")
        let cameraVC = CameraVC()
        present(cameraVC, animated: true, completion: nil)
    }
    
    fileprivate func fetchAllPosts() {
        fetchPosts()
        fetchFollowingUserIds()
    }
    
    fileprivate func setupNavigationItems() {
        navigationItem.titleView = UIImageView(image: #imageLiteral(resourceName: "logo2"))
        
        navigationItem.leftBarButtonItem = UIBarButtonItem(image: #imageLiteral(resourceName: "camera3").withRenderingMode(.alwaysOriginal), style: .plain, target: self, action: #selector(activateCamera))
    }
    
    
    fileprivate func fetchFollowingUserIds() {
        guard let uid = Auth.auth().currentUser?.uid else { return }
        Database.database().reference().child("following").child(uid).observeSingleEvent(of: .value, with: { (snapshot) in
            guard let userIdsDictionary = snapshot.value as? [String: Any] else { return }
            
            userIdsDictionary.forEach({ (key, value) in
                Database.fetchUserWith(uid: key, completion: { (user) in
                    self.fetchPostsWith(user: user)
                })
            })
        }) { (error) in
            print("Could not fetch following user ids:", error)
        }
    }
    
    fileprivate func fetchPosts() {
        guard let uid = Auth.auth().currentUser?.uid else { return }
        Database.fetchUserWith(uid: uid) { (user) in
            self.fetchPostsWith(user: user)
        }
    }
    
    fileprivate func fetchPostsWith(user: User) {
        let ref = Database.database().reference().child("posts").child(user.uid)
        
        ref.observeSingleEvent(of: .value, with: { (snapshot) in
            self.collectionView?.refreshControl?.endRefreshing()
            guard let dictionaries = snapshot.value as? [String: Any] else { return }
            dictionaries.forEach({ (key, value) in
                guard let dictionary = value as? [String: Any] else { return }
                
                let post = Post(user: user, dictionary: dictionary)
                self.posts.append(post)
            })
            
            self.posts.sort(by: { (post1, post2) -> Bool in
                return post1.creationDate.compare(post2.creationDate) == .orderedDescending
            })
            self.collectionView?.reloadData()
        }) { (error) in
            print("Failed to fetch posts:", error)
        }
    }
    
}

//MARK: - UICollectionViewDelegateFlowLayout
extension HomeVC: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        var height: CGFloat = 40 + 8 + 8 // username userprofileImageView
        height += view.frame.width
        height += 50
        height += 60
        return CGSize(width: view.frame.width, height: height)
    }
}

//MARK: - HomePostCellDelegate
extension HomeVC: HomePostCellDelegate {
    func didTapCommentBtnOn(post: Post) {
        print(post.caption)
        print("Message coming through HomeVC")
        let commentsVC = CommentsVC(collectionViewLayout: UICollectionViewFlowLayout())
        navigationController?.pushViewController(commentsVC, animated: true)
    }
}





