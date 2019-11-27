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
    
    func getCurrentDate() -> String {
        let date = Date()
        let formatter = DateFormatter()
        formatter.dateFormat = "dd.MM.yyyy"
        let dateString = formatter.string(from: date)
        return dateString
    }

    lazy var dateSelected: String = getCurrentDate()
    
    lazy var datePicker: UIDatePicker = {
        let datePicker = UIDatePicker()
        datePicker.backgroundColor = ColorConstants.entryObjectBackground
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
        
    func presentDatePicker() {
        
        let window = UIApplication.shared.windows.first { $0.isKeyWindow } // handles deprecated warning for multiple screens

        if let window = window {

            window.addSubview(fadeView)
            window.addSubview(datePicker)
            window.addSubview(dismissButton)
            
            fadeView.frame = window.frame
            fadeView.alpha = 0
            fadeView.backgroundColor = UIColor.black
            fadeView.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(dismissDatePicker(sender:))))

            let viewWidth = window.frame.width
            let pickerViewHeight = window.frame.height / 2 - Constants.buttonBarHeight
            let yOffset: CGFloat = window.frame.height
            datePicker.frame = CGRect(x: 0, y: yOffset, width: viewWidth, height: pickerViewHeight)
            
            let buttonHeight = Constants.buttonBarHeight
            dismissButton.frame = CGRect(x: 0, y: yOffset, width: viewWidth, height: buttonHeight)
            
            UIView.animate(
                withDuration: 0.5,
                delay: 0,
                options: .curveEaseOut,
                animations: {
                    self.fadeView.alpha = Constants.fadeViewAlpha
                    self.datePicker.center.y -= self.datePicker.bounds.height
                    self.dismissButton.center.y -= self.datePicker.bounds.height

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
        UIView.animate(
            withDuration: 0.3,
            delay: 0,
            options: .curveEaseIn,
            animations: {
                self.fadeView.alpha = 0
                self.datePicker.center.y += self.datePicker.bounds.height
                self.dismissButton.center.y += self.datePicker.bounds.height
        },
            completion: nil)
        
    }
    
    override init() {
        super.init()
    }
}
