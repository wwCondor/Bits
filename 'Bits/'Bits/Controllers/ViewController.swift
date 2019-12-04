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
    
//    var searchBarIsPresented: Bool = false
    var isSearching: Bool = false
    var filteredEntries = [Entry]()
    var entries = [Entry]()
    
    var sortMode: SortMode = .titleAscending
        
    var isSearchBarEmpty: Bool {
        return searchController.searchBar.text?.isEmpty ?? true
    }
    
    lazy var fetchedResultsController: FetchedResultsController = {
        return FetchedResultsController(managedObjectContext: self.managedObjectContext, collectionView: self.savedEntries)
    }()
    
//    override func viewWillAppear(_ animated: Bool) {
//        super.viewWillAppear(false)
//
//    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
                
//        filteredEntries = entries // they start with equal content

        view.backgroundColor = ColorConstants.appBackgroundColor

        reloadEntries()
        addOberser()
        setupViews()
        setupSearchBar()
        setupNavigationBarItems()
    }
    
    func addOberser() {
        NotificationCenter.default.addObserver(self, selector: #selector(updateEntries(notification:)), name: updateEntriesNotification, object: nil)
    }
    
    @objc private func updateEntries(notification: NSNotification) {
        reloadEntries()
    }
//    func fetchStoredEntries() {
//        let fetchRequest = NSFetchRequest<Entry>(entityName: "Entry")
//
//        do {
//            entries = try managedObjectContext.fetch(fetchRequest)
//        } catch let error as NSError {
//            print(error.userInfo)
//        }
//        filteredEntries = entries
//    }
    
    func reloadEntries() {
        let fetchRequest = NSFetchRequest<Entry>(entityName: "Entry")
        
        do {
            filteredEntries = try managedObjectContext.fetch(fetchRequest)
        } catch let error as NSError {
            print(error.userInfo)
        }
        sortTitlesInAscendingOrder()
//        sortByTitle()
//        filteredEntries = entries
//        filteredEntries = entries
        savedEntries.reloadData()
    }
    
    func searchBarIsEmpty() -> Bool {
        return searchController.isActive == true && !searchController.searchBar.text!.isEmpty == true
    }
    
    func setupSearchBar() {
        searchController.delegate = self
        searchController.searchBar.delegate = self
        searchController.searchResultsUpdater = self
        searchController.obscuresBackgroundDuringPresentation = false
//        searchController.isActive = true
//        searchController.searchBar.isTranslucent = true
//        searchController.searchBar.barTintColor = UIColor.blue
//        searchController.searchBar.backgroundColor = ColorConstants.buttonMenuColor
        searchController.searchBar.isHidden = false // default
        searchController.searchBar.returnKeyType = UIReturnKeyType.done
        
        searchController.searchBar.searchTextField.backgroundColor = ColorConstants.tintColor // searchField background color
        searchController.searchBar.searchTextField.textColor = UIColor.blue //ColorConstants.buttonMenuColor
        searchController.searchBar.searchTextField.clearButtonMode = .never // hides 'x' button inside searchField when not editing
        
//        let textFieldInsideSearchBar = searchController.searchBar.value(forKey: "searchField") as? UITextField
//
//        textFieldInsideSearchBar?.textColor = ColorConstants.tintColor
//        let textFieldInsideSearchBar = searchBar.value(forKey: "searchField") as? UITextField
//        let glassIconView = textFieldInsideSearchBar!.leftView as? UIImageView
//        glassIconView?.image = glassIconView!.image?.withRenderingMode(.alwaysTemplate)
//        glassIconView!.tintColor = ColorConstants.tintColor
//        let textFieldInsideSearchBar = searchController.searchBar.value(forKey: "searchField") as? UITextField
//        textFieldInsideSearchBar?.textColor = ColorConstants.tintColor // sets text color
        navigationItem.hidesSearchBarWhenScrolling = true
        navigationItem.searchController = searchController
        definesPresentationContext = false // default
    }
    
//    lazy var searchBarContainer: UIView = {
//        let searchBarContainer = UIView()
//        searchBarContainer.backgroundColor = ColorConstants.buttonMenuColor
//        searchBarContainer.translatesAutoresizingMaskIntoConstraints = false
//        return searchBarContainer
//    }()

//    lazy var searchBar: UISearchBar = {
//        let searchBar = UISearchBar()
//        searchBar.backgroundColor = ColorConstants.buttonMenuColor
//        searchBar.isTranslucent = true
//        searchBar.tintColor = ColorConstants.appBackgroundColor // sets color of vertical bar
//        let textFieldInsideSearchBar = searchBar.value(forKey: "searchField") as? UITextField
//        textFieldInsideSearchBar?.textColor = ColorConstants.tintColor // sets text color
//        let glassIconView = textFieldInsideSearchBar!.leftView as? UIImageView
//        glassIconView?.image = glassIconView!.image?.withRenderingMode(.alwaysTemplate)
//        glassIconView!.tintColor = ColorConstants.tintColor // sets color of searchIcon inside searchbar
//        searchBar.placeholder = "Search Entries"
//        searchBar.keyboardAppearance = .dark
////        searchBar.delegate = self
////        searchBar.barTintColor = ColorConstants.tintColor // search bar input background color
////        searchBar.scopeBarBackgroundImage = .none
//        searchBar.returnKeyType = UIReturnKeyType.done
//        searchBar.layer.cornerRadius = Constants.thumbnailCornerRadius
//        searchBar.layer.masksToBounds = true
//        searchBar.backgroundImage = UIImage() // removes weird shade inside
//        searchBar.translatesAutoresizingMaskIntoConstraints = false
//        return searchBar
//    }()
    
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
//        let inset: CGFloat = 7 // when paired with searchbutton
//        sortButton.imageEdgeInsets = UIEdgeInsets(top: inset, left: inset, bottom: inset + 8, right: inset + 30) // when paired with searchbutton
        let inset: CGFloat = 5
        sortButton.imageEdgeInsets = UIEdgeInsets(top: inset, left: inset, bottom: inset + 10, right: inset)
        sortButton.addTarget(self, action: #selector(sortEntries(sender:)), for: .touchUpInside)
        return sortButton
    }()
    
//    lazy var searchButton: CustomButton = {
//        let searchButton = CustomButton(type: .custom)
//        let sortImage = UIImage(named: Icon.searchIcon.image)!.withRenderingMode(.alwaysTemplate)
//        searchButton.setImage(sortImage, for: .normal)
//        let inset: CGFloat = 5
//        searchButton.imageEdgeInsets = UIEdgeInsets(top: inset, left: inset, bottom: inset + 10, right: inset + 40)
//        searchButton.addTarget(self, action: #selector(searchEntries(sender:)), for: .touchUpInside)
//        return searchButton
//    }()
    
    private func setupNavigationBarItems() {
        self.navigationItem.setHidesBackButton(true, animated: true)
        let sortBarButton = UIBarButtonItem(customView: sortButton)
//        let searchBarButton = UIBarButtonItem(customView: searchButton)
        self.navigationItem.leftBarButtonItem = sortBarButton
//        self.navigationItem.rightBarButtonItem = searchBarButton
    }
    
    private func setupViews() {
        view.addSubview(savedEntries)
        view.addSubview(addButton)
        
        
//        view.addSubview(searchBarContainer)
//        view.addSubview(searchBar)
        
//        let offset = Constants.buttonBarHeight / 4
                
        NSLayoutConstraint.activate([
//            sortButton.widthAnchor.constraint(equalToConstant: view.bounds.width * (1/2)),
//            searchButton.widthAnchor.constraint(equalToConstant: view.bounds.width * (1/2)),
            
            savedEntries.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            savedEntries.widthAnchor.constraint(equalToConstant: view.bounds.width),
            savedEntries.bottomAnchor.constraint(equalTo: addButton.topAnchor),
            
            addButton.heightAnchor.constraint(equalToConstant: Constants.buttonBarHeight),
            addButton.widthAnchor.constraint(equalToConstant: view.bounds.width),
            addButton.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor),
            
//            searchBarContainer.widthAnchor.constraint(equalToConstant: view.bounds.width),
//            searchBarContainer.heightAnchor.constraint(equalToConstant: Constants.buttonBarHeight),
//            searchBarContainer.bottomAnchor.constraint(equalTo: savedEntries.topAnchor),

//            searchBar.widthAnchor.constraint(equalToConstant: view.bounds.width * (3/4)),
//            searchBar.centerXAnchor.constraint(equalTo: view.centerXAnchor),
//            searchBar.heightAnchor.constraint(equalToConstant: Constants.buttonBarHeight / 2),
//            searchBar.bottomAnchor.constraint(equalTo: savedEntries.topAnchor, constant: -offset)
        ])
    }
    
    // MARK: Present NewEntryController Method
    @objc func presentEntryController(sender: Any?) {
//        if searchBarIsPresented == true {
//            hideSearchBar()
//        }
        newEntryController.managedObjectContext = self.managedObjectContext
        newEntryController.resetLabels()
        navigationController?.pushViewController(newEntryController, animated: true)
    }
    
    // MARK: TODO: Sort Method
    @objc private func sortEntries(sender: UIBarButtonItem) {
        reverseSortOrder()
//        presentAlert(description: EntryErrors.sortNotYetImplented.localizedDescription, viewController: self)
        // This method should sort the entries. Ideally switching between sortBy-states: e.g Title & Date
    }
    
    private func reverseSortOrder() {
        if sortMode == .titleAscending {
            sortTitlesInDecendingOrder()
            sortMode = .titleDescending
        } else if sortMode == .titleDescending {
            sortTitlesInAscendingOrder()
            sortMode = .titleAscending
        }
        print(sortMode)
        savedEntries.reloadData()
    }
    
    private func sortTitlesInAscendingOrder() {
        filteredEntries.sort(by: { $0.title.lowercased() < $1.title.lowercased() })
    }
    
    private func sortTitlesInDecendingOrder() {
        filteredEntries.sort(by: { $0.title.lowercased() > $1.title.lowercased() })
    }
    
    @objc func searchEntries(sender: UIBarButtonItem) {
        print("Search")
//        if searchBarIsPresented == false {
//            presentSearchBar()
//        } else if searchBarIsPresented == true {
//            hideSearchBar()
//        }
    }
    
    deinit {
        NotificationCenter.default.removeObserver(self)
    }
    
