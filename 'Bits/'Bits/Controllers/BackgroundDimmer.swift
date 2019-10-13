//
//  BackgroundDimmer.swift
//  'Bits
//
//  Created by Wouter Willebrands on 11/10/2019.
//  Copyright © 2019 Studio Willebrands. All rights reserved.
//

import UIKit

// MARK: Fixme - Can this be separated from the menu
class BackgroundDimmer: UIView {
    
    let dimmedView = UIView() // This is the view that will be used to dim the background

    func dimBackground() {
        
        let window = UIApplication.shared.windows.first { $0.isKeyWindow }
        
        if let window = window {
            
            dimmedView.backgroundColor = UIColor(white: 0, alpha: 0.5)
            dimmedView.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(dismissDimmedView)))
            
            window.addSubview(dimmedView)
            
            dimmedView.frame = window.frame
            dimmedView.alpha = 0
            
            // This anmites the view
            UIView.animate(withDuration: 0.8,
                           delay: 0.0,
                           options: [.curveEaseOut],
                           animations: {
                            self.dimmedView.alpha = 1
            },
                           completion: nil)
            
        }
        
    }
    
    @objc func dismissDimmedView() {
        UIView.animate(withDuration: 0.5) {
            self.dimmedView.alpha = 0
            
        }

    }
}
