//
//  CollectedBitsView.swift
//  'Bits
//
//  Created by Wouter Willebrands on 09/10/2019.
//  Copyright © 2019 Studio Willebrands. All rights reserved.
//

import UIKit

class CollectedBitsView: UIView, UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout {
    
    lazy var collectedBitsView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        let collectedBitsView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collectedBitsView.backgroundColor = UIColor(named: "SuitUpSilver") // color of the container holding the cells
//        collectedBitsView.backgroundColor = UIColor.white // Testcolor

        collectedBitsView.dataSource = self
        collectedBitsView.delegate = self
        return collectedBitsView
    }()
    
    let cellId = "cellId"
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        // Register BitsCell object for use in creating new cells
        collectedBitsView.register(BitsCell.self, forCellWithReuseIdentifier: cellId)
        
        // Adds the collectionView to the subView
        addSubview(collectedBitsView)
        
        // Constraints setup
        addConstraintsWithFormat("H:|[v0]|", views: collectedBitsView)
        addConstraintsWithFormat("V:|[v0]|", views: collectedBitsView)
        
    }
    
    
    // MARK: Delegate Methods
    // This is the amount of cells inside the collectionView
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 12 // This should become equal to the amount of posts in memory
    }
    
    
    // Returns a reusable cell object located by its identifier
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: cellId, for: indexPath)
        
        cell.backgroundColor = UIColor(named: "WashedWhite") // color of the cells within the container
        cell.layer.cornerRadius = 6
        cell.layer.masksToBounds = true
        
        return cell
    }
    
    // This set the size of the cells
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: frame.width * (7/8), height: 92)
    }
    
    // This sets the spacing between the posts
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 0
    }
    
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
}


// MARK: Fixme - Refactor: Superclass inheritance
class BitsCell: UICollectionViewCell {
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupViews()
    }

    let thumbnailImageView: UIImageView = {
        let imageView = UIImageView()
//        imageView.backgroundColor = UIColor(named: "WashedWhite")
        imageView.image = UIImage(named: "BitsThumbnail") // Sets default image
//        imageView.backgroundColor = UIColor.red
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.layer.cornerRadius = 8
        imageView.layer.masksToBounds = true
        return imageView
    }()
    
    let titleLabel: UILabel = {
        let titleLabel = UILabel()
        
        titleLabel.backgroundColor = UIColor(named: "SuitUpSilver")
        titleLabel.text = "This is where the title comes"
        titleLabel.textColor = UIColor(named: "WashedWhite")

        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        
        return titleLabel
    }()
    
    let dateLabel: UILabel = {
        let titleLabel = UILabel()
        
        titleLabel.backgroundColor = UIColor(named: "SuitUpSilver")
        titleLabel.text = "01.01.2019"
        titleLabel.textColor = UIColor(named: "WashedWhite")
        
        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        
        return titleLabel
    }()
    
//     This adds a space between the posts
    let separatorView: UIView = {
        let view = UIView()
        view.backgroundColor = UIColor.red
//        view.backgroundColor = UIColor(named: "GentlemanGray")
        view.translatesAutoresizingMaskIntoConstraints = false
//        view.layer.cornerRadius = 8
//        view.layer.masksToBounds = true
        return view
    }()



    func setupViews() {
        addSubview(thumbnailImageView)
        addSubview(titleLabel)
        addSubview(dateLabel)
        addSubview(separatorView)
        
        // MARK: Thumbnail Constraints
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

        


        // This makes sure there is a leading, top and bottom padding of 1/12 of the cell's height
//        addConstraint(NSLayoutConstraint(item: thumbnailImageView, attribute: .centerY, relatedBy: .equal, toItem: self, attribute: .centerY, multiplier: 1, constant: 0))
//        addConstraint(NSLayoutConstraint(item: thumbnailImageView, attribute: .leading, relatedBy: .equal, toItem: self, attribute: .leading, multiplier: 1, constant: largeSpacing))

        // MARK: TitleLabel Constraints
        
//        // top constraint
//        addConstraint(NSLayoutConstraint(item: titleLabel, attribute: .top, relatedBy: .equal, toItem: contentView, attribute: .top, multiplier: 1, constant: CGFloat(smallSpacing)))
//        // left constraint
//        addConstraint(NSLayoutConstraint(item: titleLabel, attribute: .left, relatedBy: .equal, toItem: thumbnailImageView, attribute: .right, multiplier: 1, constant: CGFloat(largeSpacing)))
//        // right constraint
//        addConstraint(NSLayoutConstraint(item: titleLabel, attribute: .right, relatedBy: .equal, toItem: contentView, attribute: .right, multiplier: 1, constant: CGFloat(largeSpacing)))

        // MARK: DateLabel Constraints

        
//        titleLabel.heightAnchor.constraint(equalToConstant: bounds.height * (4/12)).isActive = true
//        addConstraint(NSLayoutConstraint(item: titleLabel, attribute: .trailing, relatedBy: .equal, toItem: self, attribute: .trailing, multiplier: 1, constant: bounds.height * (1/12)))
        



//        addConstraintsWithFormat("H:|-12-[v0(48)]-6-[v1]-12-|", views: thumbnailImageView, titleLabel)
//
//        addConstraintsWithFormat("V:|-12-[v0]-12-|", views: thumbnailImageView)
//        addConstraintsWithFormat("V:|-12-[v0]-6-[v1]-12-|", views: titleLabel, dateLabel)
//
//        addConstraintsWithFormat("H:|[v0]-12-|", views: dateLabel)

        // MARK: Separator Contstraints
        // Separator width is the same as the cellwidht, height = 1
        separatorView.widthAnchor.constraint(equalToConstant: frame.width) .isActive = true
        separatorView.heightAnchor.constraint(equalToConstant: 1).isActive = true
        
        
        addConstraintsWithFormat("H:|[v0]|", views: separatorView)
        addConstraintsWithFormat("V:|[v0(1)]|", views: separatorView)




        
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
}
