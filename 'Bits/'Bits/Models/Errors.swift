//
//  Errors.swift
//  'Bits
//
//  Created by Wouter Willebrands on 18/10/2019.
//  Copyright © 2019 Studio Willebrands. All rights reserved.
//

import Foundation

enum NewEntryError: Error {
    case titleMissing
    case missingStory
}

extension NewEntryError: LocalizedError {
    public var localizedDescription: String {
        switch self {
        case .titleMissing: return "Woops! It seems you've forgot to enter a title."
        case .missingStory: return "Woops! It seems you're trying too save an empty story"
        }
    }
}
