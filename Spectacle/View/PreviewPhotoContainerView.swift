//
//  PreviewPhotoContainerView.swift
//  Spectacle
//
//  Created by Dan Lindsay on 2018-07-30.
//  Copyright © 2018 Dan Lindsay. All rights reserved.
//

import UIKit
import Photos

class PreviewPhotoContainerView: UIView {
    
    let previewImageView: UIImageView = {
        let imageView = UIImageView()
        return imageView
    }()
    
    let cancelBtn: UIButton = {
        let button = UIButton(type: .system)
        button.setImage(#imageLiteral(resourceName: "cancel_shadow").withRenderingMode(.alwaysOriginal), for: .normal)
        button.addTarget(self, action: #selector(cancelBtnWasPressed), for: .touchUpInside)
        return button
    }()
    
    let saveBtn: UIButton = {
        let button = UIButton(type: .system)
        button.setImage(#imageLiteral(resourceName: "save_shadow").withRenderingMode(.alwaysOriginal), for: .normal)
        button.addTarget(self, action: #selector(saveBtnWasPressed), for: .touchUpInside)
        return button
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        backgroundColor = .yellow
        
        addSubview(previewImageView)
        previewImageView.anchor(top: topAnchor, left: leftAnchor, bottom: bottomAnchor, right: rightAnchor, paddingTop: 0, paddingLeft: 0, paddingBottom: 0, paddingRight: 0, width: 0, height: 0)
        addSubview(cancelBtn)
        cancelBtn.anchor(top: topAnchor, left: leftAnchor, bottom: nil, right: nil, paddingTop: 12, paddingLeft: 12, paddingBottom: 0, paddingRight: 0, width: 50, height: 50)
        addSubview(saveBtn)
        saveBtn.anchor(top: nil, left: leftAnchor, bottom: bottomAnchor, right: nil, paddingTop: 0, paddingLeft: 12, paddingBottom: 12, paddingRight: 0, width: 100, height: 100)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    @objc func cancelBtnWasPressed() {
        self.removeFromSuperview()
    }
    
    @objc func saveBtnWasPressed() {
        print("Save pressed")
        guard let previewImage = previewImageView.image else { return }
        
        let library = PHPhotoLibrary.shared()
        
        library.performChanges({
            PHAssetChangeRequest.creationRequestForAsset(from: previewImage)
        }) { (success, error) in
            if let error = error {
                print("Failed to save image to Photo library:", error)
            }
            
            print("Successfully save image to Photo library")
            DispatchQueue.main.async {
                let savedLbl = UILabel()
                
                savedLbl.text = "Saved Successfully"
                savedLbl.textColor = .white
                savedLbl.backgroundColor = UIColor(white: 0, alpha: 0.3)
                savedLbl.numberOfLines = 0
                savedLbl.font = UIFont(name: "Courier-Bold", size: 20)
                savedLbl.frame = CGRect(x: 0, y: 0, width: 220, height: 80)
                savedLbl.center = self.center
                savedLbl.textAlignment = .center
                
                self.addSubview(savedLbl)
                
                savedLbl.layer.transform = CATransform3DMakeScale(0, 0, 0)
                
                UIView.animate(withDuration: 0.5, delay: 0, usingSpringWithDamping: 0.5, initialSpringVelocity: 0.5, options: .curveEaseOut, animations: {
                        savedLbl.layer.transform = CATransform3DMakeScale(1, 1, 1)
                }, completion: { (completed) in
                    //completed
                    UIView.animate(withDuration: 0.5, delay: 0.75, usingSpringWithDamping: 0.5, initialSpringVelocity: 0.5, options: .curveEaseOut, animations: {
                        savedLbl.layer.transform = CATransform3DMakeScale(0.1, 0.1, 0.1)
                        savedLbl.alpha = 0
                    }, completion: { (_) in
                        savedLbl.removeFromSuperview()
                    })
                })
            }
            
        }
    }
}
