//
//  CoreDataManager.swift
//  'Bits
//
//  Created by Wouter Willebrands on 04/12/2019.
//  Copyright © 2019 Studio Willebrands. All rights reserved.
//

//import Foundation
//import CoreData
//
//class CoreDataManager {
//    
//    static let manager = CoreDataManager()
//    
//    lazy var managedObjectContext: NSManagedObjectContext = {
//        let container = self.persistentContainer
//        return container.viewContext
//    }()
//
//    // NSPersistentContainer: A container that encapsulates the Core Data stack in your app.
//    private lazy var persistentContainer: NSPersistentContainer = {
//
//        let container = NSPersistentContainer(name: "Bits") // Needs to match with dataModel name, otherwise the stack cannot find it
//        container.loadPersistentStores(completionHandler: { (storeDescription, error) in
//            if let error = error as NSError? {
//
//                fatalError("Unresolved error \(error), \(error.userInfo)")
//            }
//        })
//        return container
//    }()
//}
//
//extension NSManagedObjectContext {
//    func saveChanges() {
//        if self.hasChanges {
//            do {
//                try save()
//            } catch {
//                fatalError("Error: \(error.localizedDescription)")
//                // Title is too long
//                // Title is too short for editing mode
//            }
//        }
//    }
//}
