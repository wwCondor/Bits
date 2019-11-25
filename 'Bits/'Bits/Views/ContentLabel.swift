//
//  ContentLabel.swift
//  'Bits
//
//  Created by Wouter Willebrands on 25/11/2019.
//  Copyright © 2019 Studio Willebrands. All rights reserved.
//

import UIKit

class ContentLabel: UITextView {
    
    override init(frame: CGRect, textContainer: NSTextContainer?) {
        super.init(frame: frame, textContainer: textContainer)
        setupViews()
    }
    
    func setupViews() {
        isEditable = false
        backgroundColor = ColorConstants.labelColor
        textColor = ColorConstants.tintColor
        let inset: CGFloat = Constants.textInset
        textContainerInset = UIEdgeInsets(top: inset, left: inset, bottom: inset, right: inset)
        translatesAutoresizingMaskIntoConstraints = false
    }
    
    func additionalSetup() {
        font = UIFont.systemFont(ofSize: 10.0, weight: .medium)
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        setupViews()
    }
}

class TitleLabel: ContentLabel {
    override func additionalSetup() {
        font = UIFont.systemFont(ofSize: 14.0, weight: .medium)
    }
}

//let titleLabel: UITextView = {
//    let titleLabel = UITextView()
//    titleLabel.isEditable = false
//    titleLabel.backgroundColor = ColorConstants.labelColor
//    titleLabel.text = "This is the title"
//    titleLabel.font = UIFont.systemFont(ofSize: 14.0, weight: .medium)
//    let inset: CGFloat = 3
//    titleLabel.textContainerInset = UIEdgeInsets(top: inset + 1, left: inset - 1, bottom: inset, right: inset)
//    titleLabel.textColor = ColorConstants.tintColor
//    titleLabel.translatesAutoresizingMaskIntoConstraints = false
//    return titleLabel
//}()
