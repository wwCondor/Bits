//
//  LocationManager.swift
//  'Bits
//
//  Created by Wouter Willebrands on 26/11/2019.
//  Copyright © 2019 Studio Willebrands. All rights reserved.
//

import UIKit
import CoreLocation

protocol NewLocationDelegate {
    func didSelectLocation(location: String)
}

protocol EditLocationDelegate {
    func didEditLocation(location: String)
}

class LocationManager: NSObject {
    
    override init() {
        super.init()
        locationManager.delegate = self
        locationManager.desiredAccuracy = kCLLocationAccuracyBest // default is "Best"
    }
    
    private let locationManager = CLLocationManager()
    
    var locationAuthorizationRequested: Bool = false
    var locationAuthorizationReceived: Bool = false
    
    var newLocationDelegate: NewLocationDelegate!
    var editLocationDelegate: EditLocationDelegate!
    
    lazy var locationString: String = "Tap to add location"
    
    let fadeView = UIView()
    var modeSelected: ModeSelected = .newEntryMode
    
    var entryCoordinate: Coordinate?
    
    lazy var locationView: UIView = {
        let locationView = UIView()
        locationView.backgroundColor = ColorConstants.entryObjectBackground
        locationView.translatesAutoresizingMaskIntoConstraints = false
        return locationView
    }()
    
    lazy var dismissButton: CustomButton = {
        let dismissButton = CustomButton(type: .custom)
        let image = UIImage(named: Icon.dismissIcon.image)!.withRenderingMode(.alwaysTemplate)
        dismissButton.setImage(image, for: .normal)
        let inset: CGFloat = 7
        dismissButton.imageEdgeInsets = UIEdgeInsets(top: inset, left: inset, bottom: inset, right: inset)
        dismissButton.addTarget(self, action: #selector(dismissLocationManager(sender:)), for: .touchUpInside)
        return dismissButton
    }()
    
    lazy var settingsShortcut: CustomButton = {
        let settingsShortcut = CustomButton(type: .custom)
        settingsShortcut.backgroundColor = ColorConstants.entryObjectBackground
        let image = UIImage(named: Icon.settingsIcon.image)!.withRenderingMode(.alwaysTemplate)
        settingsShortcut.setImage(image, for: .normal)
        let inset: CGFloat = 14
        settingsShortcut.imageEdgeInsets = UIEdgeInsets(top: inset, left: inset, bottom: inset, right: inset)
        settingsShortcut.addTarget(self, action: #selector(launchSettings), for: .touchUpInside)
        settingsShortcut.alpha = 0
        settingsShortcut.isEnabled = false
        return settingsShortcut
    }()
    
    lazy var locationLabel: LocationTextView = {
        let locationLabel = LocationTextView()
        locationLabel.text = ""
        return locationLabel
    }()
    
    @objc private func launchSettings() {
        // When tapped. Button fades out and settings is launched
        UIView.animate(
            withDuration: 0.5,
            delay: 0,
            options: .curveEaseOut,
            animations: {
                self.settingsShortcut.alpha = 0
        },
            completion: { _ in
                if let settingsURL = URL(string: UIApplication.openSettingsURLString + Bundle.main.bundleIdentifier!) {
                    UIApplication.shared.open(settingsURL, options: [:], completionHandler: nil)
                }
        })
    }
    
    private func showSettingShortcut() {
        UIView.animate(
            withDuration: 1.0,
            delay: 0,
            options: .curveEaseOut,
            animations: {
                self.settingsShortcut.alpha = 1.0
        },
            completion: { _ in
                self.settingsShortcut.isEnabled = true
        })
    }
    
    func presentLocationManager() {
        locationLabel.text = "Requesting Location"
        requestLocation()
        
        let window = UIApplication.shared.windows.first { $0.isKeyWindow }
        
        if let window = window {
            
            window.addSubview(fadeView)
            window.addSubview(locationView)
            window.addSubview(dismissButton)
            window.addSubview(locationLabel)
            window.addSubview(settingsShortcut)
            
            fadeView.frame = window.frame
            fadeView.alpha = 0
            fadeView.backgroundColor = UIColor.black
            fadeView.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(dismissLocationManager(sender:))))
            
            let buttonHeight = Constants.buttonBarHeight
            let padding = Constants.contentPadding
            let yOffset = window.frame.height
            
            NSLayoutConstraint.activate([
                locationView.leadingAnchor.constraint(equalTo: window.leadingAnchor),
                locationView.trailingAnchor.constraint(equalTo: window.trailingAnchor),
                locationView.topAnchor.constraint(equalTo: window.centerYAnchor, constant: buttonHeight),
                locationView.bottomAnchor.constraint(equalTo: window.bottomAnchor),
                
                dismissButton.leadingAnchor.constraint(equalTo: window.leadingAnchor),
                dismissButton.trailingAnchor.constraint(equalTo: window.trailingAnchor),
                dismissButton.topAnchor.constraint(equalTo: locationView.topAnchor),
                dismissButton.heightAnchor.constraint(equalToConstant: buttonHeight),
                
                locationLabel.leadingAnchor.constraint(equalTo: window.leadingAnchor, constant: padding),
                locationLabel.trailingAnchor.constraint(equalTo: window.trailingAnchor, constant: -padding),
                locationLabel.topAnchor.constraint(equalTo: dismissButton.bottomAnchor, constant: padding),
                locationLabel.heightAnchor.constraint(equalToConstant: 2 * buttonHeight),
                
                settingsShortcut.leadingAnchor.constraint(equalTo: window.leadingAnchor),
                settingsShortcut.trailingAnchor.constraint(equalTo: window.trailingAnchor),
                settingsShortcut.topAnchor.constraint(equalTo: locationLabel.bottomAnchor, constant: padding),
                settingsShortcut.heightAnchor.constraint(equalToConstant: buttonHeight),
            ])
            
            UIView.animate(
                withDuration: 0.5,
                delay: 0,
                options: .curveEaseOut,
                animations: {
                    self.fadeView.alpha = Constants.fadeViewAlpha
                    self.locationView.center.y -= yOffset
                    self.dismissButton.center.y -= yOffset
                    self.locationLabel.center.y -= yOffset
                    self.settingsShortcut.center.y -= yOffset
            },
                completion: nil)
        }
    }
    
