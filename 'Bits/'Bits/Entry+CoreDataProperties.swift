//
//  Entry+CoreDataProperties.swift
//  'Bits
//
//  Created by Wouter Willebrands on 16/10/2019.
//  Copyright © 2019 Studio Willebrands. All rights reserved.
//
//

import Foundation
import CoreData


extension Entry {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Entry> {
        let request = NSFetchRequest<Entry>(entityName: "Entry")
        
        request.sortDescriptors = [NSSortDescriptor(key: "title", ascending: true)]
        
        
        return request
    }
    
    @NSManaged public var title: String
//    @NSManaged public var date: Date?
    @NSManaged public var story: String
//    @NSManaged public var location: String

}
