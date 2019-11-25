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
    
    var pan: UIPanGestureRecognizer! // Looks for swipe gestures
    
    let thumbnailImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.image = UIImage(named: Icon.bitsThumb.image) // Sets default image
        imageView.backgroundColor = ColorConstants.labelColor
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.layer.cornerRadius = 5
        imageView.layer.masksToBounds = true
        return imageView
    }()
    
    let titleLabel: TitleLabel = {
        let titleLabel = TitleLabel()
        titleLabel.text = "This is the title"
        return titleLabel
    }()
    
    let dateLabel: ContentLabel = {
        let dateLabel = ContentLabel()
        dateLabel.text = "01.01.2019"
        return dateLabel
    }()
    
    let locationLabel: ContentLabel = {
        let locationLabel = ContentLabel()
        locationLabel.text = "Location"
        return locationLabel
    }()
    
    let storyLabel: ContentLabel = {
        let storyLabel = ContentLabel()
        storyLabel.text = "This is the story"
        return storyLabel
    }()

    // MARK: Refactor superclass
    let deleteLabelLeft: DeleteLabel = {
        let deleteLabelLeft = DeleteLabel()
        return deleteLabelLeft
    }()
    
    let deleteLabelRight: DeleteLabel = {
        let deleteLabelRight = DeleteLabel()
        return deleteLabelRight
    }()
    
    lazy var touchScreen: UIView = {
       let touchScreen = UIView()
       return touchScreen
    }()
    
    override func setupViews() {
        super.setupViews()
        
        backgroundColor = ColorConstants.appBackgroundColor // Color behind cell
        contentView.backgroundColor = ColorConstants.cellBackgroundColor
        
        contentView.addSubview(thumbnailImageView)
        contentView.addSubview(titleLabel)
        contentView.addSubview(dateLabel)
        contentView.addSubview(locationLabel)
        contentView.addSubview(storyLabel)
        contentView.addSubview(touchScreen)
        
        insertSubview(deleteLabelLeft, belowSubview: contentView)
        insertSubview(deleteLabelRight, belowSubview: contentView)
        
        pan = UIPanGestureRecognizer(target: self, action: #selector(onPan(_:)))
        pan.delegate = self
        addGestureRecognizer(pan)

        let smallSpacing: CGFloat = 8
        let labelHeigth = Constants.thumbNailSize / 3
        
        NSLayoutConstraint.activate([
            thumbnailImageView.topAnchor.constraint(equalTo: contentView.topAnchor, constant: Constants.contentPadding),
            thumbnailImageView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: Constants.contentPadding),
            thumbnailImageView.bottomAnchor.constraint(equalTo: contentView.topAnchor),
            thumbnailImageView.widthAnchor.constraint(equalToConstant: Constants.thumbNailSize),
            thumbnailImageView.heightAnchor.constraint(equalToConstant: Constants.thumbNailSize),
            
            titleLabel.topAnchor.constraint(equalTo: contentView.topAnchor, constant: Constants.contentPadding),
            titleLabel.leadingAnchor.constraint(equalTo: thumbnailImageView.trailingAnchor, constant: smallSpacing),
            titleLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -Constants.contentPadding),
            titleLabel.heightAnchor.constraint(equalToConstant: labelHeigth),
            
            dateLabel.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 0), //
            dateLabel.leadingAnchor.constraint(equalTo: thumbnailImageView.trailingAnchor, constant: smallSpacing),
            dateLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -Constants.contentPadding),
            dateLabel.heightAnchor.constraint(equalToConstant: labelHeigth),
            
            locationLabel.topAnchor.constraint(equalTo: dateLabel.bottomAnchor, constant: 0),
            locationLabel.leadingAnchor.constraint(equalTo: thumbnailImageView.trailingAnchor, constant: smallSpacing),
            locationLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -Constants.contentPadding),
            locationLabel.heightAnchor.constraint(equalToConstant: labelHeigth),
            
            storyLabel.topAnchor.constraint(equalTo: locationLabel.bottomAnchor, constant: smallSpacing),
            storyLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: Constants.contentPadding),
            storyLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -Constants.contentPadding),
            storyLabel.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -Constants.contentPadding)
        ])
        
        // Touchscreen ensures cell can only be interacted with as a whole and prevent triggering textView editing
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
