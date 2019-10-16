//
//  SavedEntries.swift
//  'Bits
//
//  Created by Wouter Willebrands on 09/10/2019.
//  Copyright © 2019 Studio Willebrands. All rights reserved.
//

import UIKit


class SavedEntries: UIView, UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout {
    
    let newEntryController = NewEntryController()
    let mainController = ViewController()
    let entryCell = SavedEntryCell()
    
    lazy var collectedBitsView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        let collectedBitsView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collectedBitsView.backgroundColor = UIColor.clear // MARK: Set color behind entries
        collectedBitsView.dataSource = self
        collectedBitsView.delegate = self
        return collectedBitsView
    }()
    
    let cellId = "cellId"
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        // Register BitsCell object for use in creating new cells
        collectedBitsView.register(SavedEntryCell.self, forCellWithReuseIdentifier: cellId)
        
        // Adds the collectionView to the subView
        addSubview(collectedBitsView)
        
        // Constraints setup
        addConstraintsWithFormat("H:|[v0]|", views: collectedBitsView)
        addConstraintsWithFormat("V:|[v0]|", views: collectedBitsView)
        
    }
    
    
    // MARK: Delegate Methods
    // This is the amount of cells inside the collectionView
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 10
//        return mainController.entries.count // MARK: Amount of Entries
    }
    

    // Returns a reusable cell object located by its identifier
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: cellId, for: indexPath)
        
//        let entry = mainController.entries[indexPath.row]
//        entryCell.titleLabel.text = entry.title
        
        cell.backgroundColor = UIColor(named: "WashedWhite") // color of the cells within the container
//        cell.layer.cornerRadius = 6
//        cell.layer.masksToBounds = true
        
        return cell
    }
    
    // This set the size of the cells
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let spacing: CGFloat = 16
        return CGSize(width: frame.width - (2 * spacing), height: 90)
    }
    
    // This sets the spacing between the posts
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 0
    }
    
    
    // MARK: Delegate (Needs work)
    var cellTapDelegate: CellTapDelegate!
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        // In here we launch newEntryController
//        cellTapDelegate.launchEntryWithIndex(index: indexPath)
        
        print(indexPath)
    }
    
    
    @objc func gesture(sender: UITapGestureRecognizer) {
        let point = sender.location(in: collectedBitsView)
        if let indexPath = collectedBitsView.indexPathForItem(at: point) {
            print(#function, indexPath)
        }
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
}

extension SavedEntries: UIGestureRecognizerDelegate {
    
    func gestureRecognizer(_ gestureRecognizer: UIGestureRecognizer, shouldReceive touch: UITouch) -> Bool {
        let point = touch.location(in: collectedBitsView)
        if let indexPath = collectedBitsView.indexPathForItem(at: point),
            let cell = collectedBitsView.cellForItem(at: indexPath) {
            print(indexPath, point)
            return touch.location(in: cell).y > 50
        }
        
        return false
    }

}

protocol CellTapDelegate {
    func launchEntryWithIndex(index: IndexPath)
}


