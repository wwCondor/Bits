//
//  Extensions.swift
//  'Bits
//
//  Created by Wouter Willebrands on 10/10/2019.
//  Copyright © 2019 Studio Willebrands. All rights reserved.
//

import UIKit

extension UIView {
    // Alows setting constraint easily
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

extension UIViewController {
    // Hides keyboard when view is tapped
    func hideKeyboardOnBackgroundTap() {
        let tap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(UIViewController.dismissKeyboard))
        tap.cancelsTouchesInView = false
        view.addGestureRecognizer(tap)
    }

    @objc func dismissKeyboard() {
        view.endEditing(true)
    }
}

extension UIViewController {
    func presentAlert(description: String, viewController: UIViewController) {
        // Alert
        let alert = UIAlertController(title: nil, message: description, preferredStyle: .alert)
        
        let confirmation = UIAlertAction(title: "OK", style: .default) {
            (action) in alert.dismiss(animated: true, completion: nil)
        }
        
        alert.addAction(confirmation)
        viewController.present(alert, animated: true, completion: nil)
    }
    
    func presentFailedPermissionActionSheet(description: String, viewController: UIViewController) {
        // Actionsheet
        let actionSheet = UIAlertController(title: nil, message: description, preferredStyle: .actionSheet)
        
        actionSheet.addAction(UIAlertAction(title: "Yes, take me to Settings", style: .default, handler: { (action) in
            if let settingsURL = URL(string: UIApplication.openSettingsURLString + Bundle.main.bundleIdentifier!) {
                UIApplication.shared.open(settingsURL, options: [:], completionHandler: nil)
            }
        }))
        
        actionSheet.addAction(UIAlertAction(title: "No, thanks.", style: .cancel, handler: { (action) in
            
        }))
        
        viewController.present(actionSheet, animated: true, completion: nil)
    }
}

extension UIImage {
    // Converts image to data
    func convertedToData() -> Data? {
        let data: Data? = self.pngData()
        return data
    }
}

extension UIImage {
    func isSquare() -> Bool {
        let image: UIImage = self
        if image.size.width == image.size.height {
            return true
        } else {
            return false
        }
    }
}

extension UIImage {
    func croppedToSquare(size: Double) -> UIImage {
        let cgImage = self.cgImage!
        let contextImage: UIImage = UIImage(cgImage: cgImage)
        let contextSize: CGSize = contextImage.size
        var posX: CGFloat = 0.0
        var posY: CGFloat = 0.0
        var cgWidth: CGFloat = CGFloat(size)
        var cgHeight: CGFloat = CGFloat(size)

        // See what size is longer and create the center off of that
        if contextSize.width > contextSize.height {
            posX = ((contextSize.width - contextSize.height) / 2)
            posY = 0
            cgWidth = contextSize.height
            cgHeight = contextSize.height
        } else {
            posX = 0
            posY = ((contextSize.height - contextSize.width) / 2)
            cgWidth = contextSize.width
            cgHeight = contextSize.width
        }

        let rect: CGRect = CGRect(x: posX, y: posY, width: cgWidth, height: cgHeight)

        // Create bitmap image from context using the rect
        let imageRef: CGImage = cgImage.cropping(to: rect)!

        // Create a new image based on the imageRef and rotate back to the original orientation
        let image: UIImage = UIImage(cgImage: imageRef, scale: self.scale, orientation: self.imageOrientation)

        return image
    }
}

extension UIImage {
    func resizedSquare(to size: Double) -> UIImage {
        let cgImage = self.cgImage!
        let posX: CGFloat = 0.0
        let posY: CGFloat = 0.0
        let cgSize: CGFloat = CGFloat(size)
        
        let rect: CGRect = CGRect(x: posX, y: posY, width: cgSize, height: cgSize)
        let imageRef: CGImage = cgImage.cropping(to: rect)!
        
        let image: UIImage = UIImage(cgImage: imageRef, scale: self.scale, orientation: self.imageOrientation)
        
        return image
    }
}
