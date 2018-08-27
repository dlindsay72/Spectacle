//
//  CommentInputTextView.swift
//  Spectacle
//
//  Created by Dan Lindsay on 2018-08-27.
//  Copyright © 2018 Dan Lindsay. All rights reserved.
//

import UIKit

class CommentInputTextView: UITextView {
    
    fileprivate let placeholderLbl: UILabel = {
        let label = UILabel()
        label.text = "Enter comment..."
        label.textColor = .customGray()
        
        return label
    }()
    
    override init(frame: CGRect, textContainer: NSTextContainer?) {
        super.init(frame: frame, textContainer: textContainer)
        
        NotificationCenter.default.addObserver(self, selector: #selector(observeForTextChanges), name: .UITextViewTextDidChange, object: nil)
        
        addSubview(placeholderLbl)
        placeholderLbl.anchor(top: topAnchor, left: leftAnchor, bottom: bottomAnchor, right: rightAnchor, paddingTop: 8, paddingLeft: 8, paddingBottom: 0, paddingRight: 0, width: 0, height: 0)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    @objc func observeForTextChanges() {
        placeholderLbl.isHidden = !self.text.isEmpty
    }
    
    func showPlaceholderLbl() {
        placeholderLbl.isHidden = false
    }
}
