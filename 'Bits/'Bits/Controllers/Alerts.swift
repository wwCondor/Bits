//
//  Alerts.swift
//  'Bits
//
//  Created by Wouter Willebrands on 18/10/2019.
//  Copyright © 2019 Studio Willebrands. All rights reserved.
//

import UIKit


struct Alerts {
    
    static func presentAlert(description: String, viewController: UIViewController) {
        
        let alert = UIAlertController(title: "Woops!", message: description, preferredStyle: .alert)
        
        let confirmation = UIAlertAction(title: "OK", style: .default) {
            (action) in alert.dismiss(animated: true, completion: nil)
        }
        
//        alert.view.layoutIfNeeded() // MARK: Added
        alert.addAction(confirmation)
        viewController.present(alert, animated: true, completion: nil)
    }
}
