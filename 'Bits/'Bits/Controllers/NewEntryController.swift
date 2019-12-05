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
    
    let imageController = ImageController()
    let datePickerManager = DatePickerManager()
    let locationManager = LocationManager()
    
    let updateEntriesNotification = Notification.Name(rawValue: NotificationKey.updateEntriesNotificationKey)
    
    var managedObjectContext: NSManagedObjectContext!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.hideKeyboardWhenTappedAround() 

        view.backgroundColor = ColorConstants.appBackgroundColor
        
        setupNavigationBarItems()
        setupViews()
        
        resetLabels()
    }

    lazy var imageView: UIImageView = {
        let imageView = UIImageView()
        imageView.image = UIImage(named: Icon.bitsThumb.image) // Sets default image
        imageView.backgroundColor = ColorConstants.labelColor
        imageView.layer.cornerRadius = Constants.imageCornerRadius
        imageView.layer.masksToBounds = true
        imageView.translatesAutoresizingMaskIntoConstraints = false
        let tapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(presentImageController(tapGestureRecognizer:)))
        imageView.addGestureRecognizer(tapGestureRecognizer)
        imageView.isUserInteractionEnabled = true
        return imageView
    }()
    
    lazy var titleTextField: TitleTextField = {
        let titleTextField = TitleTextField()
        titleTextField.text = "Enter Title"
        titleTextField.keyboardAppearance = .dark
        titleTextField.returnKeyType = UIReturnKeyType.done
        return titleTextField
    }()
    
    lazy var dateLabel: EntryTextField = {
        let dateLabel = EntryTextField()
        dateLabel.text = "Tap to set date"
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
        locationLabel.text = "Tap to add location"
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
        storyTextView.text = "Write your story here"
        storyTextView.keyboardAppearance = .dark
        storyTextView.returnKeyType = UIReturnKeyType.done
        return storyTextView
    }()
    
    lazy var saveButton: CustomButton = {
        let saveButton = CustomButton(type: .custom)
        let image = UIImage(named: Icon.saveIcon.image)?.withRenderingMode(.alwaysTemplate)
        saveButton.setImage(image, for: .normal)
        let inset: CGFloat = 10
        saveButton.imageEdgeInsets = UIEdgeInsets(top: inset, left: inset, bottom: inset, right: inset)
        saveButton.addTarget(self, action: #selector(saveEntry(sender:)), for: .touchUpInside)
        return saveButton
    }()
    
    private func setupNavigationBarItems() {
        let navigatonBarImage = UIImage(named: Icon.cancelIcon.image)!.withRenderingMode(.alwaysTemplate)
        self.navigationController?.navigationBar.backIndicatorTransitionMaskImage = navigatonBarImage
        self.navigationController?.navigationBar.backIndicatorImage = navigatonBarImage
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
    
    func resetLabels() {
        titleTextField.text = "Enter Title"
        dateLabel.text = "Tap to set date"
        locationLabel.text = "Tap to add location"
        storyTextView.text = "Write your story here"
        datePickerManager.datePicker.setDate(Date(), animated: false) // resets date inside picker wheel
        datePickerManager.dateSelected = String(describing: datePickerManager.getCurrentDate()) // resets date for label
        locationManager.locationLabel.text = "Tap to add location"
        imageView.image = UIImage(named: Icon.bitsThumb.image)
    }
    
    @objc private func saveEntry(sender: UIButton!) {
        guard let title = titleTextField.text, !title.isEmpty else {
            presentAlert(description: EntryErrors.titleEmpty.localizedDescription, viewController: self)
            return
        }
        guard let story = storyTextView.text, !story.isEmpty else {
            presentAlert(description: EntryErrors.storyEmpty.localizedDescription, viewController: self)
            return
        }
        guard let date = dateLabel.text, !date.isEmpty else {
            presentAlert(description: EntryErrors.dateEmpty.localizedDescription, viewController: self)
            return
        }
        
        guard let location = locationLabel.text, !location.isEmpty else {
            presentAlert(description: EntryErrors.locationEmpty.localizedDescription, viewController: self)
            return
        }
        
        guard let image = imageView.image, let imageData = image.pngData() else {
            presentAlert(description: EntryErrors.photoEmpty.localizedDescription, viewController: self)
            return
        }
            
        let entry = NSEntityDescription.insertNewObject(forEntityName: "Entry", into: managedObjectContext) as! Entry
        
        entry.title = title
        entry.date = date
        entry.location = location
        entry.story = story
        entry.imageData = imageData
        
        entry.managedObjectContext?.saveChanges()
        
        NotificationCenter.default.post(name: updateEntriesNotification, object: nil)
        print("Item Saved, with title: \(entry.title)")
        navigationController?.popViewController(animated: true)
    }
    
    @objc private func cancel() {
        dismiss(animated: true, completion: nil)
    }
    
    @objc func presentImageController(tapGestureRecognizer: UITapGestureRecognizer) {
        view.endEditing(true)
        imageController.modeSelected = .newEntryMode
        imageController.newImageDelegate = self
        imageController.managedObjectContext = self.managedObjectContext
        imageController.imageView.image = UIImage(named: Icon.bitsThumb.image)!
        navigationController?.pushViewController(imageController, animated: true)
        print("Present imageController")
    }
    
    @objc func presentDatePicker(tapGestureRecognizer: UITapGestureRecognizer) {
        view.endEditing(true)
        datePickerManager.modeSelected = .newEntryMode
        datePickerManager.newDateDelegate = self
        datePickerManager.presentDatePicker()
        print("Present datePicker")
    }
    
    @objc func presentLocationManager(tapGestureRecognizer: UITapGestureRecognizer) {
        view.endEditing(true)
        let reachability = Reachability.checkReachable()
        
        if reachability == true {
            if locationManager.locationAuthorizationReceived == false {
                presentFailedPermissionActionSheet(description: LocationError.changeSettings.localizedDescription, viewController: self)
            } else if locationManager.locationAuthorizationReceived == true {
                locationManager.modeSelected = .newEntryMode
                locationManager.newLocationDelegate = self
                locationManager.presentLocationManager()
                print("Present locationManager")
            }
        } else if reachability == false {
            presentAlert(description: ConnectionError.noInternet.localizedDescription, viewController: self)
        }
    }
}

extension NewEntryController: NewDateDelegate, NewLocationDelegate, NewImageDelegate {
    func didSelectImage(image: UIImage) {
        imageView.image = image
    }
    
    func didSelectDate(date: String) {
        dateLabel.text = date
    }
    
    func didSelectLocation(location: String) {
        locationLabel.text = location
    }
}
