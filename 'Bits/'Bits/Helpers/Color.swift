//
//  Colors.swift
//  'Bits
//
//  Created by Wouter Willebrands on 25/11/2019.
//  Copyright © 2019 Studio Willebrands. All rights reserved.
//

import UIKit

enum Color {
    case suitUpSilver
    case washedWhite
    case bowtieBlack
    case gentlemanGray
    case grumpyGray
    case cufflinkCream
    case roseRed
    
    var name: String {
        switch self {
        case .suitUpSilver:   return "SuitUpSilver"
        case .washedWhite:    return "WashedWhite"
        case .bowtieBlack:    return "BowtieBlack"
        case .gentlemanGray:  return "GentlemanGray"
        case .grumpyGray:     return "GrumpyGray"
        case .cufflinkCream:  return "CufflinkCream"
        case .roseRed:        return "RoseRed"
        }
    }
}

struct ColorConstants {
    static let appBackgroundColor: UIColor = UIColor(named: Color.roseRed.name)!
    static let buttonMenuColor: UIColor = UIColor(named: Color.bowtieBlack.name)!
    static let tintColor: UIColor = UIColor(named: Color.washedWhite.name)! // also set icon and text
    static let cellBackgroundColor: UIColor = UIColor(named: Color.grumpyGray.name)!
    static let entryObjectBackground: UIColor = UIColor(named: Color.grumpyGray.name)!
    static let labelColor: UIColor = UIColor(named: Color.suitUpSilver.name)!
}
