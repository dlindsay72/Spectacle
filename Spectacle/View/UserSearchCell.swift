//
//  UserSearchCell.swift
//  Spectacle
//
//  Created by Dan Lindsay on 2018-05-28.
//  Copyright © 2018 Dan Lindsay. All rights reserved.
//

import UIKit

class UserSearchCell: UICollectionViewCell {
    
    var user: User? {
        didSet {
            usernameLbl.text = user?.username
            guard let profileImageUrl = user?.profileImageUrl else { return }
            profileImageView.loadImage(fromUrlString: profileImageUrl)
        }
    }
    
    let profileImageView: CustomImageView = {
        let imageView = CustomImageView()
        imageView.contentMode = .scaleAspectFill
        imageView.clipsToBounds = true
        return imageView
    }()
    
    let usernameLbl: UILabel = {
        let label = UILabel()
        label.text = "username"
        label.font = UIFont.init(name: "Courier-Bold", size: 14)
        return label
    }()
    
    let separatorView = UIView()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        addSubview(profileImageView)
        addSubview(usernameLbl)
        profileImageView.anchor(top: nil, left: leftAnchor, bottom: nil, right: nil, paddingTop: 0, paddingLeft: 8, paddingBottom: 0, paddingRight: 0, width: 50, height: 50)
        profileImageView.centerYAnchor.constraint(equalTo: centerYAnchor).isActive = true
        profileImageView.layer.cornerRadius = 50 / 2
        
        usernameLbl.anchor(top: topAnchor, left: profileImageView.rightAnchor, bottom: bottomAnchor, right: rightAnchor, paddingTop: 0, paddingLeft: 8, paddingBottom: 0, paddingRight: 0, width: 0, height: 0)
        
        separatorView.backgroundColor = UIColor(white: 0, alpha: 0.5)
        addSubview(separatorView)
        separatorView.anchor(top: nil, left: usernameLbl.leftAnchor, bottom: bottomAnchor, right: rightAnchor, paddingTop: 0, paddingLeft: 0, paddingBottom: 0, paddingRight: 0, width: 0, height: 0.5)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}




