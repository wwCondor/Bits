//
//  DatePickerManager.swift
//  'Bits
//
//  Created by Wouter Willebrands on 26/11/2019.
//  Copyright © 2019 Studio Willebrands. All rights reserved.
//

import UIKit

class DatePickerManager: NSObject {
    
    let fadeView = UIView()
    
    lazy var datePickerView: UIView = {
        let datePickerView = UIView()
        datePickerView.backgroundColor = ColorConstants.entryObjectBackground
//        let swipeDownGesture = UISwipeGestureRecognizer(target: self, action: #selector(dismissScoreboard(sender:)))
//        swipeDownGesture.direction = .down
//        datePicker.addGestureRecognizer(swipeDownGesture)
//        datePicker.backgroundColor = UIColor(named: Colors.scoreBoardBG.name)
        datePickerView.translatesAutoresizingMaskIntoConstraints = false
        return datePickerView
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
        
    func presentDatePicker() {
        
        let window = UIApplication.shared.windows.first { $0.isKeyWindow } // handles deprecated warning for multiple screens

        if let window = window {

            window.addSubview(fadeView)
            window.addSubview(datePickerView)
            window.addSubview(dismissButton)
            
            fadeView.frame = window.frame
            fadeView.alpha = 0
            fadeView.backgroundColor = UIColor.black
            fadeView.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(dismissDatePicker(sender:))))

            let viewWidth = window.frame.width
            let pickerViewHeight = window.frame.height / 2 - Constants.buttonBarHeight
            let yOffset: CGFloat = window.frame.height
            datePickerView.frame = CGRect(x: 0, y: yOffset, width: viewWidth, height: pickerViewHeight)
            
            let dismissbuttonHeight = Constants.buttonBarHeight
            dismissButton.frame = CGRect(x: 0, y: yOffset, width: viewWidth, height: dismissbuttonHeight)
            
            UIView.animate(
                withDuration: 0.5,
                delay: 0,
                options: .curveEaseOut,
                animations: {
                    self.fadeView.alpha = Constants.fadeViewAlpha
                    self.datePickerView.center.y -= self.datePickerView.bounds.height
                    self.dismissButton.center.y -= self.datePickerView.bounds.height

            },
                completion: nil)
        }
    }
        
    @objc private func dismissDatePicker(sender: UISwipeGestureRecognizer) {
        UIView.animate(
            withDuration: 0.3,
            delay: 0,
            options: .curveEaseIn,
            animations: {
                self.fadeView.alpha = 0
                self.datePickerView.center.y += self.datePickerView.bounds.height
                self.dismissButton.center.y += self.datePickerView.bounds.height
        },
            completion: nil)
        
    }
    
    override init() {
        super.init()
    }
    
}

class DatePickerView: UIView {
    
    lazy var datePicker: UIDatePicker = {
       let datePicker = UIDatePicker()
       return datePicker
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupViews()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        setupViews()
    }
    
    func setupViews() {
        
    }
    

}
