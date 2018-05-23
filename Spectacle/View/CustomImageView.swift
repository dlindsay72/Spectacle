//
//  CustomImageView.swift
//  Spectacle
//
//  Created by Dan Lindsay on 2018-05-22.
//  Copyright © 2018 Dan Lindsay. All rights reserved.
//

import UIKit

class CustomImageView: UIImageView {
    var lastURLUsedToLoadImage: String?
    
    func loadImage(fromUrlString urlString: String) {
        print("Loading image...")
        lastURLUsedToLoadImage = urlString
        guard let url = URL(string: urlString) else { return }
        
        URLSession.shared.dataTask(with: url) { (data, response, error) in
            if let error = error {
                print("Failed to fetch post image:", error)
                return
            }
            
            if url.absoluteString != self.lastURLUsedToLoadImage {
                return
            }
            
            guard let imageData = data else { return }
            
            let photoImage = UIImage(data: imageData)
            DispatchQueue.main.async {
                self.image = photoImage
            }
            }.resume()
    }
}
