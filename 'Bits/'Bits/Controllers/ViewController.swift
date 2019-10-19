//
//  ViewController.swift
//  'Bits
//
//  Created by Wouter Willebrands on 09/10/2019.
//  Copyright © 2019 Studio Willebrands. All rights reserved.
//  https://icons8.com - Icon
//

import UIKit
import CoreData


class ViewController: UIViewController {

    
    let newEntryController = NewEntryController()
    let managedObjectContext = AppDelegate().managedObjectContext
    
    // Empty array of entries with a didSet observer
    // If a new value is added the collectionview will be reloaded automatically
//    public var entries = [Entry]() {
//        didSet {
//            savedEntries.reloadData()
//        }
//    }
    
    let cellId = "cellId"
    
    lazy var fetchedResultsController: FetchedResultsController = {
        return FetchedResultsController(managedObjectContext: self.managedObjectContext, collectionView: self.savedEntries)
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = UIColor.blue // MARK: Set App background color
        
        setupViews()
        setupSortButton()
        
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
        addButton.addTarget(self, action: #selector(presentEntryController), for: .touchUpInside)
        return addButton
    }()
    
    lazy var savedEntries: UICollectionView = {
        let layout: UICollectionViewFlowLayout = UICollectionViewFlowLayout()
        let savedEntries = UICollectionView(frame: self.view.frame, collectionViewLayout: layout)
        savedEntries.backgroundColor = UIColor.blue
        savedEntries.register(SavedEntryCell.self, forCellWithReuseIdentifier: cellId)
        savedEntries.dataSource = self
        savedEntries.delegate = self
        return savedEntries
    }()
    
    lazy var sortButton: UIButton = {
        let sortButton = UIButton(type: .custom)
        let sortImage = UIImage(named: Icon.sortIcon.rawValue)!.withRenderingMode(.alwaysTemplate)
        sortButton.setImage(sortImage, for: .normal)
        let inset: CGFloat = 5
        sortButton.imageEdgeInsets = UIEdgeInsets(top: inset, left: inset, bottom: inset + 10, right: inset)
        sortButton.frame = CGRect(x: 0, y: 0, width: sortImage.size.width, height: sortImage.size.height) // Actually not needed?
        sortButton.imageView?.contentMode = .scaleAspectFit
        sortButton.addTarget(self, action: #selector(sortEntries), for: .touchUpInside)
        return sortButton
    }()
    
    
//    let bottomView: BottomView = {
//        let bottomView = BottomView()
//        return bottomView
//    }()
    
    private func setupSortButton() {
        let barButton = UIBarButtonItem(customView: sortButton)
        self.navigationItem.rightBarButtonItem = barButton
    }
    
    private func setupViews() {

        view.addSubview(savedEntries)
        view.addSubview(addButton)

        savedEntries.translatesAutoresizingMaskIntoConstraints = false // enabels autoLayout for menuBar
        savedEntries.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 0).isActive = true
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

// MARK: CollectionView Delegate Methods
extension ViewController: UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout {
    
        // Sets the amount of cells
        func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {

            guard let section = fetchedResultsController.sections?[section] else {
                return 0
            }
            return section.numberOfObjects
            
        }

        // Sets up cell content
        func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
            let cell = savedEntries.dequeueReusableCell(withReuseIdentifier: cellId, for: indexPath) as! SavedEntryCell
            
            let entry = fetchedResultsController.object(at: indexPath)
            
            cell.titleLabel.text = entry.title
            
//            cell.backgroundColor = UIColor.systemRed
            
            return cell
        }
        
        // Sets up size of the cells
        func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
            let spacing: CGFloat = 16
            return CGSize(width: view.frame.width - (2 * spacing), height: 90)
        }
        
        // Sets up spacing between posts
        func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
            return 0
        }
        
        
        // Sets up what to do when a cell gets tapped
        func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
            
            let entry = fetchedResultsController.object(at: indexPath)
            
            newEntryController.entryTitle.text = entry.title // "Title: \(indexPath)"
            newEntryController.entryContent.text = entry.story // "\(indexPath) story of selected Entry"
            
            navigationController?.pushViewController(newEntryController, animated: true)
            
    //        //        cellTapDelegate.launchEntryWithIndex(index: indexPath)
        }
    
        // MARK: Delete Entry
        func collectionView(_ collectionView: UICollectionView, performAction action: Selector, forItemAt indexPath: IndexPath, withSender sender: Any?) {
            
            let entry = fetchedResultsController.object(at: indexPath)
            managedObjectContext.delete(entry)
            managedObjectContext.saveChanges()
            
            print("Deleted \(entry) at \(indexPath)")
            // In here we delete stuff when
        }
    
}



// MARK: Add and Sort Methods
extension ViewController {
    
    
    // MARK: Present NewEntryController Method
    @objc func presentEntryController(sender: Any?) {
        
        newEntryController.managedObjectContext = self.managedObjectContext

        navigationController?.pushViewController(newEntryController, animated: true)
    }
    
    // MARK: Sort Method
    @objc func sortEntries(sender: UIBarButtonItem) {
        // This method should sort the entries. Ideally switching between 2 "sortBy"-states: Title & Date


        print("Sorted!")
    }
}


