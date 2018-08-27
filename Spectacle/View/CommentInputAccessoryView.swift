//
//  CommentInputAccessoryView.swift
//  Spectacle
//
//  Created by Dan Lindsay on 2018-08-23.
//  Copyright © 2018 Dan Lindsay. All rights reserved.
//

import UIKit

protocol CommentInputAccessoryViewDelegate {
    func didSubmit(comment: String)
}

class CommentInputAccessoryView: UIView {
    
    var delegate: CommentInputAccessoryViewDelegate?
    
    fileprivate let submitBtn: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("Submit", for: .normal)
        button.setTitleColor(.black, for: .normal)
        button.titleLabel?.font = UIFont(name: "Courier-Bold", size: 20)
        button.addTarget(self, action: #selector(submitBtnWasPressed), for: .touchUpInside)
        
        return button
    }()
    
    fileprivate let commentTextView: CommentInputTextView = {
        let textView = CommentInputTextView()
 //       textView.placeholder = "Enter comment"
        textView.isScrollEnabled = false
        
        textView.font = UIFont(name: "Courier", size: 20)
        
        return textView
    }()
    
    override var intrinsicContentSize: CGSize {
        return .zero
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        backgroundColor = .white
        autoresizingMask = .flexibleHeight
        
        
        addSubview(submitBtn)
        submitBtn.anchor(top: topAnchor, left: nil, bottom: nil, right: rightAnchor, paddingTop: 0, paddingLeft: 0, paddingBottom: 0, paddingRight: 12, width: 90, height: 60)
        
        addSubview(commentTextView)
        commentTextView.anchor(top: topAnchor, left: leftAnchor, bottom: safeAreaLayoutGuide.bottomAnchor, right: submitBtn.leftAnchor, paddingTop: 8, paddingLeft: 8, paddingBottom: 8, paddingRight: 0, width: 0, height: 0)
        
        setupLineSeparatorView()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    @objc func submitBtnWasPressed() {
        guard let commentText = commentTextView.text else { return }
        
        delegate?.didSubmit(comment: commentText)
    }
    
    fileprivate func setupLineSeparatorView() {
        let lineSeparatorView = UIView()
        lineSeparatorView.backgroundColor = UIColor.rgb(red: 230, green: 230, blue: 230)
        addSubview(lineSeparatorView)
        
        lineSeparatorView.anchor(top: topAnchor, left: leftAnchor, bottom: nil, right: rightAnchor, paddingTop: 0, paddingLeft: 0, paddingBottom: 0, paddingRight: 0, width: 0, height: 1)
    }
    
    func clearCommentTextView() {
        commentTextView.text = nil
        commentTextView.showPlaceholderLbl()
    }
    
    
}
