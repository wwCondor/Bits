//
//  EditEntryController.swift
//  'Bits
//
//  Created by Wouter Willebrands on 19/10/2019.
//  Copyright © 2019 Studio Willebrands. All rights reserved.
//

import UIKit
import CoreData

class EditEntryController: UIViewController {
    
    let cellColor = UIColor(named: Color.suitUpSilver.name) // background color of each object

    var entry: Entry?
    var managedObjectContext: NSManagedObjectContext!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        view.backgroundColor = UIColor.systemYellow
        
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow(sender:)), name:UIResponder.keyboardWillShowNotification, object: nil);
        
        setupNavigationBarItems()
        setupViews()
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        view.endEditing(true)
    }

    lazy var cancelButton: UIButton = {
        let cancelButton = UIButton(type: .custom)
        let image = UIImage(named: Icon.cancelIcon.image)?.withRenderingMode(.alwaysTemplate)
        cancelButton.setImage(image, for: .normal)
        cancelButton.contentMode = .center
        cancelButton.backgroundColor = UIColor(named: Color.gentlemanGray.name)
        cancelButton.tintColor = ColorConstants.tintColor
        let inset: CGFloat = 2
        cancelButton.imageEdgeInsets = UIEdgeInsets(top: inset, left: inset, bottom: inset + 8, right: inset + 30)
        cancelButton.imageView?.contentMode = .scaleAspectFit
        cancelButton.addTarget(self, action: #selector(cancel), for: .touchUpInside)
        return cancelButton
    }()
    
    lazy var deleteButton: UIButton = {
        let deleteButton = UIButton(type: .custom)
        let image = UIImage(named: Icon.deleteIcon.image)?.withRenderingMode(.alwaysTemplate)
        deleteButton.setImage(image, for: .normal)
        deleteButton.contentMode = .center
        deleteButton.backgroundColor = UIColor(named: Color.gentlemanGray.name)
        deleteButton.tintColor = ColorConstants.tintColor
        let inset: CGFloat = 4
        deleteButton.imageEdgeInsets = UIEdgeInsets(top: inset, left: inset, bottom: inset + 10, right: inset + 35)
        deleteButton.imageView?.contentMode = .scaleAspectFit
        deleteButton.addTarget(self, action: #selector(deleteEntry), for: .touchUpInside)
        return deleteButton
    }()
    

    /// Added top marker
    lazy var imageView: UIImageView = {
        let imageView = UIImageView()
        imageView.image = UIImage(named: Icon.bitsThumb.image) // Sets default image
        imageView.backgroundColor = ColorConstants.labelColor
        imageView.layer.cornerRadius = Constants.imageCornerRadius
        imageView.layer.masksToBounds = true
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
    }()
    
    lazy var titleTextField: TitleTextField = {
        let titleTextField = TitleTextField()
        titleTextField.text = "Title"
        return titleTextField
    }()
    
    lazy var dateLabel: EntryTextField = {
        let dateLabel = EntryTextField()
        dateLabel.text = "01.01.2019"
        return dateLabel
    }()
    
    lazy var locationLabel: EntryTextField = {
        let locationLabel = EntryTextField()
        locationLabel.text = "home"
        return locationLabel
    }()
    
    lazy var storyTextView: StoryTextView = {
        let storyTextView = StoryTextView()
        storyTextView.text = "Write your story here"
        return storyTextView
    }()
    /// Added bottom marker
    // MARK: Remove Below
    
    lazy var saveButton: UIButton = {
        let saveButton = UIButton(type: .custom)
        let image = UIImage(named: Icon.saveIcon.image)?.withRenderingMode(.alwaysTemplate)
        saveButton.setImage(image, for: .normal)
        saveButton.contentMode = .center
        saveButton.backgroundColor = UIColor(named: Color.gentlemanGray.name)
        saveButton.tintColor = ColorConstants.tintColor
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
    
    lazy var entryTitle: UITextField = {
        let entryTitle = UITextField()
        entryTitle.backgroundColor = cellColor
        entryTitle.textColor = ColorConstants.tintColor
        entryTitle.font = UIFont.systemFont(ofSize: 16.0, weight: .medium)
        entryTitle.text = entry?.title
        entryTitle.textAlignment = .center
//        entryTitle.layer.cornerRadius = 8
        entryTitle.layer.masksToBounds = true
        entryTitle.translatesAutoresizingMaskIntoConstraints = false
        return entryTitle
    }()
    
    lazy var entryDate: UILabel = {
        let entryDate = UILabel()
        entryDate.backgroundColor = cellColor
        entryDate.textColor = ColorConstants.tintColor
        entryDate.font = UIFont.systemFont(ofSize: 14.0, weight: .medium)
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
        entryContent.text = entry?.story
        entryContent.font = UIFont.systemFont(ofSize: 14.0, weight: .medium)
        entryContent.textAlignment = .left
        entryContent.textContainer.maximumNumberOfLines = 10
        let textInset: CGFloat = 10
        entryContent.textContainerInset = UIEdgeInsets(top: textInset, left: textInset, bottom: textInset, right: textInset)
        entryContent.textColor = ColorConstants.tintColor
        entryContent.translatesAutoresizingMaskIntoConstraints = false
//        entryContent.layer.cornerRadius = 8
//        entryContent.layer.masksToBounds = true
        return entryContent
    }()
     // MARK: Remove above
    
    private func setupNavigationBarItems() {
        self.navigationItem.setHidesBackButton(true, animated: true)
        let cancelBarButtonItem = UIBarButtonItem(customView: cancelButton)
        let deleteBarButtonItem = UIBarButtonItem(customView: deleteButton)
        self.navigationItem.leftBarButtonItem = cancelBarButtonItem
        self.navigationItem.rightBarButtonItem = deleteBarButtonItem
        
    }
    
    private func setupViews() {
        view.addSubview(entryTitle)
        view.addSubview(entryDate)
        view.addSubview(entryContent)
        view.addSubview(entryImage)
        
        view.addSubview(saveButton)
        
        let spacing: CGFloat = 16 // MARK: Make global constant
        
        // MARK: Refactor NSLayoutContstraint
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
        
        saveButton.translatesAutoresizingMaskIntoConstraints = false
        saveButton.heightAnchor.constraint(equalToConstant: 60).isActive = true
        saveButton.widthAnchor.constraint(equalToConstant: view.bounds.width).isActive = true
        saveButton.rightAnchor.constraint(equalTo: view.rightAnchor, constant: 0).isActive = true
        saveButton.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: 0).isActive = true
        
        deleteButton.translatesAutoresizingMaskIntoConstraints = false
        deleteButton.widthAnchor.constraint(equalToConstant: view.bounds.width * (1/2)).isActive = true
        
        cancelButton.translatesAutoresizingMaskIntoConstraints = false
        cancelButton.widthAnchor.constraint(equalToConstant: view.bounds.width * (1/2)).isActive = true

    }
    
    
    @objc func saveEntry(sender: UIButton!) {
        // In here we check if we have an entry, then save the changes
        if let entry = entry, let newTitle = entryTitle.text, let newStory = entryContent.text {
            entry.title = newTitle
            entry.story = newStory
            managedObjectContext.saveChanges()
            print("Item Saved, with title: \(newTitle)")
            navigationController?.popViewController(animated: true)
//            dismiss(animated: true, completion: nil)
        } else {
            print("We are here")
            if entry == nil {
                Alerts.presentAlert(description: EntryErrors.entryNil.localizedDescription , viewController: self)
            } else if entry?.title == "" {
                Alerts.presentAlert(description: EntryErrors.titleEmpty.localizedDescription , viewController: self)
            } else if entry?.story == "" {
                Alerts.presentAlert(description: EntryErrors.storyEmpty.localizedDescription, viewController: self)
            }
        }
    }
    
    // MARK: BarButtonItem Methods
    @objc func deleteEntry(sender: UIButton!) {
        if let entry = entry {
            managedObjectContext.delete(entry)
            managedObjectContext.saveChanges()
            navigationController?.popViewController(animated: true)
            dismiss(animated: true, completion: nil)
        }
    }
    
    
    @objc func cancel() {
        // This should have some sort of check to prevent dismissing unsaved information
        navigationController?.popViewController(animated: true)
        dismiss(animated: true, completion: nil)
    }
    
    @objc func keyboardWillShow(sender: NSNotification) {
        entryTitle.keyboardAppearance = .dark
        entryContent.keyboardAppearance = .dark
        
        entryTitle.becomeFirstResponder()
        entryContent.becomeFirstResponder()
    }
    
}