//
//  Keyboard.swift
//  'Bits
//
//  Created by Wouter Willebrands on 24/10/2019.
//  Copyright © 2019 Studio Willebrands. All rights reserved.
//

import UIKit

//class KeyboardManager {
//
//    static func keyboardWillShow(notification: Notification, textField: UITextField, rootView: UIView) {
//        var firstResponderFrame = textField.frame
//        // Convert first responder frame to global coordinates if it is a nested subview
//        if let firstResponderSuperView = textField.superview, firstResponderSuperView != rootView {
//            firstResponderFrame = firstResponderSuperView.convert(textField.frame, to: rootView)
//        }
//
//        // Move view so text field is not hidden by the software keyboard
//        if let info = notification.userInfo, let keyboardFrame = info[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue {
//            let frame = keyboardFrame.cgRectValue
//            if frame.intersects(firstResponderFrame) {
//                rootView.frame.origin.y = -frame.size.height
//            }
//        }
//    }
//
//    static func keyboardWillHide(notification: Notification, rootView: UIView) {
//        // Move view back to the origin
//        rootView.frame.origin.y = 0
//    }
//}

extension UIViewController {
    func hideKeyboardWhenTappedAround() {
        let tap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(UIViewController.dismissKeyboard))
        tap.cancelsTouchesInView = false
        view.addGestureRecognizer(tap)
    }

    @objc func dismissKeyboard() {
        view.endEditing(true)
    }
}
