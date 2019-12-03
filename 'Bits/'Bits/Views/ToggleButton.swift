//
//  ToggleButton.swift
//  'Bits
//
//  Created by Wouter Willebrands on 03/12/2019.
//  Copyright © 2019 Studio Willebrands. All rights reserved.
//

import UIKit

class ToggleButton: UIButton {
    var isOn = false
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupButton()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        setupButton()
    }
    
    func setupButton() {
        
    }
    
    @objc func toggleState() {
        
    }
    
    private func activateButton(bool: Bool) {
        isOn = bool
        
        
    }
}
