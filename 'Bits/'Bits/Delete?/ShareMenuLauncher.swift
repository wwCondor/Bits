////
////  ShareMenuLauncher.swift
////  'Bits
////
////  Created by Wouter Willebrands on 13/10/2019.
////  Copyright © 2019 Studio Willebrands. All rights reserved.
////
//
//import UIKit
//
//
//class ShareMenuLauncher: NSObject, UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout {
//    
//    let dimmedView = UIView() // This is the view that will be used to dim the background
//    
//    let shareCollectionView: UICollectionView = {
//        let layout = UICollectionViewFlowLayout()
//        let sortCollectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
//        sortCollectionView.backgroundColor = UIColor.yellow
//        return sortCollectionView
//        
//    }()
//    
//    
//    let cellId = "cellID"
//    
//    func showShareMenu() {
//        let window = UIApplication.shared.windows.first { $0.isKeyWindow }
//        
//        if let window = window {
//            
//            dimmedView.backgroundColor = UIColor(white: 0, alpha: 0.5)
//            dimmedView.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(dismissMenu)))
//            
//            window.addSubview(dimmedView)
//            window.addSubview(shareCollectionView)
//            
////            let height = window.safeAreaLayoutGuide.topAnchor - window.safeAreaLayoutGuide.bottomAnchor
//            
//            shareCollectionView.translatesAutoresizingMaskIntoConstraints = false // enabels autoLayout for menuBar
//            shareCollectionView.heightAnchor.constraint(equalToConstant: window.bounds.height * (1/6)).isActive = true // Height of the menuBar
//            shareCollectionView.widthAnchor.constraint(equalToConstant: window.bounds.width).isActive = true
//
//            shareCollectionView.bottomAnchor.constraint(equalTo: window.bottomAnchor, constant: 0).isActive = true
//            
////            collectionView.frame = CGRect(x: 0, y: window.frame.height, width: window.frame.width, height: window.frame.height / 8)
//            shareCollectionView.center.x += window.bounds.height // This view starts left outside the window.bounds and is animated in
//            
//            dimmedView.frame = window.frame
//            dimmedView.alpha = 0
//            
//            // This anmites the view
//            UIView.animate(withDuration: 0.8,
//                           delay: 0.0,
//                           options: [.curveEaseOut],
//                           animations: {
//                            self.shareCollectionView.center.x -= window.bounds.height
//                            self.dimmedView.alpha = 1
//            },
//                           completion: nil)
//            
//        }
//        
//    }
//    
//    @objc func dismissMenu() {
//
//        UIView.animate(withDuration: 0.8,
//                       delay: 0.0,
//                       options: [.curveEaseOut],
//                       animations: {
//                        let window = UIApplication.shared.windows.first { $0.isKeyWindow }
//                        
//                        if let window = window {
//                            self.shareCollectionView.center.x += window.bounds.width
//                        }
//                        
//                        self.dimmedView.alpha = 0
//        },
//                       completion: nil)
//        
//
//    }
//    
//    
//    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
//        
//        return 2
//    }
//
//    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
//        
//        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: cellId, for: indexPath)
//        return cell
//    }
//    
////    // This sets the size of the cells
////    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
////        return CGSize(width: collectionView.frame.width / 3, height: collectionView.frame.height)
////    }
//    
//
//    override init() {
//        super.init()
//        
//        shareCollectionView.dataSource = self
//        shareCollectionView.delegate = self
//        
//        shareCollectionView.register(ShareOptionCell.self, forCellWithReuseIdentifier: cellId)
//        
//    }
//    
//}
//
//
//class ShareOptionCell: BaseCell {
//    
//    let imageView: UIImageView = {
//        let imageView = UIImageView()
//        imageView.backgroundColor = UIColor.blue
////        imageView.image = UIImage(named: "AddIcon")?.withRenderingMode(.alwaysTemplate)
////        imageView.tintColor = UIColor(named: "WashedWhite") // MARK: Set Button Icon Color
//        return imageView
//    }()
// 
//    override func setupViews() {
//        super.setupViews()
//        //        backgroundColor = UIColor.blue
//        addSubview(imageView)
//        
//        // This sets te size of the icon inside the cell
////        let imageViewIconSquareSide = bounds.height * (3/7) // Since it is a square we can set them both up here at the same time
////        imageView.translatesAutoresizingMaskIntoConstraints = false // enabels autoLayout for menuBar
////        imageView.heightAnchor.constraint(equalToConstant: imageViewIconSquareSide).isActive = true
////        imageView.widthAnchor.constraint(equalToConstant: imageViewIconSquareSide).isActive = true
////
////        // This centers the icon inside the cell
////        addConstraint(NSLayoutConstraint(item: imageView, attribute: .centerX, relatedBy: .equal, toItem: self, attribute: .centerX, multiplier: 1, constant: 0))
////        addConstraint(NSLayoutConstraint(item: imageView, attribute: .centerY, relatedBy: .equal, toItem: self, attribute: .centerY, multiplier: 1, constant: 0))
//        
//        
//    }
//    
//    
//}
