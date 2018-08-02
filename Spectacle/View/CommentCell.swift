//
//  CommentCell.swift
//  Spectacle
//
//  Created by Dan Lindsay on 2018-07-31.
//  Copyright © 2018 Dan Lindsay. All rights reserved.
//

import UIKit

class CommentCell: UICollectionViewCell {
    
    var comment: Comment? {
        didSet {
            guard let comment = comment else { return }

            let attributedText = NSMutableAttributedString(string: comment.user.username, attributes: [NSAttributedStringKey.font: UIFont.init(name: "Courier-Bold", size: 15) ?? UIFont.systemFont(ofSize: 15)])
            attributedText.append(NSAttributedString(string: " " + comment.text, attributes: [NSAttributedStringKey.font: UIFont.init(name: "Courier", size: 15) ?? UIFont.systemFont(ofSize: 15)]))
            
            textView.attributedText = attributedText
            profileImageView.loadImage(fromUrlString: comment.user.profileImageUrl)
         
        }
    }
    
    let textView: UITextView = {
        let textView = UITextView()
        textView.font = UIFont(name: "Courier", size: 18)
        textView.isScrollEnabled = false
        return textView
    }()
    
    let profileImageView: CustomImageView = {
        let imageView = CustomImageView()
        imageView.clipsToBounds = true
        imageView.contentMode = .scaleAspectFill
        
        return imageView
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        profileImageView.layer.cornerRadius = 40/2
        
        addSubview(textView)
        addSubview(profileImageView)
        
        profileImageView.anchor(top: topAnchor, left: leftAnchor, bottom: nil, right: nil, paddingTop: 8, paddingLeft: 8, paddingBottom: 0, paddingRight: 0, width: 40, height: 40)
        textView.anchor(top: topAnchor, left: profileImageView.rightAnchor, bottom: bottomAnchor, right: rightAnchor, paddingTop: 4, paddingLeft: 4, paddingBottom: 4, paddingRight: 4, width: 0, height: 0)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
}
