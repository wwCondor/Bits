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
    let managedObjectContext = (UIApplication.shared.delegate as! AppDelegate).managedObjectContext
    
    let updateEntriesNotification = Notification.Name(rawValue: NotificationKey.updateEntriesNotificationKey)
    
    let cellId = "cellId"
//    let request: NSFetchRequest = Entry.fetchRequest()
    
//    var isSearching: Bool = false
//    var filteredEntries = [Entry]()
//
    var sortMode: SortMode = .titleAscending
        
//    var isSearchBarEmpty: Bool {
//        return searchController.searchBar.text?.isEmpty ?? true
//    }
    
    lazy var fetchedResultsController: FetchedResultsController = {
        return FetchedResultsController(managedObjectContext: self.managedObjectContext, collectionView: self.savedEntries, request: Entry.fetchRequest())
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
                
        fetchedResultsController.delegate = self

        view.backgroundColor = ColorConstants.appBackgroundColor
//        UISearchBar.appearance().backgroundColor = ColorConstants.buttonMenuColor
//        UINavigationBar.appearance().backgroundColor = ColorConstants.buttonMenuColor

        reloadEntries()
        addOberser()
        setupViews()
        setupSearchBar()
        setupNavigationBarItems()
    }
    
    private func addOberser() {
        NotificationCenter.default.addObserver(self, selector: #selector(updateEntries(notification:)), name: updateEntriesNotification, object: nil)
    }
    

    
    private func searchBarIsEmpty() -> Bool {
        return searchController.isActive == true && !searchController.searchBar.text!.isEmpty == true
    }
    
    private func setupSearchBar() {
        searchController.delegate = self
        searchController.searchBar.delegate = self
        searchController.searchResultsUpdater = self
        searchController.obscuresBackgroundDuringPresentation = false
        searchController.extendedLayoutIncludesOpaqueBars = false
        searchController.searchBar.isHidden = false // default
        searchController.searchBar.keyboardAppearance = .dark
        searchController.searchBar.returnKeyType = UIReturnKeyType.done
        searchController.searchBar.searchTextField.backgroundColor = ColorConstants.tintColor // searchField background color
        searchController.searchBar.searchTextField.textColor = UIColor.blue // MARK: Does not Work
        searchController.searchBar.searchTextField.clearButtonMode = .never // hides 'x' button inside searchField when not editing
        navigationItem.hidesSearchBarWhenScrolling = true
        navigationItem.searchController = searchController
        definesPresentationContext = false // default
    }
    
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
        let sortImage = UIImage(named: Icon.ascendingIcon.image)!.withRenderingMode(.alwaysTemplate)
        sortButton.setImage(sortImage, for: .normal)
        let inset: CGFloat = 5
        sortButton.imageEdgeInsets = UIEdgeInsets(top: inset, left: inset, bottom: inset + 10, right: inset)
        sortButton.addTarget(self, action: #selector(sortEntries(sender:)), for: .touchUpInside)
        return sortButton
    }()
    
    private func setupNavigationBarItems() {
        self.navigationItem.setHidesBackButton(true, animated: true)
        let sortBarButton = UIBarButtonItem(customView: sortButton)
        self.navigationItem.leftBarButtonItem = sortBarButton
    }
    
    private func setupViews() {
        view.addSubview(savedEntries)
        view.addSubview(addButton)
                
        NSLayoutConstraint.activate([
            savedEntries.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            savedEntries.widthAnchor.constraint(equalToConstant: view.bounds.width),
            savedEntries.bottomAnchor.constraint(equalTo: addButton.topAnchor),
            
            addButton.heightAnchor.constraint(equalToConstant: Constants.buttonBarHeight),
            addButton.widthAnchor.constraint(equalToConstant: view.bounds.width),
            addButton.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor),
        ])
    }
    
    // MARK: Present NewEntryController
    @objc func presentEntryController(sender: Any?) {
        newEntryController.managedObjectContext = self.managedObjectContext
        newEntryController.resetLabels()
        navigationController?.pushViewController(newEntryController, animated: true)
    }
    
    // MARK: Sort
    @objc private func sortEntries(sender: UIBarButtonItem) {
        reverseSortOrder()
    }
    
    @objc private func updateEntries(notification: NSNotification) {
//        fetchedResultsController = FetchedResultsController(managedObjectContext: self.managedObjectContext, collectionView: self.savedEntries, request: Entry.fetchRequest())
//        savedEntries.reloadData()
        reloadEntries()
    }
    
    private func reloadEntries() {
        if sortMode == .titleAscending {
            sortTitlesInAscendingOrder()
        } else if sortMode == .titleDescending {
            sortTitlesInDecendingOrder()
        }
        savedEntries.reloadData()
    }
    
    private func reverseSortOrder() {
        if sortMode == .titleAscending {
            sortButton.setImage(UIImage(named: Icon.descendingIcon.image)!.withRenderingMode(.alwaysTemplate), for: .normal)
            sortTitlesInDecendingOrder()
            sortMode = .titleDescending
        } else if sortMode == .titleDescending {
            sortButton.setImage(UIImage(named: Icon.ascendingIcon.image)!.withRenderingMode(.alwaysTemplate), for: .normal)
            sortTitlesInAscendingOrder()
            sortMode = .titleAscending
        }
        print(sortMode)
        savedEntries.reloadData()
    }
    
    private func sortTitlesInAscendingOrder() {
        let sortRequest = NSFetchRequest<Entry>(entityName: "Entry")
        sortRequest.sortDescriptors = [NSSortDescriptor(key: "title", ascending: true, selector: #selector(NSString.caseInsensitiveCompare(_:)))]
        fetchedResultsController = FetchedResultsController(managedObjectContext: self.managedObjectContext, collectionView: self.savedEntries, request: sortRequest)
    }
    
    private func sortTitlesInDecendingOrder() {
        let sortRequest = NSFetchRequest<Entry>(entityName: "Entry")
        sortRequest.sortDescriptors = [NSSortDescriptor(key: "title", ascending: false, selector: #selector(NSString.caseInsensitiveCompare(_:)))]
        fetchedResultsController = FetchedResultsController(managedObjectContext: self.managedObjectContext, collectionView: self.savedEntries, request: sortRequest)
    }

    deinit {
        NotificationCenter.default.removeObserver(self)
    }
}

    // MARK: CollectionViewDelegates
extension ViewController: UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout {
    
    // Sets the amount of cells
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        guard let section = fetchedResultsController.sections?[section] else {
            return 0
        }
        
        return section.numberOfObjects
//        return filteredEntries.count
    }
    
    // Sets up cell content
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let entry = fetchedResultsController.object(at: indexPath)
//        let entry = filteredEntries[indexPath.row]
        let cell = savedEntries.dequeueReusableCell(withReuseIdentifier: cellId, for: indexPath) as! SavedEntryCell
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
//        let entry = filteredEntries[indexPath.row]
        let editEntryController = EditEntryController()
        editEntryController.managedObjectContext = self.managedObjectContext
        editEntryController.entry = entry
        
        navigationController?.pushViewController(editEntryController, animated: true)

        searchController.searchBar.text = ""
        reloadEntries()
    }
    
    // MARK: Delete Entry
    func collectionView(_ collectionView: UICollectionView, performAction action: Selector, forItemAt indexPath: IndexPath, withSender sender: Any?) {
        let entry = fetchedResultsController.object(at: indexPath)
//        let entry = filteredEntries[indexPath.row]
//        managedObjectContext?.delete(entry)
//        managedObjectContext?.saveChanges()
        entry.managedObjectContext?.delete(entry)
        entry.managedObjectContext?.saveChanges()
        reloadEntries()
        print("Deleted \(entry) at \(indexPath)")
    }
}

    // MARK: SearchBarDelegate
extension ViewController: UISearchResultsUpdating {
    func updateSearchResults(for searchController: UISearchController) {
        
        if let searchText = searchController.searchBar.text {
            filterContentForSearchText(searchText)
        }
    }
}

    // MARK: UISearchBarDelegate
extension ViewController: UISearchBarDelegate {
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        if let searchText = searchBar.text, !searchText.isEmpty {
            reloadEntries()
        }
    }
    
    func searchBarTextDidBeginEditing(_ searchBar: UISearchBar) {
        print("User is Searching")
//        isSearching = true
    }
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        filterContentForSearchText(searchText)
//        if searchText == "" {
//            fetchedResultsController.fetchRequest.predicate = NSPredicate(format: "title CONTAINS[c] %@", searchText)
////            reloadEntries()
//        } else {
//            savedEntries.reloadData()
//        }
    }
    
    func searchBarTextDidEndEditing(_ searchBar: UISearchBar) {
        print("User finished Searching")
//        isSearching = false
        savedEntries.reloadData()

//        reloadEntries()
    }
}

    // MARK: UISearchControllerDelegate
