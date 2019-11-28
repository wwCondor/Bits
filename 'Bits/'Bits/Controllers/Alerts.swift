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
        
        let alert = UIAlertController(title: nil, message: description, preferredStyle: .alert)
        
        let confirmation = UIAlertAction(title: "OK", style: .default) {
            (action) in alert.dismiss(animated: true, completion: nil)
        }
        
        alert.addAction(confirmation)
        viewController.present(alert, animated: true, completion: nil)
    }
    
    static func presentFailedPermissionAlert(description: String, viewController: ViewController) {
        let actionSheet = UIAlertController(title: nil, message: description, preferredStyle: .actionSheet)
        
        actionSheet.addAction(UIAlertAction(title: "Yes, take me to Settings", style: .default, handler: { (action) in
            if let settingsURL = URL(string: UIApplication.openSettingsURLString + Bundle.main.bundleIdentifier!) {
                UIApplication.shared.open(settingsURL, options: [:], completionHandler: nil)
            }
        }))
        
        actionSheet.addAction(UIAlertAction(title: "No, thanks.", style: .cancel, handler: { (action) in

        }))
        
        viewController.present(actionSheet, animated: true, completion: nil)

//        let window = UIApplication.shared.windows.first { $0.isKeyWindow }
//
//        if let window = window {
//            window.rootViewController?.present(alertController, animated: true, completion: nil)
//        }
    }
}

