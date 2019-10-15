//
//  SortOptions.swift
//  'Bits
//
//  Created by Wouter Willebrands on 13/10/2019.
//  Copyright © 2019 Studio Willebrands. All rights reserved.
//

import UIKit


class SortOptionsBar: UIView, UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout {
    
    // collectionView that will hold all the buttons
    lazy var collectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collectionView.backgroundColor = UIColor.systemPink // MARK: Set SortOptionsBar Color
        collectionView.dataSource = self
        collectionView.delegate = self
        return collectionView
    }()
    
    let cellId = "cellId"
    let menuBarImageNames = ["SortIcon", "AddIcon"] // Array that holds the icon stringnames

    
    override init(frame: CGRect) {
        super.init(frame: frame)
                
        // Registers a custom class cell for use in creating new collection view cells.
        collectionView.register(SortOptionsCell.self, forCellWithReuseIdentifier: cellId)

        // Adds the collectioinView to the subView
        addSubview(collectionView)

        // Constraints setup
        addConstraintsWithFormat("H:|[v0]|", views: collectionView)
        addConstraintsWithFormat("V:|[v0]|", views: collectionView)
        
        collectionView.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(tap)))
        
//        // This ensures there is always an intial icon in selected state when app is launched.
//        // Currently set to addIcon as default to draw attention to user when app is opened. User opened app so it's likely they want to add a post
//        let selectedIndexPath = IndexPath(item: 1, section: 0)
//        collectionView.selectItem(at: selectedIndexPath, animated: false, scrollPosition: [])
        
 
    }
    

    // MARK: Delegate Methods
    
    // This is the amount of buttons inside the collectionView
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 2
    }


    // Returns a reusable cell object located by its identifier
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: cellId, for: indexPath) as! SortOptionsCell
        
        cell.imageView.image = UIImage(named: menuBarImageNames[indexPath.item])?.withRenderingMode(.alwaysTemplate) // This uses the images from the array for each

        return cell
    }

    // This sets the size of the menubar cells that contain the buttons
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        // Since we have 3 cells the width of each cell is the screenwidth divided by 3
        // We want the cell to fill the collectionView, so height = frame.height
        return CGSize(width: frame.width / 2 , height: frame.height)
    }

    // This sets the spacing between the buttons, if spacing > 0, cells will be move to new row
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 0
    }
    

    @objc func tap(sender: UITapGestureRecognizer) {
        if let indexPath = self.collectionView.indexPathForItem(at: sender.location(in: self.collectionView)) {
            
            // MARK: Sort/Add/Share Methods should be called in here
            if indexPath.item == 0 {

                print("Sort option 1")
            } else if indexPath.item == 1 {

                print("Sort option 2")
            }
         }
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    

}


// MARK: MenuBarCell
// Since it very closely related to the MenuBar it is inside the MenuBar file
class SortOptionsCell: BaseCell {
    
    let imageView: UIImageView = {
        let imageView = UIImageView()
        imageView.image = UIImage(named: "AddIcon")?.withRenderingMode(.alwaysTemplate)
        imageView.tintColor = UIColor(named: "WashedWhite") // MARK: Set Button Icon Color
        return imageView
    }()
    
    override func setupViews() {
        super.setupViews()
        //        backgroundColor = UIColor.blue
        addSubview(imageView)
        
        // This sets te size of the icon inside the cell
        let imageViewIconSquareSide = bounds.height * (3/7) // Since it is a square we can set them both up here at the same time
        imageView.translatesAutoresizingMaskIntoConstraints = false // enabels autoLayout for menuBar
        imageView.heightAnchor.constraint(equalToConstant: imageViewIconSquareSide).isActive = true
        imageView.widthAnchor.constraint(equalToConstant: imageViewIconSquareSide).isActive = true
        
        // This centers the icon inside the cell
        addConstraint(NSLayoutConstraint(item: imageView, attribute: .centerX, relatedBy: .equal, toItem: self, attribute: .centerX, multiplier: 1, constant: 0))
        addConstraint(NSLayoutConstraint(item: imageView, attribute: .centerY, relatedBy: .equal, toItem: self, attribute: .centerY, multiplier: 1, constant: 0))
        
        
    }
    
    
}