//    func presentSearchBar() {
//        searchBarIsPresented = true
//        UIView.animate(
//            withDuration: 0.3,
//            delay: 0,
//            options: .curveEaseIn,
//            animations: {
//                self.searchBarContainer.center.y += Constants.buttonBarHeight
////                self.searchBar.center.y += Constants.buttonBarHeight
//                self.savedEntries.center.y += Constants.buttonBarHeight
//        },
//            completion: { _ in
//                print("Animation completed")
//        })
//    }
//
//    func hideSearchBar() {
//        searchBarIsPresented = false
//        UIView.animate(
//            withDuration: 0.3,
//            delay: 0,
//            options: .curveEaseIn,
//            animations: {
//                self.searchBarContainer.center.y -= Constants.buttonBarHeight
////                self.searchBar.center.y -= Constants.buttonBarHeight
//                self.savedEntries.center.y -= Constants.buttonBarHeight
//        },
//            completion: { _ in
//                print("Animation completed")
//        })
//    }
}

// MARK: CollectionView Delegate Methods
extension ViewController: UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout {
    
    // Sets the amount of cells
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
//        var cellCount: Int  = 0
//
//        guard let section = fetchedResultsController.sections?[section] else {
//            return 0
//        }
//
//        if isSearching == false {
//            // If searching is false all entries all presented
//            cellCount = section.numberOfObjects
//        } else if isSearching == true {
//            if isSearchBarEmpty == true {
//                // Is searching is true, but searchbar is empty all entries are presented
//                cellCount = section.numberOfObjects
//            } else if isSearchBarEmpty == false {
//                // If searching is true and
//                cellCount = filteredEntries.count
//            }
//        }
//        return cellCount

