//
//  SavedPostsView.swift
//  'Bits
//
//  Created by Wouter Willebrands on 09/10/2019.
//  Copyright © 2019 Studio Willebrands. All rights reserved.
//

import UIKit

class SavedPostsView: UIView, UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout {
    
    lazy var collectedBitsView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        let collectedBitsView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        
//        collectedBitsView.backgroundColor = UIColor(named: "SuitUpSilver") // MARK: Set color behind entries
        collectedBitsView.backgroundColor = UIColor.clear // MARK: Set color behind entries

//        collectedBitsView.backgroundColor = UIColor.white // Testcolor

        collectedBitsView.dataSource = self
        collectedBitsView.delegate = self
        return collectedBitsView
    }()
    
    let cellId = "cellId"
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        // Register BitsCell object for use in creating new cells
        collectedBitsView.register(SavedPostCell.self, forCellWithReuseIdentifier: cellId)
        
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
//        cell.layer.cornerRadius = 6
//        cell.layer.masksToBounds = true
        
        return cell
    }
    
    // This set the size of the cells
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: frame.width * (11/12), height: 90)
    }
    
    // This sets the spacing between the posts
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 0
    }
    
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    

    
}


