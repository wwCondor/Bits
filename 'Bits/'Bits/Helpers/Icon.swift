//
//  Icon.swift
//  'Bits
//
//  Created by Wouter Willebrands on 25/11/2019.
//  Copyright © 2019 Studio Willebrands. All rights reserved.
//

import Foundation

enum Icon {
    case bitsThumb
    case addIcon
    case saveIcon
    case cancelIcon
    case deleteIcon
    case searchIcon
    case ascendingIcon
    case descendingIcon
    case dismissIcon
    
    case locationIcon // not used yet
    case settingsIcon
    
    var image: String {
        switch self {
        case .bitsThumb:        return "BitsThumb"
        case .addIcon:          return "AddIcon"
        case .saveIcon:         return "SaveIcon"
        case .cancelIcon:       return "CancelIcon"
        case .deleteIcon:       return "DeleteIcon"
        case .ascendingIcon:    return "AscendingIcon"
        case .descendingIcon:   return "DescendingIcon"
        case .dismissIcon:      return "DismissIcon"
        case .locationIcon:     return "LocationIcon"
        case .settingsIcon:     return "SettingsIcon"
        case .searchIcon:       return "SearchIcon"
        }
    }
}
