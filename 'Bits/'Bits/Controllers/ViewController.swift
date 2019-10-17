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
//    let managedObjectContext = AppDelegate().managedObjectContainer
    
    // Empty array of entries with a didSet observer
    // If a new value is added the collectionview will be reloaded
//    public var entries = [Entry]() {
//        didSet {
//            savedEntries.collectedBitsView.reloadData()
//        }
//    }
    
    let cellId = "cellId"
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = UIColor.blue // MARK: Set App background color
        
        setupViews()
        setupSortButton()
        

        
//        let request: NSFetchRequest<Entry> = Entry.fetchRequest()
//
//
//        do {
//            entries = try managedObjectContext.fetch(request)
//        } catch {
//            print("Error fetching Item objects: \(error.localizedDescription)")
//        }


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
        savedEntries.backgroundColor = UIColor.systemYellow
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

extension ViewController: UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout { // }: CellTapDelegate {
    

    
    func launchEntryWithIndex(index: IndexPath) {
        self.navigationController?.pushViewController(newEntryController, animated: true)
    }
    
    // MARK: CollectionView Delegate Methods
    // Set as entries.count
    // This sets the amount of cells inse the collectionView
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 12
    }
    
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = savedEntries.dequeueReusableCell(withReuseIdentifier: cellId, for: indexPath)
        
        cell.backgroundColor = UIColor.systemRed
        
        return cell
    }
    
        // This set the size of the cells
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let spacing: CGFloat = 16
        return CGSize(width: view.frame.width - (2 * spacing), height: 90)
    }
    
        // This sets the spacing between the posts
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 0
    }
    
    // In here we do something when a cell has been tapped
    // We launch the newEntryController
    // We populate the newEntryController with data from the cell that was tapped
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
        newEntryController.entryTitle.text = "\(indexPath) titel of selected Entry"
        newEntryController.entryContent.text = "\(indexPath) story of selected Entry"
        navigationController?.pushViewController(newEntryController, animated: true)
        
//        //        cellTapDelegate.launchEntryWithIndex(index: indexPath)
    }
    
//    func showEntryController(for indexPath: IndexPath) {
//        newEntryController.entryTitle.text = "\(indexPath) titel of selected Entry"
//        newEntryController.entryContent.text = "\(indexPath) story of selected Entry"
//        navigationController?.pushViewController(newEntryController, animated: true)
//    }
    
    @objc func presentEntryController(sender: Any?) {

        navigationController?.pushViewController(newEntryController, animated: true)
    }
    
    // MARK: Sort
    @objc func sortEntries(sender: UIBarButtonItem) {
        // This method should sort the entries. Ideally switching between 2 "sortBy"-states: Title & Date
        print("Sorted!")
    }


    
}




