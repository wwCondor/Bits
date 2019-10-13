//
//  BaseCell.swift
//  'Bits
//
//  Created by Wouter Willebrands on 11/10/2019.
//  Copyright © 2019 Studio Willebrands. All rights reserved.
//

import UIKit

// The superclass from which all other cells inherit 
class BaseCell: UICollectionViewCell {
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupViews()
    }
    
    func setupViews() {
        
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
}
