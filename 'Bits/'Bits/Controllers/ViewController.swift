//
//  ViewController.swift
//  'Bits
//
//  Created by Wouter Willebrands on 09/10/2019.
//  Copyright © 2019 Studio Willebrands. All rights reserved.
//

import UIKit


class ViewController: UIViewController {
    
    let newEntryController = NewEntryController()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = UIColor.blue // MARK: Set App background color
        
        setupViews()
        setupSortButton()
        
        // This makes sure the collectionView holding the posts not go underneath the menuBar
//         collectionView?.contentInset = UIEdgeInsetMake(0, 0, 0, 0)
        // This make sure the scollBar does not go underneath the menuBar
//         collectionView?.scrollIndicatorInsets = UIEdgeInsesMake(0, 0, 0, 0)
        
    }
    
    
    lazy var addButton: UIButton = {
        let addButton = UIButton(type: .custom)
        let image = UIImage(named: Icon.addIcon.rawValue)?.withRenderingMode(.alwaysTemplate)
        addButton.setImage(image, for: .normal)
        addButton.contentMode = .center
        addButton.backgroundColor = UIColor(named: Color.gentlemanGray.rawValue)
        addButton.tintColor = UIColor(named: Color.washedWhite.rawValue)
        let inset: CGFloat = 15
        addButton.imageEdgeInsets = UIEdgeInsets(top: inset, left: inset, bottom: inset, right: inset)
        addButton.imageView?.contentMode = .scaleAspectFit
        addButton.addTarget(self, action: #selector(presentController), for: .touchUpInside)
        return addButton
    }()

    lazy var savedEntries: SavedEntries = {
        let savedEntries = SavedEntries()
        return savedEntries
    }()
    
    lazy var menuBar: MenuBar = {
        let menuBar = MenuBar()
        return menuBar
    }()
    
    
//    let bottomView: BottomView = {
//        let bottomView = BottomView()
//        return bottomView
//    }()
    
    private func setupSortButton() {
        // Turn this into an image instead
        let sortBarButton = UIBarButtonItem(title: "Sort", style: .plain, target: self, action: #selector(sortEntries))
        self.navigationItem.rightBarButtonItem = sortBarButton
        
    }
    
//    lazy var navigatonBarImage: UIImage = {
//        let navBarImage = UIImage(named: Icon.sortIcon.rawValue)!.withRenderingMode(.alwaysTemplate)
//        return navBarImage
//    }()

    
    private func setupViews() {

        view.addSubview(savedEntries)
        view.addSubview(addButton)

        savedEntries.translatesAutoresizingMaskIntoConstraints = false // enabels autoLayout for menuBar
        savedEntries.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 0).isActive = true
//        savedPostsview.heightAnchor.constraint(equalToConstant: view.bounds.height * (7/9)).isActive = true // Heigth of the collectedBitsView
        savedEntries.widthAnchor.constraint(equalToConstant: view.bounds.width).isActive = true
        
        addButton.translatesAutoresizingMaskIntoConstraints = false // enabels autoLayout for menuBar
        addButton.topAnchor.constraint(equalTo: savedEntries.bottomAnchor).isActive = true
        addButton.heightAnchor.constraint(equalToConstant: 60).isActive = true // Height of the menuBar
        addButton.widthAnchor.constraint(equalToConstant: view.bounds.width).isActive = true
        addButton.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: 0).isActive = true
        addButton.centerXAnchor.constraint(equalToSystemSpacingAfter: view.centerXAnchor, multiplier: 1).isActive = true

    }
    
    // This can be used to cover the bottom safe area
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

extension ViewController {
    
    @objc func presentController(sender: UIButton!) {
        self.navigationController?.pushViewController(newEntryController, animated: true)
    }
    
    @objc func sortEntries(sender: UIBarButtonItem) {
        // This method should sort the entries. Ideally switching between 2 "sortBy"-states: Title & Date
        print("Sorted!")
    }
}

