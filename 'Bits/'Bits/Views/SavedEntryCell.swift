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
    
    let titleLabel: UITextView = {
        let titleLabel = UITextView()
        titleLabel.isEditable = false
        titleLabel.backgroundColor = UIColor(named: Color.suitUpSilver.rawValue)
        titleLabel.text = "This is the title"
        titleLabel.font = UIFont.systemFont(ofSize: 14.0, weight: .medium)
        let inset: CGFloat = 3
        titleLabel.textContainerInset = UIEdgeInsets(top: inset + 1, left: inset - 1, bottom: inset, right: inset)
        titleLabel.textColor = UIColor(named: Color.washedWhite.rawValue)
        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        return titleLabel
    }()
    
    let dateLabel: UITextView = {
        let dateLabel = UITextView()
        dateLabel.isEditable = false
        dateLabel.backgroundColor = UIColor(named: Color.suitUpSilver.rawValue)
        dateLabel.text = "01.01.2019"
        dateLabel.font = UIFont.systemFont(ofSize: 12.0, weight: .medium)
        let inset: CGFloat = 3
        dateLabel.textContainerInset = UIEdgeInsets(top: inset + 1, left: inset - 1, bottom: inset, right: inset)
        dateLabel.textColor = UIColor(named: Color.washedWhite.rawValue)
        dateLabel.translatesAutoresizingMaskIntoConstraints = false
        return dateLabel
    }()
    
    let deleteLabelLeft: UILabel = {
        let deleteLabelLeft = UILabel()
        deleteLabelLeft.text = "Delete"
        deleteLabelLeft.font = UIFont.systemFont(ofSize: 16.0, weight: .heavy)
        deleteLabelLeft.textColor = UIColor(named: Color.washedWhite.rawValue)
        return deleteLabelLeft
    }()
    
    let deleteLabelRight: UILabel = {
        let deleteLabelRight = UILabel()
        deleteLabelRight.text = "Delete"
        deleteLabelRight.font = UIFont.systemFont(ofSize: 16.0, weight: .heavy)
        deleteLabelRight.textColor = UIColor(named: Color.washedWhite.rawValue)
        return deleteLabelRight
    }()
    
    lazy var touchScreen: UIView = {
       let touchScreen = UIView()
       return touchScreen
    }()
    
    var pan: UIPanGestureRecognizer! // This looks for dragging gestures

    override func setupViews() {
        super.setupViews()
        
        self.contentView.backgroundColor = UIColor.systemYellow // MARK: Cell Background Color
        self.backgroundColor = UIColor.red // MARK: Color behind cell
        
        self.contentView.addSubview(thumbnailImageView)
        self.contentView.addSubview(titleLabel)
        self.contentView.addSubview(dateLabel)
        self.contentView.addSubview(touchScreen)
        
        self.insertSubview(deleteLabelLeft, belowSubview: self.contentView)
        self.insertSubview(deleteLabelRight, belowSubview: self.contentView)
        
        pan = UIPanGestureRecognizer(target: self, action: #selector(onPan(_:)))
        pan.delegate = self
        self.addGestureRecognizer(pan)
        
        // MARK: Thumbnail Constraints
        let imageSize: CGFloat = 70
        let smallSpacing: CGFloat = 8
        let largeSpacing: CGFloat = 10
        
        addConstraintsWithFormat("H:|-\(largeSpacing)-[v0(\(imageSize))]-\(smallSpacing)-[v1]-\(largeSpacing)-|", views: thumbnailImageView, titleLabel)
        addConstraintsWithFormat("H:|-\(largeSpacing)-[v0(\(imageSize))]-\(smallSpacing)-[v1]-\(largeSpacing)-|", views: thumbnailImageView, dateLabel)
        addConstraintsWithFormat("V:|-\(largeSpacing)-[v0(\(imageSize))]-\(largeSpacing)-|", views: thumbnailImageView)
        addConstraintsWithFormat("V:|-\(largeSpacing)-[v0(40)]-\(smallSpacing)-[v1(22)]-\(largeSpacing)-|", views: titleLabel, dateLabel)
        
        // Touchscreen ensures cell can only be selected as a whole without user accidentally triggering editing of textViews
        addConstraintsWithFormat("H:|[v0]|", views: touchScreen)
        addConstraintsWithFormat("V:|[v0]|", views: touchScreen)

    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        if (pan.state == UIGestureRecognizer.State.changed) {
          let point: CGPoint = pan.translation(in: self)
          let width = self.contentView.frame.width
          let height = self.contentView.frame.height
          self.contentView.frame = CGRect(x: point.x,y: 0, width: width, height: height);
          self.deleteLabelLeft.frame = CGRect(x: point.x - deleteLabelLeft.frame.size.width - 10, y: 0, width: 100, height: height)
          self.deleteLabelRight.frame = CGRect(x: point.x + width + deleteLabelRight.frame.size.width, y: 0, width: 100, height: height)
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
                collectionView.delegate?.collectionView!(collectionView, performAction: #selector(onPan(_:)), forItemAt: indexPath, withSender: nil) // MARK: Issue?
            } else {
                UIView.animate(withDuration: 0.2, animations: {
                    self.setNeedsLayout()
                    self.layoutIfNeeded()
                })
            }
        }
    }
    
    // This allows cell to handle multiple gesture recognizers (in this case; scroll, tap and drag )
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

