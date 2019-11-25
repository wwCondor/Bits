//
//  DeleteLabel.swift
//  'Bits
//
//  Created by Wouter Willebrands on 25/11/2019.
//  Copyright © 2019 Studio Willebrands. All rights reserved.
//

import UIKit

class DeleteLabel: UILabel {
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupViews()
    }
    
    func setupViews() {
        text = "Delete"
        font = UIFont.systemFont(ofSize: 16.0, weight: .heavy)
        textColor = ColorConstants.tintColor
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        setupViews()
    }
}
