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

enum ConnectionError: Error {
    case noInternet
}

extension ConnectionError: LocalizedError {
    public var localizedDescription: String {
        switch self {
        case .noInternet:               return "Seems there is no connection. Reconnect and try again"
        }
    }
}

enum EntryErrors: Error {
    case titleEmpty
    case storyEmpty
    case dateEmpty
    case locationEmpty
    case photoEmpty
    case sortNotYetImplented
    case entryNil
    case noPhotos
    case noLocationAuthorization
    case noPhotoAuthorization
    case unknownAuthorizationError
}

extension EntryErrors: LocalizedError {
    public var localizedDescription: String {
        switch self {
        case .titleEmpty:                   return "It seems you've forgot to enter a title"
        case .storyEmpty:                   return "It seems the story content of your current entry is emptry"
        case .dateEmpty:                    return "It seems you haven't entered a date"
        case .locationEmpty:                return "It seems you haven't entered a location"
        case .photoEmpty:                   return "It seems no photo has been selected"
        case .sortNotYetImplented:          return "Sort by date has not been implemented yet. Currently sorted by entry title"
        case .entryNil:                     return "It seems there is no entry"
        case .noPhotos:                     return "It seems you have no photos stored on your phone"
        case .noLocationAuthorization:      return "Location authorization can be changed in phone settings. Would you like to go to settings?"
        case .noPhotoAuthorization:         return "Photo access authorization can be changed in phone settings. Would you like to go to settings?"
        case .unknownAuthorizationError:    return "An unknown error authorization error has occurred"
        }
    }
}

enum LocationError: Error {
    case unknownError
    case notAllowedByUser
    case unableToFindLocation
    case changeSettings
}

extension LocationError: LocalizedError {
    public var localizedDescription: String {
        switch self {
        case .unknownError:             return "Unknown Error"
        case .notAllowedByUser:         return "Location services are not allowed by user. 'Bits can't be used without this."
        case .unableToFindLocation:     return "Unable to find location"
        case .changeSettings:           return "Location permissions can be changed in phone settings. Would you like to go to settings?"
        }
    }
}
