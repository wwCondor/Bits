//
//  Alerts.swift
//  'Bits
//
//  Created by Wouter Willebrands on 18/10/2019.
//  Copyright © 2019 Studio Willebrands. All rights reserved.
//

import UIKit

extension NewEntryController {

    func errorAlert(description: String) {

        let alert = UIAlertController(title: "Woops!", message: description, preferredStyle: .alert)

        let confirm = UIAlertAction(title: "Confirm", style: .default) {
            (action) in alert.dismiss(animated: true, completion: nil)
        }

        alert.addAction(confirm)
        self.present(alert, animated: true, completion: nil)
    }
}

extension EditEntryController {

    func errorAlert(description: String) {

        let alert = UIAlertController(title: "Woops!", message: description, preferredStyle: .alert)

        let confirm = UIAlertAction(title: "Confirm", style: .default) {
            (action) in alert.dismiss(animated: true, completion: nil)
        }

        alert.addAction(confirm)
        self.present(alert, animated: true, completion: nil)
    }
}
