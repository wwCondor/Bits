//
//  FetchedResultsController.swift
//  'Bits
//
//  Created by Wouter Willebrands on 18/10/2019.
//  Copyright © 2019 Studio Willebrands. All rights reserved.
//

import UIKit
import CoreData

class FetchedResultsController: NSFetchedResultsController<Entry> { 
    // Object responsible for performing fetch on the entries
    private let collectionView: UICollectionView
    
    init(managedObjectContext: NSManagedObjectContext, collectionView: UICollectionView, request: NSFetchRequest<Entry>) {
        self.collectionView = collectionView
        super.init(fetchRequest: request, managedObjectContext: managedObjectContext, sectionNameKeyPath: nil, cacheName: nil)

        tryFetch()
    }  
    
    func tryFetch() {
        do {
            try performFetch()
        } catch {
            print("Unresolved error: \(error.localizedDescription)")
        }
    }
}
