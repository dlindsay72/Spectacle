//
//  CustomImageView.swift
//  Spectacle
//
//  Created by Dan Lindsay on 2018-05-22.
//  Copyright © 2018 Dan Lindsay. All rights reserved.
//

import UIKit

var imageCache = [String: UIImage]()

class CustomImageView: UIImageView {
    var lastURLUsedToLoadImage: String?
    
    func loadImage(fromUrlString urlString: String) {
        lastURLUsedToLoadImage = urlString
        
        if let cacheImage = imageCache[urlString] {
            self.image = cacheImage
            return
        }
        
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
            imageCache[url.absoluteString] = photoImage
            
            DispatchQueue.main.async {
                self.image = photoImage
            }
            }.resume()
    }
}
