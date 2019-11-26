//
//  EntryLabel.swift
//  'Bits
//
//  Created by Wouter Willebrands on 25/11/2019.
//  Copyright © 2019 Studio Willebrands. All rights reserved.
//

import UIKit

class EntryTextField: UITextField {
        
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupViews()
        additionalSetup()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        setupViews()
        additionalSetup()
    }
    
    override func textRect(forBounds bounds: CGRect) -> CGRect {
        return bounds.insetBy(dx: Constants.largeTextInset, dy: 0) 
    }
    
    override func editingRect(forBounds bounds: CGRect) -> CGRect {
        return bounds.insetBy(dx: Constants.largeTextInset, dy: 0)
    }
    
    func setupViews() {
        backgroundColor = ColorConstants.entryObjectBackground
        textColor = ColorConstants.tintColor
        textAlignment = .left
        translatesAutoresizingMaskIntoConstraints = false
    }
    
    func additionalSetup() {
        font = UIFont.systemFont(ofSize: 13.0, weight: .light)
    }
}

class  TitleTextField: EntryTextField {
    override func additionalSetup() {
        font = UIFont.systemFont(ofSize: 14.0, weight: .bold)
    }
}
