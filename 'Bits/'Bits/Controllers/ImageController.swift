//
//  ImageController.swift
//  'Bits
//
//  Created by Wouter Willebrands on 26/11/2019.
//  Copyright © 2019 Studio Willebrands. All rights reserved.
//

import UIKit
import CoreData
import Photos

protocol NewImageDelegate {
    func didSelectImage(image: UIImage)
}

protocol EditImageDelegate {
    func didEditImage(image: UIImage)
}

extension ImageController {
    
}

class ImageController: UIViewController {
    
    let imageSize: CGFloat = 300
    
    var modeSelected: ModeSelected = .newEntryMode
    
    var newImageDelegate: NewImageDelegate!
    var editImageDelegate: EditImageDelegate!
    
    var photoAccessAuthorizationRequested: Bool = false
    
    var imageArray = [UIImage]()
//    var selectedEntryImage = UIImage(named: Icon.bitsThumb.image)!
    
    let libraryAuthorizationStatus = PHPhotoLibrary.authorizationStatus()
    
    var managedObjectContext: NSManagedObjectContext!
    let cellId = "cellId"
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = ColorConstants.appBackgroundColor
        
        setupNavigationBarItems()
        setupViews()
        
        checkLibraryAccessAuthorization()
//        imageCollection.dragDelegate = self
    }
    
    func checkLibraryAccessAuthorization() {
        if libraryAuthorizationStatus == .notDetermined {
            print("Authorization not determined")
            PHPhotoLibrary.requestAuthorization { (status) in
                DispatchQueue.main.async {
                    if status == .authorized {
                        self.getPhotos()
                        self.imageCollection.reloadData()
                    } else {
                        self.presentFailedPermissionActionSheet(description: EntryErrors.noPhotoAuthorization.localizedDescription, viewController: self)
                    }
                }
            }
        } else if libraryAuthorizationStatus == .denied || libraryAuthorizationStatus == .restricted {
            print("Authorization denied or restricted")
            presentFailedPermissionActionSheet(description: EntryErrors.noPhotoAuthorization.localizedDescription, viewController: self)
        } else if libraryAuthorizationStatus == .authorized {
            print("Authorization granted")
            getPhotos()
        } else {
            presentAlert(description: EntryErrors.unknownAuthorizationError.localizedDescription, viewController: self)
        }
    }
        
    func getPhotos() {
        let imageManager = PHImageManager.default()
        
        let imageRequestOptions = PHImageRequestOptions()
        imageRequestOptions.isSynchronous = true
        imageRequestOptions.deliveryMode = .fastFormat
        
        let fetchOptions = PHFetchOptions()
        fetchOptions.sortDescriptors = [NSSortDescriptor(key: "creationDate", ascending: false)]
        
        let fetchResults: PHFetchResult = PHAsset.fetchAssets( with: .image, options: fetchOptions)
            
        if fetchResults.count > 0 {
            for i in 0..<fetchResults.count {
                imageManager.requestImage(for: fetchResults.object(at: i), targetSize: CGSize(width: imageSize, height: imageSize), contentMode: .aspectFit, options: imageRequestOptions) { (image, error) in
                    
                    guard let image = image else {
                        return
                    }
                    if !self.imageArray.contains(image) {
                        self.imageArray.append(image)
                    }
                }
            }
        } else {
            presentAlert(description: EntryErrors.noPhotos.localizedDescription, viewController: self)
        }
    }
    
    lazy var imageViewBackground: UIView = {
        let imageViewBackground = UIView()
        imageViewBackground.backgroundColor = ColorConstants.appBackgroundColor
        imageViewBackground.translatesAutoresizingMaskIntoConstraints = false
        return imageViewBackground
    }()

    lazy var imageView: UIImageView = {
        let imageView = UIImageView()
//        imageView.image = UIImage(named: Icon.bitsThumb.image) // Sets default image
        imageView.backgroundColor = ColorConstants.labelColor
        imageView.layer.cornerRadius = Constants.imageCornerRadius
        imageView.layer.masksToBounds = true
        imageView.translatesAutoresizingMaskIntoConstraints = false
//        let dropInteraction = UIDropInteraction(delegate: self)
//        imageView.addInteraction(dropInteraction)
//        imageView.isUserInteractionEnabled = true
//        let tapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(presentImageController(tapGestureRecognizer:)))
//        imageView.addGestureRecognizer(tapGestureRecognizer)
//        imageView.isUserInteractionEnabled = true
        return imageView
    }()
    
    lazy var imageCollectionBackground: UIView = {
        let imageCollectionBackground = UIView()
        imageCollectionBackground.backgroundColor = ColorConstants.entryObjectBackground
        imageCollectionBackground.translatesAutoresizingMaskIntoConstraints = false
        return imageCollectionBackground
    }()
    
    lazy var imageCollection: UICollectionView = {
        let layout: UICollectionViewFlowLayout = UICollectionViewFlowLayout()
        let imageCollection = UICollectionView(frame: view.frame, collectionViewLayout: layout)
        imageCollection.backgroundColor = UIColor.clear
        imageCollection.register(ImageCell.self, forCellWithReuseIdentifier: cellId)
        imageCollection.dataSource = self
        imageCollection.delegate = self
//        imageCollection.dragDelegate = self
//        imageCollection.dropDelegate = self
        imageCollection.translatesAutoresizingMaskIntoConstraints = false
        return imageCollection
    }()
    
    lazy var saveButton: CustomButton = {
        let saveButton = CustomButton(type: .custom)
        let image = UIImage(named: Icon.saveIcon.image)?.withRenderingMode(.alwaysTemplate)
        saveButton.setImage(image, for: .normal)
        let inset: CGFloat = 10
        saveButton.imageEdgeInsets = UIEdgeInsets(top: inset, left: inset, bottom: inset, right: inset)
        saveButton.addTarget(self, action: #selector(setImage(sender:)), for: .touchUpInside)
        return saveButton
    }()
    
    private func setupNavigationBarItems() {
        let navigatonBarImage = UIImage(named: Icon.cancelIcon.image)!.withRenderingMode(.alwaysTemplate)
        self.navigationController?.navigationBar.backIndicatorTransitionMaskImage = navigatonBarImage
        self.navigationController?.navigationBar.backIndicatorImage = navigatonBarImage
    }
    
    private func setupViews() {
        view.addSubview(imageViewBackground)
        imageViewBackground.addSubview(imageView)

        view.addSubview(imageCollectionBackground)
        view.addSubview(imageCollection)
        view.addSubview(saveButton)
        
        NSLayoutConstraint.activate([
            imageViewBackground.topAnchor.constraint(equalTo: view.topAnchor),
            imageViewBackground.widthAnchor.constraint(equalToConstant: view.bounds.width),
            imageViewBackground.bottomAnchor.constraint(equalTo: view.centerYAnchor),
            
            imageView.centerXAnchor.constraint(equalTo: imageViewBackground.centerXAnchor),
            imageView.centerYAnchor.constraint(equalTo: view.topAnchor, constant: view.bounds.height/4),
            imageView.widthAnchor.constraint(equalToConstant: Constants.imageSize),
            imageView.heightAnchor.constraint(equalToConstant: Constants.imageSize),
            
            imageCollectionBackground.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            imageCollectionBackground.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            imageCollectionBackground.topAnchor.constraint(equalTo: imageViewBackground.bottomAnchor, constant: Constants.contentPadding),
            imageCollectionBackground.bottomAnchor.constraint(equalTo: saveButton.topAnchor),
                        
            imageCollection.topAnchor.constraint(equalTo: imageCollectionBackground.topAnchor, constant: Constants.contentPadding),
            imageCollection.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: Constants.contentPadding),
            imageCollection.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -Constants.contentPadding),
            imageCollection.bottomAnchor.constraint(equalTo: saveButton.topAnchor),
            
            saveButton.heightAnchor.constraint(equalToConstant: Constants.buttonBarHeight),
            saveButton.widthAnchor.constraint(equalToConstant: view.bounds.width),
            saveButton.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor)
        ])
    }
    
    @objc func setImage(sender: UIButton!) {
        guard let image = imageView.image else {
            presentAlert(description: EntryErrors.photoEmpty.localizedDescription, viewController: self)
            print("imageView is empty")
            return
        }
        
        if modeSelected == .newEntryMode {
            newImageDelegate.didSelectImage(image: image)
        } else if modeSelected == .editEntryMode {
            editImageDelegate.didEditImage(image: image)
        }

        print("Setting Image")
//
        navigationController?.popViewController(animated: true)
        dismiss(animated: true, completion: nil)
    }
    
    @objc func cancel() {
        dismiss(animated: true, completion: nil)
    }
}

