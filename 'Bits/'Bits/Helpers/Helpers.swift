//
//  Helpers.swift
//  'Bits
//
//  Created by Wouter Willebrands on 10/10/2019.
//  Copyright © 2019 Studio Willebrands. All rights reserved.
//

import UIKit

// This extension saves us from having to retype the 255's and the alpha values for each Color used
// Another way to do this is use the Color catalog, although that is subject to typo's
//extension UIColor {
//    static func rgb(red: CGFloat, green: CGFloat, blue: CGFloat) -> UIColor {
//        return UIColor(red: red/255, green: green/255, blue: blue/255, alpha: 1)
//    }
//    
//}

extension UIView {
    // Set constraints
    public func addConstraintsWithFormat(_ format: String, views: UIView...) {
        var viewsDictionary = [String: UIView]()

        for (index, view) in views.enumerated() {
            let key = "v\(index)"
            view.translatesAutoresizingMaskIntoConstraints = false
            viewsDictionary[key] = view
        }

       addConstraints(NSLayoutConstraint.constraints(withVisualFormat: format, options: NSLayoutConstraint.FormatOptions(rawValue: 0), metrics: nil, views: viewsDictionary))
    }
}


extension UIImage {
    // Image padding
    func addPadding(x: CGFloat, y: CGFloat) -> UIImage? {
        let width: CGFloat = size.width + x
        let height: CGFloat = size.height + y
        UIGraphicsBeginImageContextWithOptions(CGSize(width: width, height: height), false, 0)
        let origin: CGPoint = CGPoint(x: (width - size.width) / 2, y: (height - size.height) / 2)
        draw(at: origin)
        let imageWithPadding = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()

        return imageWithPadding
    }
}




