//
//  MenuItemCell.swift
//  'Bits
//
//  Created by Wouter Willebrands on 12/10/2019.
//  Copyright © 2019 Studio Willebrands. All rights reserved.
//

import UIKit


// This
class MenuItemCell: BaseCell {
    
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
    
    lazy var saveButton: UIButton = {
        let saveButton = UIButton()
        let image = UIImage(named: "SaveIcon") // ?.withRenderingMode(.alwaysTemplate)
        saveButton.setImage(image, for: .normal)
        saveButton.addTarget(self, action: #selector(saveEntry), for: .touchUpInside)
        return saveButton
    }()
    
   
    override func setupViews() {
        super.setupViews()
        
        // Noticationcenter: A notification dispatch mechanism that enables the broadcast of information to registered observers.
        NotificationCenter.default.addObserver(self, selector: #selector(self.keyboardWillShow), name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(self.keyboardWillHide), name: UIResponder.keyboardWillHideNotification, object: nil)
        
        backgroundColor = UIColor.yellow
        
        addSubview(entryImage)
        addSubview(entryTitle)
        addSubview(entryDate)
        addSubview(saveButton)
        addSubview(entryContent)
        
        let thumbnailImageSize: CGFloat = 70
        let labelHeight: CGFloat = 31
        let smallSpacing: CGFloat = 8
        let largeSpacing: CGFloat = 10

    
        
    addConstraintsWithFormat("H:|-\(largeSpacing)-[v0(\(thumbnailImageSize))]-\(smallSpacing)-[v1]-\(smallSpacing)-[v2(\(thumbnailImageSize))]-\(largeSpacing)-|", views: entryImage, entryTitle, saveButton)
        addConstraintsWithFormat("H:|-\(largeSpacing)-[v0]-\(smallSpacing)-[v1]-\(smallSpacing)-[v2]-\(largeSpacing)-|", views: entryImage, entryDate, saveButton)
        addConstraintsWithFormat("H:|-\(largeSpacing)-[v0]-\(largeSpacing)-|", views: entryContent)
        
        addConstraintsWithFormat("V:|-\(largeSpacing)-[v0(\(thumbnailImageSize))]-\(smallSpacing)-[v1]-\(largeSpacing)-|", views: entryImage, entryContent)
        addConstraintsWithFormat("V:|-\(largeSpacing)-[v0(\(labelHeight))]-\(smallSpacing)-[v1(\(labelHeight))]-\(smallSpacing)-[v2]-\(largeSpacing)-|", views: entryTitle, entryDate, entryContent)
        addConstraintsWithFormat("V:|-\(largeSpacing)-[v0(\(thumbnailImageSize))]-\(smallSpacing)-[v1]-\(largeSpacing)-|", views: saveButton, entryContent)

//        addConstraint(NSLayoutConstraint(item: entryContent, attribute: .bottom, relatedBy: .equal, toItem: safeAreaLayoutGuide, attribute: .top, multiplier: 1, constant: 100))
        
    }
    
    @objc func saveEntry(sender: UIButton!) {
        print("Entry Saved")
    }
    
    
    @objc func keyboardWillShow(notification: NSNotification) {
        guard let userInfo = notification.userInfo else { return }
        guard let keyboardSize = userInfo[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue else { return }
        
        let keyboardFrame = keyboardSize.cgRectValue
        
        // In here something needs to slide up
        
        if super.frame.origin.y == 0 {
            super.frame.origin.y -= keyboardFrame.height
        }

    }
    @objc func keyboardWillHide(notification: NSNotification) {
        if super.frame.origin.y != 0 {
            super.frame.origin.y = 0
        }
    }
    

    
    
}

// Since it is closely related
class SaveButtonView: UIView {//}, UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout {
//class SaveButtonCell: BaseCell {
    
    let imageView: UIImageView = {
        let imageView = UIImageView()
//                imageView.backgroundColor = UIColor(named: "GentlemanGray")
        imageView.image = UIImage(named: "AddIcon")?.withRenderingMode(.alwaysTemplate)
//        imageView.tintColor = UIColor(named: "WashedWhite") // MARK: Set Button Icon Color
        return imageView
    }()


    func setupView() {

        addSubview(imageView)
        
        imageView.backgroundColor = UIColor.systemPink
        
        
        let imageViewIconSquareSide = bounds.height * (3/7) // Since it is a square we can set them both up here at the same time
        imageView.translatesAutoresizingMaskIntoConstraints = false // enabels autoLayout for menuBar
        imageView.heightAnchor.constraint(equalToConstant: imageViewIconSquareSide).isActive = true
        imageView.widthAnchor.constraint(equalToConstant: imageViewIconSquareSide).isActive = true
        
        // This centers the icon inside the cell
        addConstraint(NSLayoutConstraint(item: imageView, attribute: .centerX, relatedBy: .equal, toItem: self, attribute: .centerX, multiplier: 1, constant: 0))
        addConstraint(NSLayoutConstraint(item: imageView, attribute: .centerY, relatedBy: .equal, toItem: self, attribute: .centerY, multiplier: 1, constant: 0))
        
//        addConstraintsWithFormat("H:|-5-[v0]-5-|", views: imageView)
//        addConstraintsWithFormat("V:|-5-[v0]-5-|", views: imageView)

    }

}