        return filteredEntries.count
    }
    
    // Sets up cell content
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
//        let entry: Entry
        let entry = filteredEntries[indexPath.row]
//        if isSearching == false || searchBarIsEmpty() == true { //&& searchBarIsEmpty() == false {
//            entry = fetchedResultsController.object(at: indexPath)
//        } else {
//            entry = filteredEntries[indexPath.row]
//        }
        
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
//        if searchBarIsPresented == true {
//            hideSearchBar()
//        }
//        let entry: Entry
//        if isSearching == false || searchBarIsEmpty() == true { //&& searchBarIsEmpty() == false {
//            entry = fetchedResultsController.object(at: indexPath)
//        } else {
//            entry = filteredEntries[indexPath.row]
//        }
//        if isSearching == true {
//            entry = filteredEntries[indexPath.row]
//        } else {
//            entry = fetchedResultsController.object(at: indexPath)
//        }
        let entry = filteredEntries[indexPath.row]
//
//        let entry = fetchedResultsController.object(at: indexPath)
        let editEntryController = EditEntryController()
        editEntryController.managedObjectContext = self.managedObjectContext
        editEntryController.entry = entry
        
        navigationController?.pushViewController(editEntryController, animated: true)

        searchController.searchBar.text = ""
        reloadEntries()
    }
    
    // MARK: Delete Entry
    func collectionView(_ collectionView: UICollectionView, performAction action: Selector, forItemAt indexPath: IndexPath, withSender sender: Any?) {
        
//        let entry: Entry
//        if isSearching == false || searchBarIsEmpty() == true { //&& searchBarIsEmpty() == false {
//            entry = fetchedResultsController.object(at: indexPath)
//        } else {
//            entry = filteredEntries[indexPath.row]
//        }

        
        let entry = filteredEntries[indexPath.row]
//        let entry = fetchedResultsController.object(at: indexPath)
        
        managedObjectContext.delete(entry)
        managedObjectContext.saveChanges()
        
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

extension ViewController: UISearchBarDelegate {
    
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        if let searchText = searchBar.text, !searchText.isEmpty {
            reloadEntries()
        }
    }
    
    func searchBarTextDidBeginEditing(_ searchBar: UISearchBar) {
        print("User is Searching")
        isSearching = true
    }
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        if searchText == "" {
            reloadEntries()
        } else {
            savedEntries.reloadData()
        }
        
    }
    
    func searchBarTextDidEndEditing(_ searchBar: UISearchBar) {
        print("User finished Searching")
        isSearching = false
        reloadEntries()
//        savedEntries.reloadData()
//        resetFilter()
    }
    
    
}

