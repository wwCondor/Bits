//
//  ViewController.swift
//  'Bits
//
//  Created by Wouter Willebrands on 09/10/2019.
//  Copyright © 2019 Studio Willebrands. All rights reserved.
//  

import UIKit
import CoreData
import CoreLocation

class ViewController: UIViewController, UISearchBarDelegate {
    
    let newEntryController = NewEntryController()
    let locationManager = LocationManager()
    let managedObjectContext = AppDelegate().managedObjectContext
    let cellId = "cellId"
    
    var searchBarIsPresented: Bool = false
    
    lazy var fetchedResultsController: FetchedResultsController = {
        return FetchedResultsController(managedObjectContext: self.managedObjectContext, collectionView: self.savedEntries)
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        searchBar.delegate = self
        
        view.backgroundColor = ColorConstants.appBackgroundColor
        
        setupViews()
        setupNavigationBarItems()
    }
    
    lazy var searchBarBackground: UIView = {
        let searchBarBackground = UIView()
        searchBarBackground.backgroundColor = ColorConstants.buttonMenuColor
        searchBarBackground.translatesAutoresizingMaskIntoConstraints = false
        return searchBarBackground
    }()
    
    lazy var searchBar: UISearchBar = {
        let searchBar = UISearchBar()
        searchBar.backgroundColor = ColorConstants.buttonMenuColor
        searchBar.isTranslucent = true
        searchBar.tintColor = ColorConstants.buttonMenuColor
        searchBar.placeholder = "Search Entries"
        searchBar.translatesAutoresizingMaskIntoConstraints = false
        return searchBar
    }()
    
    lazy var addButton: CustomButton = {
        let addButton = CustomButton(type: .custom)
        let image = UIImage(named: Icon.addIcon.image)?.withRenderingMode(.alwaysTemplate)
        addButton.setImage(image, for: .normal)
        let inset: CGFloat = 15
        addButton.imageEdgeInsets = UIEdgeInsets(top: inset, left: inset, bottom: inset, right: inset)
        addButton.addTarget(self, action: #selector(presentEntryController), for: .touchUpInside)
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
    
    lazy var sortButton: CustomButton = {
        let sortButton = CustomButton(type: .custom)
        let sortImage = UIImage(named: Icon.sortIcon.image)!.withRenderingMode(.alwaysTemplate)
        sortButton.setImage(sortImage, for: .normal)
        let inset: CGFloat = 7
        sortButton.imageEdgeInsets = UIEdgeInsets(top: inset, left: inset, bottom: inset + 8, right: inset + 30)
        sortButton.addTarget(self, action: #selector(sortEntries(sender:)), for: .touchUpInside)
        return sortButton
    }()
    
    lazy var searchButton: CustomButton = {
        let searchButton = CustomButton(type: .custom)
        let sortImage = UIImage(named: Icon.searchIcon.image)!.withRenderingMode(.alwaysTemplate)
        searchButton.setImage(sortImage, for: .normal)
        let inset: CGFloat = 5
        searchButton.imageEdgeInsets = UIEdgeInsets(top: inset, left: inset, bottom: inset + 10, right: inset + 40)
        searchButton.addTarget(self, action: #selector(searchEntries(sender:)), for: .touchUpInside)
        return searchButton
    }()
    
    private func setupNavigationBarItems() {
        self.navigationItem.setHidesBackButton(true, animated: true)
        let sortBarButton = UIBarButtonItem(customView: sortButton)
        let searchBarButton = UIBarButtonItem(customView: searchButton)
        self.navigationItem.leftBarButtonItem = sortBarButton
        self.navigationItem.rightBarButtonItem = searchBarButton
    }
    
    private func setupViews() {
        view.addSubview(savedEntries)
        view.addSubview(addButton)
        
        view.addSubview(searchBarBackground)
        view.addSubview(searchBar)
        
        let offset = Constants.buttonBarHeight / 4
                
        NSLayoutConstraint.activate([
            sortButton.widthAnchor.constraint(equalToConstant: view.bounds.width * (1/2)),
            searchButton.widthAnchor.constraint(equalToConstant: view.bounds.width * (1/2)),
            
            savedEntries.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            savedEntries.widthAnchor.constraint(equalToConstant: view.bounds.width),
            savedEntries.bottomAnchor.constraint(equalTo: addButton.topAnchor),
            
            addButton.heightAnchor.constraint(equalToConstant: Constants.buttonBarHeight),
            addButton.widthAnchor.constraint(equalToConstant: view.bounds.width),
            addButton.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor),
            
            searchBarBackground.widthAnchor.constraint(equalToConstant: view.bounds.width),
            searchBarBackground.heightAnchor.constraint(equalToConstant: Constants.buttonBarHeight),
            searchBarBackground.bottomAnchor.constraint(equalTo: savedEntries.topAnchor),
            
            searchBar.widthAnchor.constraint(equalToConstant: view.bounds.width * (3/4)),
            searchBar.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            searchBar.heightAnchor.constraint(equalToConstant: Constants.buttonBarHeight / 2),
            searchBar.bottomAnchor.constraint(equalTo: savedEntries.topAnchor, constant: -offset)
        ])
    }
    
    // MARK: Present NewEntryController Method
    @objc func presentEntryController(sender: Any?) {
        newEntryController.managedObjectContext = self.managedObjectContext
        newEntryController.resetLabels()
        navigationController?.pushViewController(newEntryController, animated: true)
    }
    
    // MARK: TODO: Sort Method
    @objc func sortEntries(sender: UIBarButtonItem) {
        Alerts.presentAlert(description: EntryErrors.sortNotYetImplented.localizedDescription, viewController: self)
        // This method should sort the entries. Ideally switching between sortBy-states: e.g Title & Date
        print("Sorted!")
    }
    
    @objc func searchEntries(sender: UIBarButtonItem) {
        if searchBarIsPresented == false {
            searchBarIsPresented = true
            presentSearchBar()
        } else if searchBarIsPresented == true {
            searchBarIsPresented = false
            hideSearchBar()
        }
    }
    
    func presentSearchBar() {
        UIView.animate(
            withDuration: 0.3,
            delay: 0,
            options: .curveEaseIn,
            animations: {
                self.searchBarBackground.center.y += Constants.buttonBarHeight
                self.searchBar.center.y += Constants.buttonBarHeight
                self.savedEntries.center.y += Constants.buttonBarHeight
        },
            completion: { _ in
                print("Animation completed")
        })
    }
    
    func hideSearchBar() {
        UIView.animate(
            withDuration: 0.3,
            delay: 0,
            options: .curveEaseIn,
            animations: {
                self.searchBarBackground.center.y -= Constants.buttonBarHeight
                self.searchBar.center.y -= Constants.buttonBarHeight
                self.savedEntries.center.y -= Constants.buttonBarHeight
        },
            completion: { _ in
                print("Animation completed")
        })
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
        cell.dateLabel.text = entry.date
        cell.storyLabel.text = entry.story
        cell.locationLabel.text = entry.location
        let thumbImageData = UIImage(named: Icon.bitsThumb.image)!.pngData()
        cell.thumbnailImageView.image = UIImage(data: entry.imageData ?? thumbImageData!)
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



