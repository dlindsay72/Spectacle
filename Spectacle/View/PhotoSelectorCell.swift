//
//  PhotoSelectorCell.swift
//  Spectacle
//
//  Created by Dan Lindsay on 2018-05-18.
//  Copyright © 2018 Dan Lindsay. All rights reserved.
//

import UIKit

class PhotoSelectorCell: UICollectionViewCell {
    
    let photoimageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFill
        imageView.clipsToBounds = true
        imageView.backgroundColor = .lightGray
        return imageView
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        addSubview(photoimageView)
        photoimageView.anchor(top: topAnchor, left: leftAnchor, bottom: bottomAnchor, right: rightAnchor, paddingTop: 0, paddingLeft: 0, paddingBottom: 0, paddingRight: 0, width: 0, height: 0)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
