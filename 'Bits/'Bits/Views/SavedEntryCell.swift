//
//  SavedPostCell.swift
//  'Bits
//
//  Created by Wouter Willebrands on 10/10/2019.
//  Copyright © 2019 Studio Willebrands. All rights reserved.
//

import UIKit


// This is the saved entry displayed inside the collectionView on the main screen
class SavedEntryCell: BaseCell {

    let thumbnailImageView: UIImageView = {
        let imageView = UIImageView()
//        imageView.backgroundColor = UIColor(named: "WashedWhite")
//        imageView.image = UIImage(named: "BitsThumbnail") // Sets default image
        imageView.backgroundColor = UIColor.systemBlue
        imageView.translatesAutoresizingMaskIntoConstraints = false
//        imageView.layer.cornerRadius = 8
//        imageView.layer.masksToBounds = true
        return imageView
    }()
    
    // These might becomeUITextLabel instead
    let titleLabel: UILabel = {
        let titleLabel = UILabel()
        
        titleLabel.backgroundColor = UIColor(named: "SuitUpSilver")
        titleLabel.text = "This is the title"
        titleLabel.textColor = UIColor(named: "WashedWhite")

        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        
        return titleLabel
    }()
    
    let dateLabel: UILabel = {
        let dateLabel = UILabel()
        
        dateLabel.backgroundColor = UIColor(named: "SuitUpSilver")
        dateLabel.text = "01.01.2019"
        dateLabel.textColor = UIColor(named: "WashedWhite")
        
        dateLabel.translatesAutoresizingMaskIntoConstraints = false
        
        return dateLabel
    }()
    
////     This adds a space between the posts
//    let separatorView: UIView = {
//        let view = UIView()
//        view.backgroundColor = UIColor.red
////        view.backgroundColor = UIColor(named: "GentlemanGray")
//        view.translatesAutoresizingMaskIntoConstraints = false
////        view.layer.masksToBounds = true
//        return view
//    }()


    override func setupViews() {
        super.setupViews()
        
        addSubview(thumbnailImageView)
        addSubview(titleLabel)
        addSubview(dateLabel)
//        addSubview(separatorView)
        
        // MARK: Thumbnail Constraints
        
        // Total Size = 92
        // This sets te size of the thumbnailImageView inside the cell
        let thumbnailImageSize: CGFloat = 70 //bounds.height * (10/12) // Since it is a square we can set them both up here at the same time
//        thumbnailImageView.heightAnchor.constraint(equalToConstant: imageViewIconSquareSide) .isActive = true
//        thumbnailImageView.widthAnchor.constraint(equalToConstant: imageViewIconSquareSide).isActive = true
        
        let smallSpacing: CGFloat = 8
        let largeSpacing: CGFloat = 10
        
        addConstraintsWithFormat("H:|-\(largeSpacing)-[v0(\(thumbnailImageSize))]-\(smallSpacing)-[v1]-\(largeSpacing)-|", views: thumbnailImageView, titleLabel)
        addConstraintsWithFormat("H:|-\(largeSpacing)-[v0(\(thumbnailImageSize))]-\(smallSpacing)-[v1]-\(largeSpacing)-|", views: thumbnailImageView, dateLabel)
        addConstraintsWithFormat("V:|-\(largeSpacing)-[v0(\(thumbnailImageSize))]-\(largeSpacing)-|", views: thumbnailImageView)
        addConstraintsWithFormat("V:|-\(largeSpacing)-[v0]-\(smallSpacing)-[v1]-\(largeSpacing)-|", views: titleLabel, dateLabel)


        // MARK: Separator Contstraints
//        separatorView.widthAnchor.constraint(equalToConstant: frame.width) .isActive = true
//        separatorView.heightAnchor.constraint(equalToConstant: 1).isActive = true
//
//
//        addConstraintsWithFormat("H:|[v0]|", views: separatorView)
//        addConstraintsWithFormat("V:|[v0(1)]|", views: separatorView)

    }
    
}

