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

class ViewController: UIViewController {
    
    let searchController = UISearchController(searchResultsController: nil)
    let newEntryController = NewEntryController()
    let locationManager = LocationManager()
    let managedObjectContext = AppDelegate().managedObjectContext
    let cellId = "cellId"
    
    var searchBarIsPresented: Bool = false
    var isSearching: Bool = false
    var filteredEntries = [Entry]()
    var entries = [Entry]()
    
    var isSearchBarEmpty: Bool {
        return searchController.searchBar.text?.isEmpty ?? true
    }
    
    lazy var fetchedResultsController: FetchedResultsController = {
        return FetchedResultsController(managedObjectContext: self.managedObjectContext, collectionView: self.savedEntries)
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        


        
        view.backgroundColor = ColorConstants.appBackgroundColor
        
        let fetchRequest = NSFetchRequest<Entry>(entityName: "Entry")
        
        do {
            entries = try managedObjectContext.fetch(fetchRequest)
        } catch let error as NSError {
            print(error.userInfo)
        }
        
        setupViews()
//        setupSearchBar()
        setupNavigationBarItems()
    }
    
//    func setupSearchBar() {
//
//        searchController.searchResultsUpdater = self
//        searchController.obscuresBackgroundDuringPresentation = true
//        searchController.searchBar.barTintColor = UIColor.blue
//        searchController.searchBar.backgroundColor = ColorConstants.buttonMenuColor
//        searchController.searchBar.placeholder = "Search Entries"
//        searchController.searchBar.isHidden = false
//        navigationItem.searchController = searchController
//        definesPresentationContext = true
//
////        searchBar.delegate = self
//    }
    
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
        searchBar.tintColor = ColorConstants.appBackgroundColor // sets color of vertical bar
        let textFieldInsideSearchBar = searchBar.value(forKey: "searchField") as? UITextField
        textFieldInsideSearchBar?.textColor = ColorConstants.tintColor // sets text color
        searchBar.placeholder = "Search Entries"
        searchBar.keyboardAppearance = .dark
        searchBar.delegate = self
//        searchBar.barTintColor = ColorConstants.tintColor // search bar input background color
        searchBar.scopeBarBackgroundImage = .none
        searchBar.returnKeyType = UIReturnKeyType.done
        searchBar.layer.cornerRadius = Constants.thumbnailCornerRadius
        searchBar.layer.masksToBounds = true
        searchBar.backgroundImage = UIImage() // removes
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
        if searchBarIsPresented == true {
            hideSearchBar()
        }
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
            presentSearchBar()
        } else if searchBarIsPresented == true {
            hideSearchBar()
        }
    }
    
    func presentSearchBar() {
        searchBarIsPresented = true
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
        searchBarIsPresented = false
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
        
//        return section.numberOfObjects
        
        if isSearching == true {
            return filteredEntries.count
        } else {
            return section.numberOfObjects
        }
    }
    
    // Sets up cell content
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let entry: Entry
        
        if isSearching == true {
            entry = filteredEntries[indexPath.row]
        } else {
            entry = fetchedResultsController.object(at: indexPath)
        }
        
        
        let cell = savedEntries.dequeueReusableCell(withReuseIdentifier: cellId, for: indexPath) as! SavedEntryCell
//        let entry = fetchedResultsController.object(at: indexPath)
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
        if searchBarIsPresented == true {
            hideSearchBar()
        }
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

    // MARK: SearchBarDelegate
extension ViewController: UISearchBarDelegate {//}, UISearchResultsUpdating {
//    func updateSearchResults(for searchController: UISearchController) {
//        let searchBar = searchController.searchBar
//        filterContentForSearchText(searchBar.text!)
//    }
//
//    func filterContentForSearchText(_ searchText: String) {
//        filteredEntries = entries.filter({ (entry: Entry) -> Bool in
//            return entry.title.lowercased().contains(searchText.lowercased()) || entry.story.lowercased().contains(searchText.lowercased())
//        })
//        savedEntries.reloadData()
//    }
    
    
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        if searchText == "" {
            isSearching = false
            view.endEditing(true)
            savedEntries.reloadData()
        } else {
            isSearching = false
//            searchEntries = entries.filter({$0.range(of: searchText, options: .caseInsensitive) != nil})
            filteredEntries = entries.filter({ (entry: Entry) -> Bool in
                return entry.title.lowercased().contains(searchText.lowercased()) || entry.story.lowercased().contains(searchText.lowercased())
            })
            savedEntries.reloadData()

                //(of: searchBar.text!, options: .caseInsensitive) != nil})
        }
    }
}



