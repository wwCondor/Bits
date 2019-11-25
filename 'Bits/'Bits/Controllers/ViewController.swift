//
//  ViewController.swift
//  'Bits
//
//  Created by Wouter Willebrands on 09/10/2019.
//  Copyright © 2019 Studio Willebrands. All rights reserved.
//  

import UIKit
import CoreData

class ViewController: UIViewController {
    
    let newEntryController = NewEntryController()
    let managedObjectContext = AppDelegate().managedObjectContext
    let cellId = "cellId"
    
    lazy var fetchedResultsController: FetchedResultsController = {
        return FetchedResultsController(managedObjectContext: self.managedObjectContext, collectionView: self.savedEntries)
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = ColorConstants.appBackgroundColor // MARK: Set App background color
        
        setupViews()
        setupSortButton()
    }
    
    lazy var addButton: UIButton = {
        let addButton = UIButton(type: .custom)
        let image = UIImage(named: Icon.addIcon.image)?.withRenderingMode(.alwaysTemplate)
        addButton.setImage(image, for: .normal)
        addButton.contentMode = .center
        addButton.backgroundColor = ColorConstants.buttonMenuColor
        addButton.tintColor = ColorConstants.tintColor
        let inset: CGFloat = 15
        addButton.imageEdgeInsets = UIEdgeInsets(top: inset, left: inset, bottom: inset, right: inset)
        addButton.imageView?.contentMode = .scaleAspectFit
        addButton.addTarget(self, action: #selector(presentEntryController), for: .touchUpInside)
        addButton.translatesAutoresizingMaskIntoConstraints = false
        return addButton
    }()
    
    lazy var savedEntries: UICollectionView = {
        let layout: UICollectionViewFlowLayout = UICollectionViewFlowLayout()
        let savedEntries = UICollectionView(frame: view.frame, collectionViewLayout: layout)
        savedEntries.backgroundColor = UIColor.clear
        savedEntries.register(SavedEntryCell.self, forCellWithReuseIdentifier: cellId)
        savedEntries.dataSource = self
        savedEntries.delegate = self
        savedEntries.translatesAutoresizingMaskIntoConstraints = false
        return savedEntries
    }()
    
    lazy var sortButton: UIButton = {
        let sortButton = UIButton(type: .custom)
        let sortImage = UIImage(named: Icon.sortIcon.image)!.withRenderingMode(.alwaysTemplate)
        sortButton.setImage(sortImage, for: .normal)
        let inset: CGFloat = 5
        sortButton.imageEdgeInsets = UIEdgeInsets(top: inset, left: inset, bottom: inset + 10, right: inset)
        sortButton.frame = CGRect(x: 0, y: 0, width: sortImage.size.width, height: sortImage.size.height) // Actually not needed?
        sortButton.imageView?.contentMode = .scaleAspectFit
        sortButton.addTarget(self, action: #selector(sortEntries), for: .touchUpInside)
        return sortButton
    }()
    
    private func setupSortButton() {
        let barButton = UIBarButtonItem(customView: sortButton)
        self.navigationItem.rightBarButtonItem = barButton
    }
    
    private func setupViews() {
        view.addSubview(savedEntries)
        view.addSubview(addButton)
                
        NSLayoutConstraint.activate([
        savedEntries.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 0),
        savedEntries.widthAnchor.constraint(equalToConstant: view.bounds.width),
        savedEntries.bottomAnchor.constraint(equalTo: addButton.topAnchor),
        
        addButton.heightAnchor.constraint(equalToConstant: Constants.buttonBarHeight),
        addButton.widthAnchor.constraint(equalToConstant: view.bounds.width),
        addButton.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: 0),
        addButton.centerXAnchor.constraint(equalToSystemSpacingAfter: view.centerXAnchor, multiplier: 1)
        ])
    }
    
    // MARK: Present NewEntryController Method
    @objc func presentEntryController(sender: Any?) {
        newEntryController.managedObjectContext = self.managedObjectContext
        navigationController?.pushViewController(newEntryController, animated: true)
    }
    
    // MARK: TODO: Sort Method
    @objc func sortEntries(sender: UIBarButtonItem) {
        Alerts.presentAlert(description: EntryErrors.sortNotYetImplented.localizedDescription, viewController: self)
        // This method should sort the entries. Ideally switching between sortBy-states: e.g Title & Date
        print("Sorted!")
    }
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
        cell.storyLabel.text = entry.story
        return cell
    }
    
    // Sets up size of the cells
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: view.frame.width, height: Constants.cellHeight)
    }
    
    // Sets up spacing between posts
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 0
    }
    
    // Sets up what to do when a cell gets tapped
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let entry = fetchedResultsController.object(at: indexPath)
        let editEntryController = EditEntryController()
        editEntryController.managedObjectContext = self.managedObjectContext
        editEntryController.entry = entry
        
        navigationController?.pushViewController(editEntryController, animated: true)
    }
    
    // MARK: Delete Entry
    func collectionView(_ collectionView: UICollectionView, performAction action: Selector, forItemAt indexPath: IndexPath, withSender sender: Any?) {
        let entry = fetchedResultsController.object(at: indexPath)
        
        managedObjectContext.delete(entry)
        managedObjectContext.saveChanges()
        
        print("Deleted \(entry) at \(indexPath)")
    }
}


