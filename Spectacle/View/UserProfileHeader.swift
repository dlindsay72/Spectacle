//
//  UserProfileHeader.swift
//  Spectacle
//
//  Created by Dan Lindsay on 2018-05-15.
//  Copyright © 2018 Dan Lindsay. All rights reserved.
//

import UIKit
import Firebase

class UserProfileHeader: UICollectionViewCell {
    
    //MARK: - Class Properties
    var user: User? {
        didSet {
            guard let profileImageUrl = user?.profileImageUrl else { return }
            profileImageView.loadImage(fromUrlString: profileImageUrl)
            usernameLbl.text = user?.username
            
            setupEditFollowButton()
        }
    }
    
    let profileImageView: CustomImageView = {
        let imageView = CustomImageView()
        return imageView
    }()
    
    let gridBtn: UIButton = {
        let button = UIButton(type: .system)
        button.setImage(#imageLiteral(resourceName: "grid"), for: .normal)
        return button
    }()
    
    let listBtn: UIButton = {
        let button = UIButton(type: .system)
        button.setImage(#imageLiteral(resourceName: "list"), for: .normal)
        button.tintColor = UIColor(white: 0, alpha: 0.2)
        return button
    }()
    
    let bookmarkBtn: UIButton = {
        let button = UIButton(type: .system)
        button.setImage(#imageLiteral(resourceName: "ribbon"), for: .normal)
        button.tintColor = UIColor(white: 0, alpha: 0.2)
        return button
    }()
    
    let usernameLbl: UILabel = {
        let label = UILabel()
        label.font = UIFont(name: "Courier-Bold", size: 14)
        return label
    }()
    
    let postsLbl: UILabel = {
        let label = UILabel()
        let attributedText = NSMutableAttributedString(string: "11\n", attributes: [NSAttributedStringKey.font: UIFont.init(name: "Courier-Bold", size: 14) ?? UIFont.boldSystemFont(ofSize: 14)])
        attributedText.append(NSAttributedString(string: "posts", attributes: [NSAttributedStringKey.foregroundColor: UIColor.lightGray, NSAttributedStringKey.font: UIFont(name: "Courier", size: 14) ?? UIFont.systemFont(ofSize: 14)]))
        label.attributedText = attributedText
        label.numberOfLines = 0
        label.textAlignment = .center
        return label
    }()
    
    let followersLbl: UILabel = {
        let label = UILabel()
        let attributedText = NSMutableAttributedString(string: "0\n", attributes: [NSAttributedStringKey.font: UIFont.init(name: "Courier-Bold", size: 14) ?? UIFont.boldSystemFont(ofSize: 14)])
        attributedText.append(NSAttributedString(string: "followers", attributes: [NSAttributedStringKey.foregroundColor: UIColor.lightGray, NSAttributedStringKey.font: UIFont(name: "Courier", size: 14) ?? UIFont.systemFont(ofSize: 14)]))
        label.attributedText = attributedText
        label.numberOfLines = 0
        label.textAlignment = .center
        return label
    }()
    
    let followingLbl: UILabel = {
        let label = UILabel()
        let attributedText = NSMutableAttributedString(string: "0\n", attributes: [NSAttributedStringKey.font: UIFont.init(name: "Courier-Bold", size: 14) ?? UIFont.boldSystemFont(ofSize: 14)])
        attributedText.append(NSAttributedString(string: "following", attributes: [NSAttributedStringKey.foregroundColor: UIColor.lightGray, NSAttributedStringKey.font: UIFont(name: "Courier", size: 14) ?? UIFont.systemFont(ofSize: 14)]))
        label.attributedText = attributedText
        label.numberOfLines = 0
        label.textAlignment = .center
        return label
    }()
    
    lazy var editProfileFollowBtn: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("Edit Profile", for: .normal)
        button.titleLabel?.font = UIFont(name: "Courier-Bold", size: 15)
        button.setTitleColor(.black, for: .normal)
        button.layer.borderColor = #colorLiteral(red: 0, green: 0, blue: 0, alpha: 0.5)
        button.layer.borderWidth = 1
        button.layer.cornerRadius = 3
        button.addTarget(self, action: #selector(editProfileFollowBtnPressed), for: .touchUpInside)
        return  button
    }()
    
    //MARK: - Class Methods
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        addSubview(profileImageView)
        profileImageView.anchor(top: topAnchor, left: leftAnchor, bottom: nil, right: nil, paddingTop: 12, paddingLeft: 12, paddingBottom: 0, paddingRight: 0, width: 80, height: 80)
        profileImageView.layer.cornerRadius = 80 / 2
        profileImageView.clipsToBounds = true
        
        setupBottomToolbar()
        
        addSubview(usernameLbl)
        usernameLbl.anchor(top: profileImageView.bottomAnchor, left: leftAnchor, bottom: gridBtn.topAnchor, right: rightAnchor, paddingTop: 4, paddingLeft: 12, paddingBottom: 0, paddingRight: 12, width: 0, height: 0)
        
        setupUserStatsView()
        
        addSubview(editProfileFollowBtn)
        editProfileFollowBtn.anchor(top: postsLbl.bottomAnchor, left: postsLbl.leftAnchor, bottom: nil, right: followingLbl.rightAnchor, paddingTop: 4, paddingLeft: 0, paddingBottom: 0, paddingRight: 0, width: 0, height: 33)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    //MARK: - Custom Methods
    
    fileprivate func setupEditFollowButton() {
        guard let currentLoggedInUserId = Auth.auth().currentUser?.uid else { return }
        guard let userId = user?.uid else { return }
        
        if currentLoggedInUserId == userId {
            //edit profile
        } else {
            
            //check if following
            Database.database().reference().child("following").child(currentLoggedInUserId).child(userId).observeSingleEvent(of: .value, with: { (snapshot) in
                if let isFollowing = snapshot.value as? Int, isFollowing == 1 {
                    self.editProfileFollowBtn.setTitle("Unfollow", for: .normal)
                } else {
                    self.setupFollowButtonStyle(withTitle: "Follow", backgroundColor: #colorLiteral(red: 0, green: 0.5690457821, blue: 0.5746168494, alpha: 1), titleColor: .white, borderColor: #colorLiteral(red: 0, green: 0.3285208941, blue: 0.5748849511, alpha: 1))
                }
            }) { (error) in
                print("Failed to check if following:", error)
            }
        }
    }
    
    @objc fileprivate func editProfileFollowBtnPressed() {
        print("Execute edit profile or folow/unfollow logic...")
        
        guard let currentLoggedInUserId = Auth.auth().currentUser?.uid else { return }
        guard let userId = user?.uid else { return }
        
        if editProfileFollowBtn.titleLabel?.text == "Unfollow" {
            Database.database().reference().child("following").child(currentLoggedInUserId).child(userId).removeValue { (error, reference) in
                if let error = error {
                    print("Failed to unfollow user:", error)
                }
                print("Successfully unfollowed user:", self.user?.username ?? "")
                
                self.setupFollowButtonStyle(withTitle: "Follow", backgroundColor: #colorLiteral(red: 0, green: 0.5690457821, blue: 0.5746168494, alpha: 1), titleColor: .white, borderColor: #colorLiteral(red: 0, green: 0.3285208941, blue: 0.5748849511, alpha: 1))
            }
        } else {
            let ref = Database.database().reference().child("following").child(currentLoggedInUserId)
            let values = [userId: 1]
            
            ref.updateChildValues(values) { (error, reference) in
                if let error = error {
                    print("Failed to follow user:", error)
                }
                print("Successfully following user:", self.user?.username ?? "")
                self.setupFollowButtonStyle(withTitle: "Unfollow", backgroundColor: .white, titleColor: .black, borderColor: #colorLiteral(red: 0.6392156863, green: 0.6392156863, blue: 0.6392156863, alpha: 1))
            }
        }
    }
    
    fileprivate func setupFollowButtonStyle(withTitle title: String, backgroundColor: UIColor, titleColor: UIColor, borderColor: CGColor) {
        self.editProfileFollowBtn.setTitle(title, for: .normal)
        self.editProfileFollowBtn.backgroundColor = backgroundColor
        self.editProfileFollowBtn.setTitleColor(titleColor, for: .normal)
        self.editProfileFollowBtn.layer.borderColor = borderColor
    }
    
    fileprivate func setupBottomToolbar() {
        let topDividerView = UIView()
        topDividerView.backgroundColor = #colorLiteral(red: 0, green: 0, blue: 0, alpha: 0.5)
        
        let bottomDividerView = UIView()
        bottomDividerView.backgroundColor = #colorLiteral(red: 0, green: 0, blue: 0, alpha: 0.5)
        
        let stackView = UIStackView(arrangedSubviews: [gridBtn, listBtn, bookmarkBtn])
        
        stackView.axis = .horizontal
        stackView.distribution = .fillEqually
        addSubview(stackView)
        addSubview(topDividerView)
        addSubview(bottomDividerView)
        stackView.anchor(top: nil, left: leftAnchor, bottom: bottomAnchor, right: rightAnchor, paddingTop: 0, paddingLeft: 0, paddingBottom: 0, paddingRight: 0, width: 0, height: 50)
        topDividerView.anchor(top: stackView.topAnchor, left: leftAnchor, bottom: nil, right: rightAnchor, paddingTop: 0, paddingLeft: 0, paddingBottom: 0, paddingRight: 0, width: 0, height: 0.5)
        bottomDividerView.anchor(top: stackView.bottomAnchor, left: leftAnchor, bottom: nil, right: rightAnchor, paddingTop: 0, paddingLeft: 0, paddingBottom: 0, paddingRight: 0, width: 0, height: 0.5)
        
    }
    
    fileprivate func setupUserStatsView() {
        let stackView = UIStackView(arrangedSubviews: [postsLbl, followersLbl, followingLbl])
        stackView.distribution = .fillEqually
        addSubview(stackView)
        
        stackView.anchor(top: topAnchor, left: profileImageView.rightAnchor, bottom: nil, right: rightAnchor, paddingTop: 12, paddingLeft: 12, paddingBottom: 0, paddingRight: 12, width: 0, height: 50)
    }
}












