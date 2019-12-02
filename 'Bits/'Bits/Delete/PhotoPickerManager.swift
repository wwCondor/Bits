//
//  PhotoPickerManager.swift
//  'Bits
//
//  Created by Wouter Willebrands on 02/12/2019.
//  Copyright © 2019 Studio Willebrands. All rights reserved.
//

import UIKit
import MobileCoreServices

class PhotoPickerManager: NSObject {
    private let imagePickerController = UIImagePickerController()
    
    override init() {
        super.init()
        
        configure()
    }
    
    func configure() {
        if UIImagePickerController.isSourceTypeAvailable(.camera) {
            imagePickerController.sourceType = .camera
        } else {
            imagePickerController.sourceType = .photoLibrary
        }
        
        imagePickerController.mediaTypes = [kUTTypeImage as String]
        imagePickerController.delegate = self
    }
}

extension PhotoPickerManager: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
}

