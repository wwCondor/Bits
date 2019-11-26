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
    
    var entry: Entry?
    let datePickerManager = DatePickerManager()
    let locationManager = LocationManager()
    var managedObjectContext: NSManagedObjectContext!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        view.backgroundColor = ColorConstants.appBackgroundColor

//        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow(sender:)), name:UIResponder.keyboardWillShowNotification, object: nil);
        
        setupNavigationBarItems()
        setupViews()
    }
    
//    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
//        view.endEditing(true)
//    }

    lazy var cancelButton: CustomButton = {
        let cancelButton = CustomButton(type: .custom)
        let image = UIImage(named: Icon.cancelIcon.image)?.withRenderingMode(.alwaysTemplate)
        cancelButton.setImage(image, for: .normal)
        let inset: CGFloat = 2
        cancelButton.imageEdgeInsets = UIEdgeInsets(top: inset, left: inset, bottom: inset + 8, right: inset + 30)
        cancelButton.addTarget(self, action: #selector(cancel), for: .touchUpInside)
        return cancelButton
    }()
    
    lazy var deleteButton: CustomButton = {
        let deleteButton = CustomButton(type: .custom)
        let image = UIImage(named: Icon.deleteIcon.image)?.withRenderingMode(.alwaysTemplate)
        deleteButton.setImage(image, for: .normal)
        let inset: CGFloat = 4
        deleteButton.imageEdgeInsets = UIEdgeInsets(top: inset, left: inset, bottom: inset + 10, right: inset + 35)
        deleteButton.addTarget(self, action: #selector(deleteEntry), for: .touchUpInside)
        return deleteButton
    }()
    
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
        titleTextField.text = entry?.title
        return titleTextField
    }()
    
    lazy var dateLabel: EntryTextField = {
        let dateLabel = EntryTextField()
        dateLabel.text = "01.01.2019"  // MARK: entry?.date
        return dateLabel
    }()
    
    lazy var dateTapScreen: UIView = {
        let dateTapScreen = UIView()
        dateTapScreen.backgroundColor = UIColor.clear
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(presentDatePicker(tapGestureRecognizer:)))
        dateTapScreen.addGestureRecognizer(tapGesture)
        dateTapScreen.isUserInteractionEnabled = true
        dateTapScreen.translatesAutoresizingMaskIntoConstraints = false
        return dateTapScreen
    }()
    
    lazy var locationLabel: EntryTextField = {
        let locationLabel = EntryTextField()
        locationLabel.text = "home" // MARK: entry?.location
        return locationLabel
    }()
    
    lazy var locationTapScreen: UIView = {
        let locationTapScreen = UIView()
        locationTapScreen.backgroundColor = UIColor.clear
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(presentLocationManager(tapGestureRecognizer:)))
        locationTapScreen.addGestureRecognizer(tapGesture)
        locationTapScreen.isUserInteractionEnabled = true
        locationTapScreen.translatesAutoresizingMaskIntoConstraints = false
        return locationTapScreen
    }()
    
    lazy var storyTextView: StoryTextView = {
        let storyTextView = StoryTextView()
        storyTextView.text = entry?.story
        return storyTextView
    }()
    
    lazy var saveButton: CustomButton = {
        let saveButton = CustomButton(type: .custom)
        let image = UIImage(named: Icon.saveIcon.image)?.withRenderingMode(.alwaysTemplate)
        saveButton.setImage(image, for: .normal)
        let inset: CGFloat = 10
        saveButton.imageEdgeInsets = UIEdgeInsets(top: inset, left: inset, bottom: inset, right: inset)
        saveButton.addTarget(self, action: #selector(saveEntry), for: .touchUpInside)
        return saveButton
    }()
    
    private func setupNavigationBarItems() {
        self.navigationItem.setHidesBackButton(true, animated: true)
        let cancelBarButtonItem = UIBarButtonItem(customView: cancelButton)
        let deleteBarButtonItem = UIBarButtonItem(customView: deleteButton)
        self.navigationItem.leftBarButtonItem = cancelBarButtonItem
        self.navigationItem.rightBarButtonItem = deleteBarButtonItem
    }
    
    private func setupViews() {
        view.addSubview(imageView)
        view.addSubview(titleTextField)
        view.addSubview(dateLabel)
        view.addSubview(dateTapScreen)
        view.addSubview(locationLabel)
        view.addSubview(locationTapScreen)
        view.addSubview(storyTextView)
        
        view.addSubview(saveButton)
        
        let smallSpacing: CGFloat = 8
        let labelHeigth = (Constants.imageSize - 2 * smallSpacing) / 3
        
        NSLayoutConstraint.activate([
            cancelButton.widthAnchor.constraint(equalToConstant: view.bounds.width * (1/2)),
            deleteButton.widthAnchor.constraint(equalToConstant: view.bounds.width * (1/2)),
            
            imageView.topAnchor.constraint(equalTo: view.topAnchor, constant: Constants.contentPadding),
            imageView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: Constants.contentPadding),
            imageView.widthAnchor.constraint(equalToConstant: Constants.imageSize),
            imageView.heightAnchor.constraint(equalToConstant: Constants.imageSize),
            
            titleTextField.topAnchor.constraint(equalTo: view.topAnchor, constant: Constants.contentPadding),
            titleTextField.leadingAnchor.constraint(equalTo: imageView.trailingAnchor, constant: smallSpacing),
            titleTextField.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -Constants.contentPadding),
            titleTextField.heightAnchor.constraint(equalToConstant: labelHeigth),

            dateLabel.topAnchor.constraint(equalTo: titleTextField.bottomAnchor, constant: smallSpacing),
            dateLabel.leadingAnchor.constraint(equalTo: imageView.trailingAnchor, constant: smallSpacing),
            dateLabel.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -Constants.contentPadding),
            dateLabel.heightAnchor.constraint(equalToConstant: labelHeigth),
            
            dateTapScreen.topAnchor.constraint(equalTo: titleTextField.bottomAnchor, constant: smallSpacing),
            dateTapScreen.leadingAnchor.constraint(equalTo: imageView.trailingAnchor, constant: smallSpacing),
            dateTapScreen.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -Constants.contentPadding),
            dateTapScreen.heightAnchor.constraint(equalToConstant: labelHeigth),

            locationLabel.topAnchor.constraint(equalTo: dateLabel.bottomAnchor, constant: smallSpacing),
            locationLabel.leadingAnchor.constraint(equalTo: imageView.trailingAnchor, constant: smallSpacing),
            locationLabel.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -Constants.contentPadding),
            locationLabel.heightAnchor.constraint(equalToConstant: labelHeigth),
            
            locationTapScreen.topAnchor.constraint(equalTo: dateLabel.bottomAnchor, constant: smallSpacing),
            locationTapScreen.leadingAnchor.constraint(equalTo: imageView.trailingAnchor, constant: smallSpacing),
            locationTapScreen.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -Constants.contentPadding),
            locationTapScreen.heightAnchor.constraint(equalToConstant: labelHeigth),

            storyTextView.topAnchor.constraint(equalTo: locationLabel.bottomAnchor, constant: smallSpacing),
            storyTextView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: Constants.contentPadding),
            storyTextView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -Constants.contentPadding),
            storyTextView.bottomAnchor.constraint(equalTo: view.centerYAnchor),
            
            saveButton.heightAnchor.constraint(equalToConstant: Constants.buttonBarHeight),
            saveButton.widthAnchor.constraint(equalToConstant: view.bounds.width),
            saveButton.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor)
        ])
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
    
    @objc func presentDatePicker(tapGestureRecognizer: UITapGestureRecognizer) {
        datePickerManager.presentDatePicker()
        print("Present datePicker")
    }
    
    @objc func presentLocationManager(tapGestureRecognizer: UITapGestureRecognizer) {
        locationManager.presentLocationManager()
        print("Present locationManager")
    }
    
    @objc func saveEntry(sender: UIButton!) {
        // In here we check if we have an entry, then save the changes
        if let entry = entry, let newTitle = titleTextField.text, let newStory = storyTextView.text {
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
    

    
//    @objc func keyboardWillShow(sender: NSNotification) {
//        titleTextField.keyboardAppearance = .dark
//        entryContent.keyboardAppearance = .dark
//
//        entryTitle.becomeFirstResponder()
//        entryContent.becomeFirstResponder()
//    }
    
}
