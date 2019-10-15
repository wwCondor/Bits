//
//  NewEntry.swift
//  'Bits
//
//  Created by Wouter Willebrands on 15/10/2019.
//  Copyright © 2019 Studio Willebrands. All rights reserved.
//

import UIKit

class NewEntry: BaseCell {
    
    lazy var entryImage: UIImageView = {
        let entryImage = UIImageView()
        //        entryImage.backgroundColor = UIColor.red
        entryImage.image = UIImage(named: "BitsThumbnail") // Sets default image
        entryImage.translatesAutoresizingMaskIntoConstraints = false
        entryImage.layer.cornerRadius = 8
        entryImage.layer.masksToBounds = true
        return entryImage
    }()
    
    // These might becomeUITextLabel instead
    lazy var entryTitle: UITextField = {
        let entryTitle = UITextField()
        entryTitle.backgroundColor = UIColor.systemTeal
        //            titleLabel.backgroundColor = UIColor(named: "SuitUpSilver")
        entryTitle.textColor = UIColor(named: "WashedWhite")
        entryTitle.text = "This is the title"
        entryTitle.textAlignment = .center
        entryTitle.layer.cornerRadius = 8
        entryTitle.layer.masksToBounds = true
        
        entryTitle.translatesAutoresizingMaskIntoConstraints = false
        
        return entryTitle
    }()
    
    lazy var entryDate: UILabel = {
        let entryDate = UILabel()
        entryDate.backgroundColor = UIColor.green
        //            dateLabel.backgroundColor = UIColor(named: "SuitUpSilver")
        entryDate.textColor = UIColor(named: "WashedWhite")
        entryDate.text = "01.01.2019"
        entryDate.textAlignment = .center
        entryDate.layer.cornerRadius = 8
        entryDate.layer.masksToBounds = true
        
        entryDate.translatesAutoresizingMaskIntoConstraints = false
        
        return entryDate
    }()
    
    lazy var entryContent: UITextView = {
        let entryContent = UITextView()
        entryContent.backgroundColor = UIColor.purple
        //        postContent.backgroundColor = UIColor(named: "SuitUpSilver")
        entryContent.text = "Random Text."
        entryContent.textAlignment = .left
        entryContent.textContainer.maximumNumberOfLines = 10
        let textInset: CGFloat = 10
        entryContent.textContainerInset = UIEdgeInsets(top: textInset, left: textInset, bottom: textInset, right: textInset)
        entryContent.textColor = UIColor.white
        entryContent.translatesAutoresizingMaskIntoConstraints = false
        entryContent.layer.cornerRadius = 8
        entryContent.layer.masksToBounds = true
        
        return entryContent
    }()
    
    
    override func setupViews() {
        super.setupViews()
        
        // Noticationcenter: A notification dispatch mechanism that enables the broadcast of information to registered observers.
//        NotificationCenter.default.addObserver(self, selector: #selector(self.keyboardWillShow), name: UIResponder.keyboardWillShowNotification, object: nil)
//        NotificationCenter.default.addObserver(self, selector: #selector(self.keyboardWillHide), name: UIResponder.keyboardWillHideNotification, object: nil)
        
        backgroundColor = UIColor.yellow
        
//        addSubview(entryImage)
//        addSubview(entryTitle)
//        addSubview(entryDate)
//        addSubview(entryContent)
        
//        let thumbnailImageSize: CGFloat = 70
//        let labelHeight: CGFloat = 31
//        let smallSpacing: CGFloat = 8
//        let largeSpacing: CGFloat = 10
        
        
        
//        addConstraintsWithFormat("H:|-\(largeSpacing)-[v0(\(thumbnailImageSize))]-\(smallSpacing)-[v1]-\(smallSpacing)-[v2(\(thumbnailImageSize))]-\(largeSpacing)-|", views: entryImage, entryTitle, saveButton)
//        addConstraintsWithFormat("H:|-\(largeSpacing)-[v0]-\(smallSpacing)-[v1]-\(smallSpacing)-[v2]-\(largeSpacing)-|", views: entryImage, entryDate, saveButton)
//        addConstraintsWithFormat("H:|-\(largeSpacing)-[v0]-\(largeSpacing)-|", views: entryContent)
//
//        addConstraintsWithFormat("V:|-\(largeSpacing)-[v0(\(thumbnailImageSize))]-\(smallSpacing)-[v1]-\(largeSpacing)-|", views: entryImage, entryContent)
//        addConstraintsWithFormat("V:|-\(largeSpacing)-[v0(\(labelHeight))]-\(smallSpacing)-[v1(\(labelHeight))]-\(smallSpacing)-[v2]-\(largeSpacing)-|", views: entryTitle, entryDate, entryContent)
//        addConstraintsWithFormat("V:|-\(largeSpacing)-[v0(\(thumbnailImageSize))]-\(smallSpacing)-[v1]-\(largeSpacing)-|", views: entryContent)
        
        //        addConstraint(NSLayoutConstraint(item: entryContent, attribute: .bottom, relatedBy: .equal, toItem: safeAreaLayoutGuide, attribute: .top, multiplier: 1, constant: 100))
        
    }
    
    
    
}