//
extension ImageController: UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout {
    
    // Sets the amount of cells
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if imageArray.count != 0 {
            return imageArray.count
        } else {
            return 12
        }
    }
    
    // Sets up cell content
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = imageCollection.dequeueReusableCell(withReuseIdentifier: cellId, for: indexPath) as! ImageCell
        cell.backgroundColor = UIColor.systemTeal
        
        cell.layer.cornerRadius = Constants.thumbnailCornerRadius
        cell.layer.masksToBounds = true
        
        if imageArray.count != 0 {
            cell.imageView.image = imageArray[indexPath.row]
        } else {
            cell.imageView.image = UIImage(named: Icon.bitsThumb.image)
        }
        return cell
    }
    
    // Sets up size of the cells
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let size = Constants.imageSize / 2
        return CGSize(width: size, height: size)
    }
    
    // Sets up spacing between posts
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 5
    }
    
    // Sets up what to do when a cell gets tapped
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        print(indexPath)
        
        let imageSelected = imageArray[indexPath.row]
        imageView.image = imageSelected
    }
}

extension UIImage {
    func convertedToData() -> Data? {
        let data: Data? = self.pngData()
        return data
    }
}

//extension ImageController: UICollectionViewDragDelegate { //}, UIDragInteractionDelegate { //}, UICollectionViewDropDelegate {
//    func dragInteraction(_ interaction: UIDragInteraction, itemsForBeginning session: UIDragSession) -> [UIDragItem] {
//        let touchedPoint = session.location(in: self.view)
//        if let touchedImageView = self.view.hitTest(touchedPoint, with: nil) as? UIImageView {
//            let touchedImage = touchedImageView.image
//
//            let itemProvider = NSItemProvider(object: touchedImage!)
//
//            let dragItem = UIDragItem(itemProvider: itemProvider)
//            return [dragItem]
//        }
//
//        return []
//
////        let image: UIImage = imageArray[indexPath.row]
////        let imageString = image.convertedToString()!
////        print("String length: \(imageString.count)")
////        let itemProvider = NSItemProvider(object: imageString as NSString)
////        let dragItem = UIDragItem(itemProvider: itemProvider)
////        dragItem.localObject = image
////        return [dragItem]
//    }
//
//
//    func dragItems(for indexPath: IndexPath) -> [UIDragItem] {
//        let image: UIImage = imageArray[indexPath.row]
//        let imageString = image.convertedToString()!
//        print("String length: \(imageString.count)")
//        let itemProvider = NSItemProvider(object: imageString as NSString)
//        let dragItem = UIDragItem(itemProvider: itemProvider)
//        dragItem.localObject = image
//        return [dragItem]
//    }
//
//    func collectionView(_ collectionView: UICollectionView, itemsForBeginning session: UIDragSession, at indexPath: IndexPath) -> [UIDragItem] {
//        print("Dragging")
//        return dragItems(for: indexPath)
//    }
    
//    func collectionView(_ collectionView: UICollectionView, performDropWith coordinator: UICollectionViewDropCoordinator) {
//    }
//}
