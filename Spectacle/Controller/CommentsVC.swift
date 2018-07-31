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
        
        return containerView
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        navigationItem.title = "Comments"
        
        collectionView?.backgroundColor = .purple
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        tabBarController?.tabBar.isHidden = true
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        tabBarController?.tabBar.isHidden = false
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
    
}
