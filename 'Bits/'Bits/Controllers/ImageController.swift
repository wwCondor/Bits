//
//  ImageController.swift
//  'Bits
//
//  Created by Wouter Willebrands on 26/11/2019.
//  Copyright © 2019 Studio Willebrands. All rights reserved.
//

import UIKit
import CoreData

class ImageController: UIViewController {
    
    var managedObjectContext: NSManagedObjectContext!
    let cellId = "cellId"
    
    override func viewDidLoad() {
        super.viewDidLoad()

        view.backgroundColor = ColorConstants.appBackgroundColor
        
        setupNavigationBarItems()
        setupViews()
    }
    
    lazy var imageContainerView: UIView = {
        let imageContainerView = UIView()
        imageContainerView.backgroundColor = ColorConstants.entryObjectBackground
        imageContainerView.translatesAutoresizingMaskIntoConstraints = false
        return imageContainerView
    }()

    // MARK: Nested in Container
    lazy var imageView: UIImageView = {
        let imageView = UIImageView()
        imageView.image = UIImage(named: Icon.bitsThumb.image) // Sets default image
        imageView.backgroundColor = ColorConstants.labelColor
        imageView.layer.cornerRadius = Constants.imageCornerRadius
        imageView.layer.masksToBounds = true
        imageView.translatesAutoresizingMaskIntoConstraints = false
//        let tapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(presentImageController(tapGestureRecognizer:)))
//        imageView.addGestureRecognizer(tapGestureRecognizer)
//        imageView.isUserInteractionEnabled = true
        return imageView
    }()
    
    lazy var imageCollection: UICollectionView = {
        let layout: UICollectionViewFlowLayout = UICollectionViewFlowLayout()
        let imageCollection = UICollectionView(frame: view.frame, collectionViewLayout: layout)
        imageCollection.backgroundColor = ColorConstants.labelColor
        imageCollection.register(ImageCell.self, forCellWithReuseIdentifier: cellId)
        imageCollection.dataSource = self
        imageCollection.delegate = self
        imageCollection.translatesAutoresizingMaskIntoConstraints = false
        return imageCollection
    }()
    
    lazy var saveButton: CustomButton = {
        let saveButton = CustomButton(type: .custom)
        let image = UIImage(named: Icon.saveIcon.image)?.withRenderingMode(.alwaysTemplate)
        saveButton.setImage(image, for: .normal)
        let inset: CGFloat = 10
        saveButton.imageEdgeInsets = UIEdgeInsets(top: inset, left: inset, bottom: inset, right: inset)
        saveButton.addTarget(self, action: #selector(saveImage(sender:)), for: .touchUpInside)
        return saveButton
    }()
    
    private func setupNavigationBarItems() {
        let navigatonBarImage = UIImage(named: Icon.cancelIcon.image)!.withRenderingMode(.alwaysTemplate)
        self.navigationController?.navigationBar.backIndicatorTransitionMaskImage = navigatonBarImage
        self.navigationController?.navigationBar.backIndicatorImage = navigatonBarImage
    }
    
    private func setupViews() {
        view.addSubview(imageContainerView)
        view.addSubview(imageCollection)
        view.addSubview(saveButton)
        
        imageContainerView.addSubview(imageView)
        
        NSLayoutConstraint.activate([
            imageContainerView.topAnchor.constraint(equalTo: view.topAnchor),
            imageContainerView.widthAnchor.constraint(equalToConstant: view.bounds.width),
            imageContainerView.bottomAnchor.constraint(equalTo: view.centerYAnchor, constant: Constants.buttonBarHeight),
            
            imageView.centerXAnchor.constraint(equalTo: imageContainerView.centerXAnchor),
            imageView.centerYAnchor.constraint(equalTo: view.topAnchor, constant: view.bounds.height/4 - Constants.imageSize/2),
            imageView.widthAnchor.constraint(equalToConstant: Constants.imageSize),
            imageView.heightAnchor.constraint(equalToConstant: Constants.imageSize),
            
            imageCollection.topAnchor.constraint(equalTo: view.centerYAnchor, constant: -Constants.buttonBarHeight),
            imageCollection.widthAnchor.constraint(equalToConstant: view.bounds.width),
            imageCollection.bottomAnchor.constraint(equalTo: saveButton.topAnchor),
            
            saveButton.heightAnchor.constraint(equalToConstant: Constants.buttonBarHeight),
            saveButton.widthAnchor.constraint(equalToConstant: view.bounds.width),
            saveButton.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor)
        ])
    }
    
    @objc func saveImage(sender: UIButton!) {
//        // In here we check each property that we want to store and if it s empty
//        guard let title = titleTextField.text, !title.isEmpty else {
//            // If it is we inform the user with an alert
//            Alerts.presentAlert(description: EntryErrors.titleEmpty.localizedDescription, viewController: self)
//            return
//        }
//
//        guard let story = storyTextView.text, !story.isEmpty else {
//            Alerts.presentAlert(description: EntryErrors.storyEmpty.localizedDescription, viewController: self)
//            return
//        }
//
//        let entry = NSEntityDescription.insertNewObject(forEntityName: "Entry", into: managedObjectContext) as! Entry
//
//        entry.title = title
//        entry.story = story
//
//        managedObjectContext.saveChanges()
//
        print("Saving Image")
//
//        // Saving an entry should dismiss the entryController
        navigationController?.popViewController(animated: true)
        dismiss(animated: true, completion: nil)
    }
    
    @objc func cancel() {
        // This should have some sort of check to prevent dismissing unsaved information
        dismiss(animated: true, completion: nil)
    }
}

extension ImageController: UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout {
    
    // Sets the amount of cells
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
//        guard let section = fetchedResultsController.sections?[section] else {
//            return 0
//        }
//        return section.numberOfObjects
        return 50
    }
    
    // Sets up cell content
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = imageCollection.dequeueReusableCell(withReuseIdentifier: cellId, for: indexPath) as! ImageCell
        cell.backgroundColor = UIColor.systemTeal
//        let entry = fetchedResultsController.object(at: indexPath)
//        cell.titleLabel.text = entry.title
//        cell.storyLabel.text = entry.story
        return cell
    }
    
    // Sets up size of the cells
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: 50, height: 50)
    }
    
    // Sets up spacing between posts
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 10
    }
    
    // Sets up what to do when a cell gets tapped
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        print(indexPath)
//        let entry = fetchedResultsController.object(at: indexPath)
//        let editEntryController = EditEntryController()
//        editEntryController.managedObjectContext = self.managedObjectContext
//        editEntryController.entry = entry
//
//        navigationController?.pushViewController(editEntryController, animated: true)
    }
    
    // MARK: Delete Entry
    func collectionView(_ collectionView: UICollectionView, performAction action: Selector, forItemAt indexPath: IndexPath, withSender sender: Any?) {
//        let entry = fetchedResultsController.object(at: indexPath)
//
//        managedObjectContext.delete(entry)
//        managedObjectContext.saveChanges()
//
//        print("Deleted \(entry) at \(indexPath)")
    }
}