    @objc private func dismissLocationManager(sender: UISwipeGestureRecognizer) {
        let window = UIApplication.shared.windows.first { $0.isKeyWindow }
        
        if let window = window {
            let yOffset = window.frame.height
            
            UIView.animate(
                withDuration: 0.3,
                delay: 0,
                options: .curveEaseIn,
                animations: {
                    self.fadeView.alpha = 0
                    self.locationView.center.y += yOffset
                    self.dismissButton.center.y += yOffset
                    self.locationLabel.center.y += yOffset
                    self.settingsShortcut.center.y += yOffset
            },
                completion: { _ in
                    self.fadeView.removeFromSuperview()
                    self.locationView.removeFromSuperview()
                    self.dismissButton.removeFromSuperview()
                    self.locationLabel.removeFromSuperview()
                    self.settingsShortcut.removeFromSuperview()
            })
        }
        if modeSelected == .newEntryMode {
            newLocationDelegate.didSelectLocation(location: locationString)
        } else if modeSelected == .editEntryMode {
            editLocationDelegate.didEditLocation(location: locationString)
        }
    }
}

extension LocationManager: CLLocationManagerDelegate {
    func requestLocationAuthorization() {
        let authorizationStatus = CLLocationManager.authorizationStatus()

        switch authorizationStatus {
        case .notDetermined:
            locationManager.requestWhenInUseAuthorization()
            return
        case .denied, .restricted:
            return
        case .authorizedAlways, .authorizedWhenInUse:
            return
        @unknown default:
            break
        }
    }
    
    func requestLocation() {
        let connectionAvailable = Reachability.checkReachable()
        if connectionAvailable == true {
            locationManager.requestLocation()
        } else if connectionAvailable == false {
            locationLabel.text = "There is no internet connection. Reconnect, close tab and try again."
        }
    }
    
    func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
        switch status {
        case .notDetermined:
            locationAuthorizationReceived = false
            locationManager.requestWhenInUseAuthorization() // location permission not asked for yet
        case .authorizedWhenInUse, .authorizedAlways:
            locationAuthorizationReceived = true
        case .restricted, .denied:
            locationAuthorizationReceived = false
            locationLabel.text = "'Bits needs authorization to get a location. Press button if you would like to go to settings."
            showSettingShortcut()
        @unknown default:
            fatalError("Fatal Error")
        }
    }
    
    // Called if we ask for a location fix, but cannot obtain one
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        guard let error = error as? CLError else {
            return
        }
        
        switch error.code {
        case .locationUnknown:
            locationLabel.text = "Unable to obtain a location value"
        case .network:
            locationLabel.text = "Check your internet connection. Close tab and try again."
        case .denied:
            locationLabel.text = "Access to the location service was denied. 'Bits needs authorization to get a location. Press button if you would like to go to settings."
            showSettingShortcut()
        default:
            return
        }
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        guard let location = locations.first else {
            print("Could not find location")
            return
        }
        locationLabel.text = "Location coordinate: \(location)"
        getLocationName(location: location)
        
    }
    
    private func getLocationName(location: CLLocation) {
        locationLabel.text = "Getting name for coordinate"
        let geographicCoder = CLGeocoder()
        
        geographicCoder.reverseGeocodeLocation(location) { (placemark, error) in
            guard error == nil else {
                self.locationLabel.text = "Could not convert coordinates into a location name"
                return
            }
            
            guard let placemark = placemark?.first else {
                print("Could not obtain placemark")
                return
            }
            
            guard let street = placemark.thoroughfare else {
                print("Could not obtain street")
                return
            }
            
            guard let city = placemark.locality else {
                print("Could not obtain street")
                return
            }
            
            let locationName = "\(street), \(city)"
            self.locationLabel.text = locationName
            self.locationString = locationName
        }
    }
}
