//
//  LocationManager.swift
//  'Bits
//
//  Created by Wouter Willebrands on 26/11/2019.
//  Copyright © 2019 Studio Willebrands. All rights reserved.
//

import UIKit

class LocationManager: NSObject {
    
    let fadeView = UIView()
    
    lazy var locationView: UIView = {
        let locationView = UIView()
        locationView.backgroundColor = ColorConstants.entryObjectBackground
//        let swipeDownGesture = UISwipeGestureRecognizer(target: self, action: #selector(dismissScoreboard(sender:)))
//        swipeDownGesture.direction = .down
//        datePicker.addGestureRecognizer(swipeDownGesture)
//        datePicker.backgroundColor = UIColor(named: Colors.scoreBoardBG.name)
        locationView.translatesAutoresizingMaskIntoConstraints = false
        return locationView
    }()
    
    lazy var dismissButton: CustomButton = {
        let dismissButton = CustomButton(type: .custom)
        let image = UIImage(named: Icon.cancelIcon.image)!.withRenderingMode(.alwaysTemplate)
        dismissButton.setImage(image, for: .normal)
        let inset: CGFloat = 14
        dismissButton.imageEdgeInsets = UIEdgeInsets(top: inset, left: inset, bottom: inset, right: inset)
        dismissButton.addTarget(self, action: #selector(dismissLocationManager(sender:)), for: .touchUpInside)
        return dismissButton
    }()
        
    func presentLocationManager() {
        
        let window = UIApplication.shared.windows.first { $0.isKeyWindow } // handles deprecated warning for multiple screens

        if let window = window {

            window.addSubview(fadeView)
            window.addSubview(locationView)
            window.addSubview(dismissButton)
            
            fadeView.frame = window.frame
            fadeView.alpha = 0
            fadeView.backgroundColor = UIColor.black
            fadeView.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(dismissLocationManager(sender:))))

            let viewWidth = window.frame.width
            let pickerViewHeight = window.frame.height / 2 - Constants.buttonBarHeight
            let yOffset: CGFloat = window.frame.height
            locationView.frame = CGRect(x: 0, y: yOffset, width: viewWidth, height: pickerViewHeight)
            
            let dismissbuttonHeight = Constants.buttonBarHeight
            dismissButton.frame = CGRect(x: 0, y: yOffset, width: viewWidth, height: dismissbuttonHeight)
            
            UIView.animate(
                withDuration: 0.5,
                delay: 0,
                options: .curveEaseOut,
                animations: {
                    self.fadeView.alpha = Constants.fadeViewAlpha
                    self.locationView.center.y -= self.locationView.bounds.height
                    self.dismissButton.center.y -= self.locationView.bounds.height

            },
                completion: nil)
        }
    }
        
    @objc private func dismissLocationManager(sender: UISwipeGestureRecognizer) {
        UIView.animate(
            withDuration: 0.3,
            delay: 0,
            options: .curveEaseIn,
            animations: {
                self.fadeView.alpha = 0
                self.locationView.center.y += self.locationView.bounds.height
                self.dismissButton.center.y += self.locationView.bounds.height
        },
            completion: nil)
        
    }
    
    override init() {
        super.init()
    }
    
}