extension ViewController: UISearchControllerDelegate {
    func filterContentForSearchText(_ searchText: String) {
        let searchRequest = NSFetchRequest<Entry>(entityName: "Entry")
        let predicate = NSPredicate(format: "title contains[c] %@", searchText)
        searchRequest.sortDescriptors = [NSSortDescriptor(key: "title", ascending: true, selector: #selector(NSString.caseInsensitiveCompare(_:)))]
        searchRequest.predicate = predicate
        
        if searchText.count == 0 || searchText.trimmingCharacters(in: .whitespaces).isEmpty {
            //            let request = NSFetchRequest<Entry>(entityName: "Entry")
            fetchedResultsController = FetchedResultsController(managedObjectContext: self.managedObjectContext, collectionView: self.savedEntries, request: Entry.fetchRequest())
            //            reloadEntries()
        } else {
            
            fetchedResultsController = FetchedResultsController(managedObjectContext: self.managedObjectContext, collectionView: self.savedEntries, request: searchRequest)

//            reloadEntries() // reload
//
//            let entriesFiltered = filteredEntries.filter { (entry: Entry) -> Bool in
//                return entry.title.replacingOccurrences(of: " ", with: "").lowercased().contains(searchText.lowercased())
            }
//            filteredEntries = entriesFiltered
//        } else if searchText.count == 0 {
////            let request = NSFetchRequest<Entry>(entityName: "Entry")
//            fetchedResultsController = FetchedResultsController(managedObjectContext: self.managedObjectContext, collectionView: self.savedEntries, request: Entry.fetchRequest())
////            reloadEntries()
//        }
        DispatchQueue.main.async {
            self.savedEntries.reloadData()
        }
    }
}

extension ViewController: NSFetchedResultsControllerDelegate {
    func controller(_ controller: NSFetchedResultsController<NSFetchRequestResult>, didChange anObject: Any, at indexPath: IndexPath?, for type: NSFetchedResultsChangeType, newIndexPath: IndexPath?) {
        switch type {
        case .insert:
            guard let newIndexPath = newIndexPath else { return }
            savedEntries.performBatchUpdates({
                savedEntries.insertItems(at: [newIndexPath])
            }, completion: {
                (finished: Bool) in
                self.savedEntries.reloadItems(at: self.savedEntries.indexPathsForVisibleItems)
            })
        case .delete:
            guard let indexPath  = indexPath else { return }
            savedEntries.performBatchUpdates({
                savedEntries.deleteItems(at: [indexPath])
            }, completion: {
                (finished: Bool) in
                self.savedEntries.reloadItems(at: self.savedEntries.indexPathsForVisibleItems)
            })
        case .update, .move:
            guard let indexPath = indexPath else { return }
            savedEntries.performBatchUpdates({
                savedEntries.reloadItems(at: [indexPath])
            }, completion: {
                (finished: Bool) in
                self.savedEntries.reloadItems(at: self.savedEntries.indexPathsForVisibleItems)
            }) // Not adding this seems to cause glitches switching between edit en new entry mode
        @unknown default:
            return
        }
    }
}




