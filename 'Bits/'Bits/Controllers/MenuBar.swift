//
//  MenuBarController.swift
//  'Bits
//
//  Created by Wouter Willebrands on 09/10/2019.
//  Copyright © 2019 Studio Willebrands. All rights reserved.
//

import UIKit


class MenuBar: UIView, UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout {
    
    // collectionView that will hold all the buttons
    lazy var collectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collectionView.backgroundColor = UIColor(named: "GentlemanGray") // color of the container holding the cells
        collectionView.dataSource = self
        collectionView.delegate = self
        return collectionView
    }()
    
    let cellId = "cellId"
    let menuBarImageNames = ["SortIcon", "AddIcon", "ShareIcon"] // Array that holds the icon stringnames
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
//        backgroundColor = UIColor(named: "WashedWhite") // if we see this it means collectionView is not convering the UIView container
        
        // Registers a custom class cell for use in creating new collection view cells.
        collectionView.register(MenuCell.self, forCellWithReuseIdentifier: cellId)

        // Adds the collectioinView to the subView
        addSubview(collectionView)

        // Constraints setup 
        addConstraintsWithFormat("H:|[v0]|", views: collectionView)
        addConstraintsWithFormat("V:|[v0]|", views: collectionView)
        
        // This ensures there is always an intial icon in selected state when app is launched.
        // Currently set to addIcon as default to draw attention to user when app is opened. User opened app so it's likely they want to add a post
        let selectedIndexPath = IndexPath(item: 1, section: 0)
        collectionView.selectItem(at: selectedIndexPath, animated: false, scrollPosition: [])
        

        
    }
    

    // MARK: Delegate Methods
    
    // This is the amount of buttons inside the collectionView
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 3
    }


    // Returns a reusable cell object located by its identifier
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: cellId, for: indexPath) as! MenuCell
        
        cell.imageView.image = UIImage(named: menuBarImageNames[indexPath.item])?.withRenderingMode(.alwaysTemplate) // This uses the images from the array for each button
        cell.tintColor = UIColor(named: "SuitUpSilver") // This renders a layer over the icon's original color

//        cell.backgroundColor = UIColor(named: "WashedWhite") // color of the cells within the container

        return cell
    }

    // This set the size of the cells
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        // Since we have 3 cells the width of each cell is the screenwidth divided by 3
        // We want the cell to fill the collectionView, so height = frame.height
        return CGSize(width: frame.width / 3 , height: frame.height)
    }

    // This sets the spacing between the buttons
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 0
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    

}


// MARK: Fixme: Refactor to superclass inheritance
class MenuCell: UICollectionViewCell {
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupViews()
        //        backgroundColor = UIColor(named: "WashedWhite")
    }
    
    let imageView: UIImageView = {
        let imageView = UIImageView()
//        imageView.backgroundColor = UIColor(named: "GentlemanGray")
        imageView.image = UIImage(named: "AddIcon")?.withRenderingMode(.alwaysTemplate)
//        imageView.tintColor = UIColor(named: "CufflinkCream")
        return imageView
    }()
    
    override var isSelected: Bool {
        didSet {
            imageView.tintColor = isSelected ? UIColor(named: "WashedWhite") : UIColor(named: "SuitUpSilver")
        }
    }
    
    override var isHighlighted: Bool {
        didSet {
            imageView.tintColor = isHighlighted ? UIColor(named: "WashedWhite") : UIColor(named: "SuitUpSilver")
        }
    }
    

    func setupViews() {
        //        backgroundColor = UIColor.blue
        addSubview(imageView)
        
        // This sets te size of the icon inside the cell
        let imageViewIconSquareSide = bounds.height * (3/7) // Since it is a square we can set them both up here at the same time
        imageView.translatesAutoresizingMaskIntoConstraints = false // enabels autoLayout for menuBar
        imageView.heightAnchor.constraint(equalToConstant: imageViewIconSquareSide) .isActive = true
        imageView.widthAnchor.constraint(equalToConstant: imageViewIconSquareSide).isActive = true
        
        // This centers the icon inside the cell
        addConstraint(NSLayoutConstraint(item: imageView, attribute: .centerX, relatedBy: .equal, toItem: self, attribute: .centerX, multiplier: 1, constant: 0))
        addConstraint(NSLayoutConstraint(item: imageView, attribute: .centerY, relatedBy: .equal, toItem: self, attribute: .centerY, multiplier: 1, constant: 0))
        //        addConstraintsWithFormat("H:[v0(28)]", views: imageView)
        //        addConstraintsWithFormat("V:[v0(28)]", views: imageView)
        
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
}






// MARK: Constraints Method
extension UIView {
    
    // This method allows us to easily set constraints
    func addConstraintsWithFormat(_ format: String, views: UIView...) {
        var viewsDictionary = [String: UIView]()

        for (index, view) in views.enumerated() {
            let key = "v\(index)"
            view.translatesAutoresizingMaskIntoConstraints = false
            viewsDictionary[key] = view
        }

       addConstraints(NSLayoutConstraint.constraints(withVisualFormat: format, options: NSLayoutConstraint.FormatOptions(rawValue: 0), metrics: nil, views: viewsDictionary))
    }
}

//// MARK: Bottom SafeArae View
//// This is only to cover the bottom safeArea with a view in order to make it have color
//class BottomView: UIView {
//
//
//}
