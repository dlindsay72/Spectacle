//
//  Extensions.swift
//  Spectacle
//
//  Created by Dan Lindsay on 2018-05-14.
//  Copyright © 2018 Dan Lindsay. All rights reserved.
//

import UIKit

extension UIColor {
    static func rgb(red: CGFloat, green: CGFloat, blue: CGFloat) -> UIColor {
        return UIColor(red: red/255.0, green: green/255.0, blue: blue/255.0, alpha: 1.0)
    }
    
    static func mainBlue() -> UIColor {
        return #colorLiteral(red: 0.2784313725, green: 0.5803921569, blue: 0.9450980392, alpha: 1)
    }
    
    static func customGray() -> UIColor {
        return UIColor(white: 0, alpha: 0.2)
    }
}
