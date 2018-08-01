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
            textLbl.text = comment?.text
        }
    }
    
    let textLbl: UILabel = {
        let label = UILabel()
        label.font = UIFont(name: "Courier", size: 18)
        label.numberOfLines = 0
        label.backgroundColor = .lightGray
        return label
    }()
    override init(frame: CGRect) {
        super.init(frame: frame)
        backgroundColor = .yellow
        
        addSubview(textLbl)
        textLbl.anchor(top: topAnchor, left: leftAnchor, bottom: bottomAnchor, right: rightAnchor, paddingTop: 4, paddingLeft: 4, paddingBottom: 4, paddingRight: 4, width: 0, height: 0)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
}
