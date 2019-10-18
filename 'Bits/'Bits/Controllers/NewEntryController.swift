//
//  AddEntryController.swift
//  'Bits
//
//  Created by Wouter Willebrands on 14/10/2019.
//  Copyright © 2019 Studio Willebrands. All rights reserved.
//

import UIKit
import CoreData

class NewEntryController: UIViewController {
    
    let cellColor = UIColor(named: Color.suitUpSilver.rawValue) // background color of each object

    var managedObjectContext: NSManagedObjectContext!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        view.backgroundColor = UIColor.blue
        
        setupBackButton()
        setupViews()
    }
    
    lazy var saveButton: UIButton = {
        let saveButton = UIButton(type: .custom)
        let image = UIImage(named: Icon.saveIcon.rawValue)?.withRenderingMode(.alwaysTemplate) // Since we have a picture we dont want to render
        saveButton.setImage(image, for: .normal)
        saveButton.contentMode = .center
        saveButton.backgroundColor = UIColor(named: Color.gentlemanGray.rawValue)
        saveButton.tintColor = UIColor.red // Use when you want to render a different color than the original icon color
        let inset: CGFloat = 10
        saveButton.imageEdgeInsets = UIEdgeInsets(top: inset, left: inset, bottom: inset, right: inset)
        saveButton.imageView?.contentMode = .scaleAspectFit
        saveButton.addTarget(self, action: #selector(saveEntry), for: .touchUpInside)
        return saveButton
    }()
    
    lazy var entryImage: UIImageView = {
        let entryImage = UIImageView()
        entryImage.backgroundColor = cellColor
//        entryImage.image = UIImage(named: "BitsThumbnail") // Sets default image
        entryImage.translatesAutoresizingMaskIntoConstraints = false
//        entryImage.layer.cornerRadius = 8
        entryImage.layer.masksToBounds = true
        return entryImage
    }()
    
    // These might becomeUITextLabel instead
    lazy var entryTitle: UITextField = {
        let entryTitle = UITextField()
        entryTitle.backgroundColor = cellColor
        //            titleLabel.backgroundColor = UIColor(named: "SuitUpSilver")
        entryTitle.textColor = UIColor(named: Color.washedWhite.rawValue)
        entryTitle.text = "Enter Title"
        entryTitle.textAlignment = .center
//        entryTitle.layer.cornerRadius = 8
        entryTitle.layer.masksToBounds = true
        
        entryTitle.translatesAutoresizingMaskIntoConstraints = false
        
        return entryTitle
    }()
    
    lazy var entryDate: UILabel = {
        let entryDate = UILabel()
        entryDate.backgroundColor = cellColor
        
        entryDate.textColor = UIColor(named: Color.washedWhite.rawValue)
        entryDate.text = "01.01.2019"
        entryDate.textAlignment = .center
        
//        entryDate.layer.cornerRadius = 8
//        entryDate.layer.masksToBounds = true
        
        entryDate.translatesAutoresizingMaskIntoConstraints = false
        
        return entryDate
    }()
    
    lazy var entryContent: UITextView = {
        let entryContent = UITextView()
        entryContent.backgroundColor = cellColor
        //        postContent.backgroundColor = UIColor(named: "SuitUpSilver")
        entryContent.text = "Write your story here"
        entryContent.textAlignment = .left
        entryContent.textContainer.maximumNumberOfLines = 10
        let textInset: CGFloat = 10
        entryContent.textContainerInset = UIEdgeInsets(top: textInset, left: textInset, bottom: textInset, right: textInset)
        entryContent.textColor = UIColor(named: Color.washedWhite.rawValue)
        entryContent.translatesAutoresizingMaskIntoConstraints = false
//        entryContent.layer.cornerRadius = 8
//        entryContent.layer.masksToBounds = true
        
        return entryContent
    }()
    
    lazy var navigatonBarImage: UIImage = {
        let navBarImage = UIImage(named: Icon.cancelIcon.rawValue)!.withRenderingMode(.alwaysTemplate)
        return navBarImage
    }()
    
    private func setupBackButton() {
        
        self.navigationController?.navigationBar.backIndicatorTransitionMaskImage = navigatonBarImage
        self.navigationController?.navigationBar.backIndicatorImage = navigatonBarImage
    }
    
    
    private func setupViews() {
        
        view.addSubview(entryTitle)
        view.addSubview(entryDate)
        view.addSubview(entryContent)
        view.addSubview(entryImage)
        
        view.addSubview(saveButton)
        
        let spacing: CGFloat = 16
        
        entryTitle.translatesAutoresizingMaskIntoConstraints = false
        entryTitle.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: spacing).isActive = true
        entryTitle.heightAnchor.constraint(equalToConstant: 2 * spacing).isActive = true
        entryTitle.widthAnchor.constraint(equalToConstant: view.bounds.width - (2 * spacing)).isActive = true
        entryTitle.centerXAnchor.constraint(equalTo: view.centerXAnchor, constant: 0).isActive = true
        
        entryDate.translatesAutoresizingMaskIntoConstraints = false
        entryDate.topAnchor.constraint(equalTo: entryTitle.bottomAnchor, constant: spacing).isActive = true
        entryDate.heightAnchor.constraint(equalToConstant: 2 * spacing).isActive = true
        entryDate.widthAnchor.constraint(equalToConstant: view.bounds.width - (2 * spacing)).isActive = true
        entryDate.centerXAnchor.constraint(equalTo: view.centerXAnchor, constant: 0).isActive = true
        
        entryContent.translatesAutoresizingMaskIntoConstraints = false
        entryContent.topAnchor.constraint(equalTo: entryDate.bottomAnchor, constant: spacing).isActive = true
        entryContent.heightAnchor.constraint(equalToConstant: 8 * spacing).isActive = true
        entryContent.widthAnchor.constraint(equalToConstant: view.bounds.width - (2 * spacing)).isActive = true
        entryContent.centerXAnchor.constraint(equalTo: view.centerXAnchor, constant: 0).isActive = true
        
        entryImage.translatesAutoresizingMaskIntoConstraints = false
        entryImage.topAnchor.constraint(equalTo: entryContent.bottomAnchor, constant: spacing).isActive = true
        entryImage.heightAnchor.constraint(equalToConstant: 8 * spacing).isActive = true
        entryImage.widthAnchor.constraint(equalToConstant: view.bounds.width - (2 * spacing)).isActive = true
        entryImage.centerXAnchor.constraint(equalTo: view.centerXAnchor, constant: 0).isActive = true
        
        saveButton.translatesAutoresizingMaskIntoConstraints = false // enabels autoLayout
        saveButton.heightAnchor.constraint(equalToConstant: 60).isActive = true // Height of the menuBar
        saveButton.widthAnchor.constraint(equalToConstant: view.bounds.width).isActive = true
        saveButton.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: 0).isActive = true
        
    }
    
    
    @objc func saveEntry(sender: UIButton!) {
        // In here we check each property that we want to store and if it s empty
        guard let title = entryTitle.text, !title.isEmpty else {
            errorAlert(description: NewEntryError.titleMissing.localizedDescription)
            return
        }
   
        guard let story = entryContent.text, !story.isEmpty else {
            return
        }
        
        let entry = NSEntityDescription.insertNewObject(forEntityName: "Entry", into: managedObjectContext) as! Entry
        
        entry.title = title
        entry.story = story
        
        managedObjectContext.saveChanges()
        
        print("Item Saved, with title: \(entry.title)")
        
        // Saving an entry should dismiss the entryController
        navigationController?.popViewController(animated: true)
        dismiss(animated: true, completion: nil)


    }
    
    
    @objc func cancel() {
        // This should have some sort of check to prevent dismissing unsaved information 
        
        dismiss(animated: true, completion: nil)
        
    }
    
//    func textViewDidBeginEditing(_ textView: UITextView) {
//        if textView.textColor == UIColor.lightGray {
//            textView.text = nil
//            textView.textColor = UIColor(named: Color.washedWhite.rawValue)
//        }
//    }
//
//    func textViewDidEndEditing(_ textView: UITextView) {
//        if textView.text.isEmpty {
//            textView.text = "Write your story here"
//            textView.textColor = UIColor.lightGray
//        }
//    }
    
}
