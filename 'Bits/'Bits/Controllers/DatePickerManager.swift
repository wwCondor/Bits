//
//  DatePickerManager.swift
//  'Bits
//
//  Created by Wouter Willebrands on 26/11/2019.
//  Copyright © 2019 Studio Willebrands. All rights reserved.
//

import UIKit

protocol NewDateDelegate {
    func didSelectDate(date: String)
}

protocol EditDateDelegate {
    func didEditDate(date: String)
}

class DatePickerManager: NSObject {
    
    var newDateDelegate: NewDateDelegate!
    var editDateDelegate: EditDateDelegate!
    
    let fadeView = UIView()
    var modeSelected: ModeSelected = .newEntryMode
    
    lazy var dateSelected: String = getCurrentDate()
    
    lazy var datePickerBackgroundView: UIView = {
        let datePickerBackgroundView = UIView()
        datePickerBackgroundView.backgroundColor = ColorConstants.entryObjectBackground
        datePickerBackgroundView.translatesAutoresizingMaskIntoConstraints = false
        return datePickerBackgroundView
    }()
    
    lazy var datePicker: UIDatePicker = {
        let datePicker = UIDatePicker()
        datePicker.backgroundColor = UIColor.systemTeal
        datePicker.setValue(ColorConstants.tintColor, forKey: "textColor")
        datePicker.calendar = .current
        datePicker.datePickerMode = .date
        datePicker.addTarget(self, action: #selector(dateChanged(datePicker:)), for: .valueChanged)
        let calendar = Calendar(identifier: .gregorian)
        var components = DateComponents()
        components.year = 100
        let maxDate = calendar.date(byAdding: components, to: Date())
        components.year = -100
        let minDate = calendar.date(byAdding: components, to: Date())
        datePicker.minimumDate = minDate
        datePicker.maximumDate = maxDate
        datePicker.timeZone = NSTimeZone.local
        datePicker.translatesAutoresizingMaskIntoConstraints = false
        return datePicker
    }()
    
    lazy var dismissButton: CustomButton = {
        let dismissButton = CustomButton(type: .custom)
        let image = UIImage(named: Icon.cancelIcon.image)!.withRenderingMode(.alwaysTemplate)
        dismissButton.setImage(image, for: .normal)
        let inset: CGFloat = 14
        dismissButton.imageEdgeInsets = UIEdgeInsets(top: inset, left: inset, bottom: inset, right: inset)
        dismissButton.addTarget(self, action: #selector(dismissDatePicker(sender:)), for: .touchUpInside)
        return dismissButton
    }()

    @objc func dateChanged(datePicker: UIDatePicker) {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "dd.MM.yyyy"
        print(dateFormatter.string(from: datePicker.date))
        dateSelected = dateFormatter.string(from: datePicker.date)
    }
    
    private func getCurrentDate() -> String {
        let date = Date()
        let formatter = DateFormatter()
        formatter.dateFormat = "dd.MM.yyyy"
        let dateString = formatter.string(from: date)
        return dateString
    }
        
    func presentDatePicker() {
        
        let window = UIApplication.shared.windows.first { $0.isKeyWindow } // handles deprecated warning for multiple screens

        if let window = window {

            window.addSubview(fadeView)
            window.addSubview(datePickerBackgroundView)
            window.addSubview(datePicker)
            window.addSubview(dismissButton)
            
            fadeView.frame = window.frame
            fadeView.alpha = 0
            fadeView.backgroundColor = UIColor.black
            fadeView.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(dismissDatePicker(sender:))))
            
            let buttonHeight = Constants.buttonBarHeight
            let padding = Constants.contentPadding
            let yOffset = window.frame.height
            let pickerHeight = window.frame.height / 4

            NSLayoutConstraint.activate([
                datePickerBackgroundView.leadingAnchor.constraint(equalTo: window.leadingAnchor),
                datePickerBackgroundView.trailingAnchor.constraint(equalTo: window.trailingAnchor),
                datePickerBackgroundView.topAnchor.constraint(equalTo: window.centerYAnchor, constant: buttonHeight),
                datePickerBackgroundView.bottomAnchor.constraint(equalTo: window.bottomAnchor),

                dismissButton.leadingAnchor.constraint(equalTo: window.leadingAnchor),
                dismissButton.trailingAnchor.constraint(equalTo: window.trailingAnchor),
                dismissButton.topAnchor.constraint(equalTo: datePickerBackgroundView.topAnchor),
                dismissButton.heightAnchor.constraint(equalToConstant: buttonHeight),

                datePicker.leadingAnchor.constraint(equalTo: window.leadingAnchor, constant: padding),
                datePicker.trailingAnchor.constraint(equalTo: window.trailingAnchor, constant: -padding),
                datePicker.topAnchor.constraint(equalTo: dismissButton.bottomAnchor, constant: padding),
                datePicker.heightAnchor.constraint(equalToConstant: pickerHeight)//,
            ])
            
            UIView.animate(
                withDuration: 0.5,
                delay: 0,
                options: .curveEaseOut,
                animations: {
                    self.fadeView.alpha = Constants.fadeViewAlpha
                    self.datePickerBackgroundView.center.y -= yOffset
                    self.datePicker.center.y -= yOffset
                    self.dismissButton.center.y -= yOffset
            },
                completion: nil)
        }
    }
        
    @objc private func dismissDatePicker(sender: UISwipeGestureRecognizer) {
        if modeSelected == .newEntryMode {
            newDateDelegate.didSelectDate(date: dateSelected)
        } else if modeSelected == .editEntryMode {
            editDateDelegate.didEditDate(date: dateSelected)
        }
        
        let window = UIApplication.shared.windows.first { $0.isKeyWindow } // handles deprecated warning for multiple screens

        if let window = window {
            let yOffset = window.frame.height
            
            UIView.animate(
                withDuration: 0.3,
                delay: 0,
                options: .curveEaseIn,
                animations: {
                    self.fadeView.alpha = 0
                    self.datePickerBackgroundView.center.y += yOffset
                    self.datePicker.center.y += yOffset
                    self.dismissButton.center.y += yOffset
            },
                completion: { _ in
                    self.fadeView.removeFromSuperview()
                    self.datePickerBackgroundView.removeFromSuperview()
                    self.datePicker.removeFromSuperview()
                    self.dismissButton.removeFromSuperview()
            })
        }
    }
    
    override init() {
        super.init()
    }
}
