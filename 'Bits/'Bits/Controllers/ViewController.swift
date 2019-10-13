//
//  ViewController.swift
//  'Bits
//
//  Created by Wouter Willebrands on 09/10/2019.
//  Copyright © 2019 Studio Willebrands. All rights reserved.
//

import UIKit


class ViewController: UIViewController {
    

    override func viewDidLoad() {
        super.viewDidLoad()
        
//        view.backgroundColor = UIColor(named: "CufflinkCream")
        view.backgroundColor = UIColor.blue // MARK: Set App background color
        
        setupViews()
//        setupSafeAreaView()
        

        // This makes sure the collectionView holding the posts not go underneath the menuBar
//         collectionView?.contentInset = UIEdgeInsetMake(0, 0, 0, 0)
        // This make sure the scollBar does not go underneath the menuBar
//         collectionView?.scrollIndicatorInsets = UIEdgeInsesMake(0, 0, 0, 0)
        
    }
    

    
    let savedPostsview: SavedPostsView = {
        let savedPostsview = SavedPostsView()
        return savedPostsview
    }()
    
    let menuBar: MenuBar = {
        let menuBar = MenuBar()
        return menuBar
    }()
    
//    let bottomView: BottomView = {
//        let bottomView = BottomView()
//        return bottomView
//    }()
    
    private func setupViews() {
        // To the view we add the collectedBitsView as a subView
        view.addSubview(savedPostsview)
        view.addSubview(menuBar)

        
        // MARK: Fixme - Set constraint for both so savedPostsView.bottom aligns with menuBar.top
        // This sets up the collectedBitsView
        savedPostsview.translatesAutoresizingMaskIntoConstraints = false // enabels autoLayout for menuBar
        savedPostsview.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 0).isActive = true
//        savedPostsview.heightAnchor.constraint(equalToConstant: view.bounds.height * (7/9)).isActive = true // Heigth of the collectedBitsView
        savedPostsview.widthAnchor.constraint(equalToConstant: view.bounds.width).isActive = true
//        collectedBitsView.backgroundColor = UIColor(named: "WashedWhite") // Only here for testing


//
//
        menuBar.translatesAutoresizingMaskIntoConstraints = false // enabels autoLayout for menuBar
        menuBar.topAnchor.constraint(equalTo: savedPostsview.bottomAnchor).isActive = true
        menuBar.heightAnchor.constraint(equalToConstant: view.bounds.height * (1/9)).isActive = true // Height of the menuBar
        menuBar.widthAnchor.constraint(equalToConstant: view.bounds.width).isActive = true
////        menuBar.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
//        //        menuBar.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: 0).isActive = true
//
//        // This sets bottom equal to safeArea, since we don't want the buttons to overlap with safe area
        menuBar.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: 0).isActive = true

    }
    
    private func setupMenuBar() {
        // To the view we add the menuBar as a subView
        view.addSubview(menuBar)
        
        // This sets up the menuBar

        
    }
    
//    private func setupSafeAreaView() {
//        view.addSubview(bottomView)
//
//        bottomView.translatesAutoresizingMaskIntoConstraints = false // enabels autoLayout
//        bottomView.widthAnchor.constraint(equalToConstant: view.bounds.width).isActive = true
//        bottomView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor).isActive = true
//        bottomView.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: 0).isActive = true
//        bottomView.backgroundColor = UIColor(named: "CufflinkCream")
//
//    }
    

    



}

