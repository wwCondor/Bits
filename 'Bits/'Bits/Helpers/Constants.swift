//
//  Constants.swift
//  'Bits
//
//  Created by Wouter Willebrands on 25/11/2019.
//  Copyright © 2019 Studio Willebrands. All rights reserved.
//

import UIKit

struct Constants {
    static let cellHeight: CGFloat            = 180
    static let buttonBarHeight: CGFloat       = 60 // height of buttons/buttonbars
    static let thumbNailSize: CGFloat         = 60 // savedEntryImage thumbnail size
    static let imageSize: CGFloat             = 120 // imageSize for new- and editEntry screens
    
    static let contentPadding: CGFloat        = 16 // used for side padding
    static let cellSpacing: CGFloat           = 12 // spacing between saved entry cells
    static let cellContentSpacing: CGFloat    = 8
    static let textInset: CGFloat             = 2 // Inset for cell content
    static let largeTextInset: CGFloat        = 6
    static let thumbnailCornerRadius: CGFloat = 5
    static let imageCornerRadius: CGFloat     = 10
    
    static let fadeViewAlpha: CGFloat = 0.4
    
    static let squareImageSize: Double = Double(imageSize)
}

struct NotificationKey {
    static let updateEntriesNotificationKey = "updateEntries"
}
