//
//  ContentTextView.swift
//  'Bits
//
//  Created by Wouter Willebrands on 25/11/2019.
//  Copyright © 2019 Studio Willebrands. All rights reserved.
//

import UIKit

// Used UITexttView instead of UILabel for increased flexibility and customisation
class EntryTextView: UITextView {
    
    override init(frame: CGRect, textContainer: NSTextContainer?) {
        super.init(frame: frame, textContainer: textContainer)
        setupViews()
        additionalSetup()
    }
    
    func setupViews() {
        textColor = ColorConstants.tintColor
        translatesAutoresizingMaskIntoConstraints = false
    }
    
    func additionalSetup() {
        backgroundColor = ColorConstants.labelColor
        font = UIFont.systemFont(ofSize: 13.0, weight: .light)
        isEditable = false
        let inset: CGFloat = Constants.textInset
        textContainerInset = UIEdgeInsets(top: inset, left: inset, bottom: inset, right: inset)
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        setupViews()
        additionalSetup()
    }
}

class TitleTextView: EntryTextView {
    // TextView for cell title
    override func additionalSetup() {
        backgroundColor = ColorConstants.labelColor
        font = UIFont.systemFont(ofSize: 14.0, weight: .bold)
        isEditable = false
        let inset: CGFloat = Constants.textInset
        textContainerInset = UIEdgeInsets(top: inset, left: inset, bottom: inset, right: inset)
    }
}

class StoryTextView: EntryTextView {
    // New/Edit Entry TextView for story input
    override func additionalSetup() {
        backgroundColor = ColorConstants.cellBackgroundColor
        font = UIFont.systemFont(ofSize: 13.0, weight: .light)
        isEditable = true
        let inset: CGFloat = Constants.largeTextInset
        textContainerInset = UIEdgeInsets(top: inset, left: inset, bottom: inset, right: inset)
        textContainer.maximumNumberOfLines = 0
    }
}