extension ViewController: UISearchControllerDelegate {
    func filterContentForSearchText(_ searchText: String) {
        if searchText.count > 0 {
            reloadEntries() // reload
            
            let entriesFiltered = filteredEntries.filter { (entry: Entry) -> Bool in
                return entry.title.replacingOccurrences(of: " ", with: "").lowercased().contains(searchText.lowercased()) //.replacingOccurrences(of: " ", with: "").lowercased())
            }
            filteredEntries = entriesFiltered
            savedEntries.reloadData()
        } else if searchText.count == 0 {
            reloadEntries()
        }
//        filteredEntries = entries.filter({ (entry: Entry) -> Bool in
//            return entry.title.lowercased().contains(searchText.lowercased()) || entry.story.lowercased().contains(searchText.lowercased())
//        })
//        savedEntries.reloadData()
        
    }
}
    
    
    
//    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
//        if searchText == "" {
//            isSearching = false
//            view.endEditing(true)
//            savedEntries.reloadData()
//        } else {
//            isSearching = false
////            searchEntries = entries.filter({$0.range(of: searchText, options: .caseInsensitive) != nil})
//            filteredEntries = entries.filter({ (entry: Entry) -> Bool in
//                return entry.title.lowercased().contains(searchText.lowercased()) || entry.story.lowercased().contains(searchText.lowercased())
//            })
//            savedEntries.reloadData()
//
//                //(of: searchBar.text!, options: .caseInsensitive) != nil})
//        }
//    }
//}



