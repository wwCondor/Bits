//
//  NewEntryLauncher.swift
//  'Bits
//
//  Created by Wouter Willebrands on 11/10/2019.
//  Copyright © 2019 Studio Willebrands. All rights reserved.
//

import UIKit

class NewEntryLauncher: NSObject, UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout {
    
    var menuItemSelected: MenuOptions? // This holds the selected option in the menu

    let dimmedView = UIView() // This is the view that will be used to dim the background
    
    let collectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        
//        collectionView.backgroundColor = UIColor(named:"SuitUpSilver") // MARK: Set background color of slider
        
        return collectionView
        
    }()
    
    let cellId = "cellID"
    
//    let backgroundDimmer = BackgroundDimmer()
    
    func showNewEntryView() {
//        backgroundDimmer.dimBackground()
        let window = UIApplication.shared.windows.first { $0.isKeyWindow } // this handles the deprecated warning...
        
        if let window = window { // }= UIApplication.shared.keyWindow { //...caused by this line of code
            
            dimmedView.backgroundColor = UIColor(white: 0, alpha: 0.5)
            dimmedView.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(dismissNewPostView)))
            
            window.addSubview(dimmedView)
            window.addSubview(collectionView)
            
            collectionView.frame = CGRect(x: 0, y: window.frame.height * (1/2), width: window.frame.width, height: window.frame.height / 2)
            
            guard let selection = menuItemSelected else { return }
            
            switch selection {
            case .sortEntry:
                collectionView.frame = CGRect(x: 0, y: window.frame.height * (3/4), width: window.frame.width, height: window.frame.height)
                collectionView.backgroundColor = UIColor.green

            case .newEntry:
                collectionView.frame = CGRect(x: 0, y: window.frame.height * (1/2), width: window.frame.width, height: window.frame.height / 2)
                collectionView.backgroundColor = UIColor.black
            case .shareEntry:
                collectionView.frame = CGRect(x: 0, y: window.frame.height * (3/4), width: window.frame.width, height: window.frame.height)
                collectionView.backgroundColor = UIColor.yellow
            }
            
            collectionView.frame = CGRect(x: 0, y: window.frame.height / 2, width: window.frame.width, height: window.frame.height / 2)
            collectionView.center.y += window.bounds.height // This view starts outside the window.bounds and is animated in
            
            dimmedView.frame = window.frame
            dimmedView.alpha = 0
            
            // This anmites the view
            UIView.animate(withDuration: 0.8,
                           delay: 0.0,
                           options: [.curveEaseOut],
                           animations: {
                            self.collectionView.center.y -= window.bounds.height
                            self.dimmedView.alpha = 1
            },
                           completion: nil)
            
        }
        
    }
    
    @objc func dismissNewPostView() {
//        backgroundDimmer.dismissDimmedView()
        UIView.animate(withDuration: 0.5) {
            self.dimmedView.alpha = 0
            
            let window = UIApplication.shared.windows.first { $0.isKeyWindow }
            
            if let window = window {
                self.collectionView.frame = CGRect(x: 0, y: window.frame.height, width: self.collectionView.frame.width, height: self.collectionView.frame.height)
            }
            
        }
        

    }
    
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        
        return 1
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: cellId, for: indexPath) as! MenuItemCell
        return cell
    }
    
    // This sets the size of the cells
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        // Since we have 3 cells the width of each cell is the screenwidth divided by 3
        // We want the cell to fill the collectionView, so height = frame.height
        return CGSize(width: collectionView.frame.width, height: collectionView.frame.height * (9/10))
    }
    

    override init() {
        super.init()
        
        collectionView.dataSource = self
        collectionView.delegate = self
        
        collectionView.register(MenuItemCell.self, forCellWithReuseIdentifier: cellId)
        
    }
    
}
