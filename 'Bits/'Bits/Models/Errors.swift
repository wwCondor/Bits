//
//  Errors.swift
//  'Bits
//
//  Created by Wouter Willebrands on 18/10/2019.
//  Copyright © 2019 Studio Willebrands. All rights reserved.
//

import Foundation

//enum EditEntryError: Error {
//    case titleMissing
//    case missingStory
//}
//
//extension EditEntryError: LocalizedError {
//    public var localizedDescription: String {
//        switch self {
//        case .titleMissing: return "Woops! It seems you've forgot to enter a title."
//        case .missingStory: return "Woops! It seems you're trying too save an empty story"
//        }
//    }
//}


enum EntryErrors: Error {
    case titleEmpty
    case storyEmpty
    case dateEmpty
    case sortNotYetImplented
    case entryNil

}

extension EntryErrors: LocalizedError {
    public var localizedDescription: String {
        switch self {
        case .titleEmpty: return "It seems you've forgot to enter a title"
        case .storyEmpty: return "It seems the story content of your current entry is emptry"
        case .dateEmpty: return "It seems you haven't entered a date"
        case .sortNotYetImplented: return "Sort by date has not been implemented yet. Currently sorted by entry title"
        case .entryNil: return "It seems there is no entry"

        }
    }
}


