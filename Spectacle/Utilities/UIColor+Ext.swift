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
}
