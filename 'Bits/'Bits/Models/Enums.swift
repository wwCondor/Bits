//
//  MenuOptions.swift
//  'Bits
//
//  Created by Wouter Willebrands on 12/10/2019.
//  Copyright © 2019 Studio Willebrands. All rights reserved.
//

import Foundation

enum MenuOptions {
    case sortEntry
    case newEntry
    case shareEntry
}


//enum SortOptions {
//    case sortByTitle
//    case sortByData
//}


// Adding a little bit of typesafety to the colors
enum Color: String {
    case suitUpSilver = "SuitUpSilver"
    case washedWhite = "WashedWhite"
    case bowtieBlack = "BowtieBlack"
    case gentlemanGray = "GentlemanGray"
    case cufflinkCream = "CufflinkCream"
    case roseRed = "RoseRed"
}

enum Icon: String {
    case addIcon = "AddIcon"
    case saveIcon = "FloppyIcon"
    case cancelIcon = "CancelIcon"
    case deleteIcon = "DeleteIcon"
    case sortIcon = "SortIcon"
}
