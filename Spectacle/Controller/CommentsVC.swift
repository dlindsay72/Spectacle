//
//  CommentsVC.swift
//  Spectacle
//
//  Created by Dan Lindsay on 2018-07-30.
//  Copyright © 2018 Dan Lindsay. All rights reserved.
//

import UIKit
import Firebase

class CommentsVC: UICollectionViewController {
    
    override var inputAccessoryView: UIView? {
        get {
            return containerView
        }
    }
    
    override var canBecomeFirstResponder: Bool {
        return true
    }
    
    var post: Post?
    let commentCellId = "commentCell"
    var comments = [Comment]()
    let commentTextField: UITextField = {
        let textField = UITextField()
        textField.placeholder = "Enter comment"
        textField.font = UIFont(name: "Courier", size: 20)
        
        return textField
    }()
    
    lazy var containerView: UIView = {
        let containerView = UIView()
        containerView.backgroundColor = .white
        containerView.frame = CGRect(x: 0, y: 0, width: 100, height: 60)
        
        let submitBtn = UIButton(type: .system)
        submitBtn.setTitle("Submit", for: .normal)
        submitBtn.setTitleColor(.black, for: .normal)
        submitBtn.titleLabel?.font = UIFont(name: "Courier-Bold", size: 20)
        submitBtn.addTarget(self, action: #selector(submitBtnWasPressed), for: .touchUpInside)
        containerView.addSubview(submitBtn)
        
        submitBtn.anchor(top: containerView.topAnchor, left: nil, bottom: containerView.bottomAnchor, right: containerView.rightAnchor, paddingTop: 0, paddingLeft: 0, paddingBottom: 0, paddingRight: 12, width: 90, height: 0)
        
        
        containerView.addSubview(self.commentTextField)
        self.commentTextField.anchor(top: containerView.topAnchor, left: containerView.leftAnchor, bottom: containerView.bottomAnchor, right: submitBtn.leftAnchor, paddingTop: 0, paddingLeft: 12, paddingBottom: 0, paddingRight: 0, width: 0, height: 0)
        
        let lineSeparatorView = UIView()
        lineSeparatorView.backgroundColor = UIColor.rgb(red: 230, green: 230, blue: 230)
        containerView.addSubview(lineSeparatorView)
        
        lineSeparatorView.anchor(top: containerView.topAnchor, left: containerView.leftAnchor, bottom: nil, right: containerView.rightAnchor, paddingTop: 0, paddingLeft: 0, paddingBottom: 0, paddingRight: 0, width: 0, height: 1)
        
        
        return containerView
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        navigationItem.title = "Comments"
        
        collectionView?.backgroundColor = .white
        collectionView?.alwaysBounceVertical = true
        collectionView?.keyboardDismissMode = .interactive
        
        collectionView?.contentInset = UIEdgeInsets(top: 0, left: 0, bottom: -60, right: 0)
        collectionView?.scrollIndicatorInsets = UIEdgeInsets(top: 0, left: 0, bottom: -60, right: 0)
        collectionView?.register(CommentCell.self, forCellWithReuseIdentifier: commentCellId)
        
        fetchComments()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        tabBarController?.tabBar.isHidden = true
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        tabBarController?.tabBar.isHidden = false
    }
    
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return comments.count
    }
    
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: commentCellId, for: indexPath) as! CommentCell
        cell.comment = self.comments[indexPath.item]
        
        return cell
    }
    
    @objc func submitBtnWasPressed() {
        print("post id:", self.post?.id ?? "")
        print("Inserting comment:", commentTextField.text ?? "")
        guard let uid = Auth.auth().currentUser?.uid else { return }
        let postId = self.post?.id ?? ""
        let values = ["text": commentTextField.text ?? "", "creationDate": Date().timeIntervalSince1970, "uid": uid] as [String : Any]
        Database.database().reference().child("comments").child(postId).childByAutoId().updateChildValues(values) { (error, ref) in
            if let err = error {
                print("Failed to insert comment:", err)
            }
            
            print("Successfully inserted comment")
        }
    }
    
    fileprivate func fetchComments() {
        guard let postId = self.post?.id else { return }
        let ref = Database.database().reference().child("comments").child(postId)
        
        ref.observe(.childAdded, with: { (snapshot) in
            
            guard let dictionary = snapshot.value as? [String: Any] else { return }
            guard let uid = dictionary["uid"] as? String else { return }
            
            Database.fetchUserWith(uid: uid, completion: { (user) in
                let comment = Comment(user: user, dictionary: dictionary)
    
                self.comments.append(comment)
                self.collectionView?.reloadData()
            })
        }) { (error) in
            print("Failed to observe comments:", error)
        }
    }
}

//MARK: UICollectionViewDelegateFlowLayout

extension CommentsVC: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let frame = CGRect(x: 0, y: 0, width: view.frame.width, height: 50)
        let dummyCell = CommentCell(frame: frame)
        
        dummyCell.comment = comments[indexPath.item]
        dummyCell.layoutIfNeeded()
        
        let targetSize = CGSize(width: view.frame.width, height: 1000)
        let estimatedSize = dummyCell.systemLayoutSizeFitting(targetSize)
        let height = max(40 + 8 + 8, estimatedSize.height)
        return CGSize(width: view.frame.width, height: height)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 0
    }
}



















