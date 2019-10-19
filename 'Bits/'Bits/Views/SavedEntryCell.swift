//
//  SavedPostCell.swift
//  'Bits
//
//  Created by Wouter Willebrands on 10/10/2019.
//  Copyright © 2019 Studio Willebrands. All rights reserved.
//

import UIKit


// This is the saved entry displayed inside the collectionView on the main screen
class SavedEntryCell: BaseCell, UIGestureRecognizerDelegate {
    
    let thumbnailImageView: UIImageView = {
        let imageView = UIImageView()
//        imageView.image = UIImage(named: "BitsThumbnail") // Sets default image
        imageView.backgroundColor = UIColor.systemBlue
        imageView.translatesAutoresizingMaskIntoConstraints = false
//        imageView.layer.cornerRadius = 8
//        imageView.layer.masksToBounds = true
        return imageView
    }()
    
    let titleLabel: UILabel = {
        let titleLabel = UILabel()
        titleLabel.backgroundColor = UIColor(named: Color.suitUpSilver.rawValue)
        titleLabel.text = "This is the title"
        titleLabel.textColor = UIColor(named: Color.washedWhite.rawValue)
        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        return titleLabel
    }()
    
    let dateLabel: UILabel = {
        let dateLabel = UILabel()
        dateLabel.backgroundColor = UIColor(named: Color.suitUpSilver.rawValue)
        dateLabel.text = "01.01.2019"
        dateLabel.textColor = UIColor(named: Color.washedWhite.rawValue)
        dateLabel.translatesAutoresizingMaskIntoConstraints = false
        return dateLabel
    }()
    
    let deleteLabelOne: UILabel = {
        let deleteLabelOne = UILabel()
        deleteLabelOne.text = "Delete"
        deleteLabelOne.textColor = UIColor(named: Color.washedWhite.rawValue)
        return deleteLabelOne
    }()
    
    let deleteLabelTwo: UILabel = {
        let deleteLabelTwo = UILabel()
        deleteLabelTwo.text = "Delete"
        deleteLabelTwo.textColor = UIColor(named: Color.washedWhite.rawValue)
        return deleteLabelTwo
    }()
    
    var pan: UIPanGestureRecognizer! // This looks for dragging gestures

    override func setupViews() {
        super.setupViews()
        
        self.contentView.backgroundColor = UIColor.systemYellow // MARK: Cell Background Color
        self.backgroundColor = UIColor.red // MARK: Color behind cell
        
        self.contentView.addSubview(thumbnailImageView)
        self.contentView.addSubview(titleLabel)
        self.contentView.addSubview(dateLabel)
        
        self.insertSubview(deleteLabelOne, belowSubview: self.contentView)
        self.insertSubview(deleteLabelTwo, belowSubview: self.contentView)
        
        pan = UIPanGestureRecognizer(target: self, action: #selector(onPan(_:)))
        pan.delegate = self
        self.addGestureRecognizer(pan)
        
        // MARK: Thumbnail Constraints
        // Total Size = 92
        // This sets te size of the thumbnailImageView inside the cell
        let imageSize: CGFloat = 70 //bounds.height * (10/12) // Since it is a square we can set them both up here at the same time
//        thumbnailImageView.heightAnchor.constraint(equalToConstant: imageViewIconSquareSide) .isActive = true
//        thumbnailImageView.widthAnchor.constraint(equalToConstant: imageViewIconSquareSide).isActive = true
        
        let smallSpacing: CGFloat = 8
        let largeSpacing: CGFloat = 10
        
        addConstraintsWithFormat("H:|-\(largeSpacing)-[v0(\(imageSize))]-\(smallSpacing)-[v1]-\(largeSpacing)-|", views: thumbnailImageView, titleLabel)
        addConstraintsWithFormat("H:|-\(largeSpacing)-[v0(\(imageSize))]-\(smallSpacing)-[v1]-\(largeSpacing)-|", views: thumbnailImageView, dateLabel)
        addConstraintsWithFormat("V:|-\(largeSpacing)-[v0(\(imageSize))]-\(largeSpacing)-|", views: thumbnailImageView)
        addConstraintsWithFormat("V:|-\(largeSpacing)-[v0]-\(smallSpacing)-[v1]-\(largeSpacing)-|", views: titleLabel, dateLabel)


        // MARK: Separator Contstraints
//        separatorView.widthAnchor.constraint(equalToConstant: frame.width) .isActive = true
//        separatorView.heightAnchor.constraint(equalToConstant: 1).isActive = true
//
//
//        addConstraintsWithFormat("H:|[v0]|", views: separatorView)
//        addConstraintsWithFormat("V:|[v0(1)]|", views: separatorView)
        

    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        if (pan.state == UIGestureRecognizer.State.changed) {
          let point: CGPoint = pan.translation(in: self)
          let width = self.contentView.frame.width
          let height = self.contentView.frame.height
          self.contentView.frame = CGRect(x: point.x,y: 0, width: width, height: height);
          self.deleteLabelOne.frame = CGRect(x: point.x - deleteLabelOne.frame.size.width - 10, y: 0, width: 100, height: height)
          self.deleteLabelTwo.frame = CGRect(x: point.x + width + deleteLabelTwo.frame.size.width, y: 0, width: 100, height: height)
        }
    }
    
    @objc func onPan(_ pan: UIPanGestureRecognizer) {
        if pan.state == UIPanGestureRecognizer.State.began {
            
        } else if pan.state == UIPanGestureRecognizer.State.changed {
            self.setNeedsLayout()
        } else {
            if abs(pan.velocity(in: self).x) > 500 { // Here we check the swipe velocity
                let collectionView: UICollectionView = self.superview as! UICollectionView
                let indexPath: IndexPath = collectionView.indexPathForItem(at: self.center)!
                collectionView.delegate?.collectionView!(collectionView, performAction: #selector(onPan(_:)), forItemAt: indexPath, withSender: nil)
            } else {
                UIView.animate(withDuration: 0.2, animations: {
                    self.setNeedsLayout()
                    self.layoutIfNeeded()
                })
            }
        }
    }
    
    // This allows cell to handle multiple gesture recognizers (scroll, tap and drag in this case)
    func gestureRecognizer(_ gestureRecognizer: UIGestureRecognizer, shouldRecognizeSimultaneouslyWith otherGestureRecognizer: UIGestureRecognizer) -> Bool {
      return true
    }
    
    // Here we make sure the gesture is only called when the velocity of movement in x > y direction
    override func gestureRecognizerShouldBegin(_ gestureRecognizer: UIGestureRecognizer) -> Bool {
      return abs((pan.velocity(in: pan.view)).x) > abs((pan.velocity(in: pan.view)).y)
    }
    
}






// The superclass from which all other cells inherit
class BaseCell: UICollectionViewCell {
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupViews()
    }
    
    func setupViews() {
        
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
}

