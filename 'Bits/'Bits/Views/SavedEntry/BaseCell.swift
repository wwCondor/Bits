//
//  BaseCell.swift
//  'Bits
//
//  Created by Wouter Willebrands on 25/11/2019.
//  Copyright © 2019 Studio Willebrands. All rights reserved.
//

import UIKit

// The superclass for cells
class BaseCell: UICollectionViewCell {
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupViews()
    }
    
    func setupViews() { }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        setupViews()
    }
}
