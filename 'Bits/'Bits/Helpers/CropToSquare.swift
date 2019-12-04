//
//  CropToSquare.swift
//  'Bits
//
//  Created by Wouter Willebrands on 26/11/2019.
//  Copyright © 2019 Studio Willebrands. All rights reserved.
//

//import UIKit
//
//// This function should crop the images to be filtered to a square
//func cropToSquare(image: UIImage, width: Double, height: Double) -> UIImage {
//
//    let cgImage = image.cgImage!
//    let contextImage: UIImage = UIImage(cgImage: cgImage)
//    let contextSize: CGSize = contextImage.size
//    var posX: CGFloat = 0.0
//    var posY: CGFloat = 0.0
//    var cgWidth: CGFloat = CGFloat(width)
//    var cgHeight: CGFloat = CGFloat(height)
//
//    // See what size is longer and create the center off of that
//    if contextSize.width > contextSize.height {
//        posX = ((contextSize.width - contextSize.height) / 2)
//        posY = 0
//        cgWidth = contextSize.height
//        cgHeight = contextSize.height
//    } else {
//        posX = 0
//        posY = ((contextSize.height - contextSize.width) / 2)
//        cgWidth = contextSize.width
//        cgHeight = contextSize.width
//    }
//
//    let rect: CGRect = CGRect(x: posX, y: posY, width: cgWidth, height: cgHeight)
//
//    // Create bitmap image from context using the rect
//    let imageRef: CGImage = cgImage.cropping(to: rect)!
//
//    // Create a new image based on the imageRef and rotate back to the original orientation
//    let image: UIImage = UIImage(cgImage: imageRef, scale: image.scale, orientation: image.imageOrientation)
//
//    return image
//}
