//
//  FetchedResultsController.swift
//  'Bits
//
//  Created by Wouter Willebrands on 18/10/2019.
//  Copyright © 2019 Studio Willebrands. All rights reserved.
//

import UIKit
import CoreData

class FetchedResultsController: NSFetchedResultsController<Entry> { //}, NSFetchedResultsControllerDelegate {
    // Object responsible for performing fetch on the entries
    private let collectionView: UICollectionView
    
    init(managedObjectContext: NSManagedObjectContext, collectionView: UICollectionView, request: NSFetchRequest<Entry>) {
        self.collectionView = collectionView
        super.init(fetchRequest: request, managedObjectContext: managedObjectContext, sectionNameKeyPath: nil, cacheName: nil)
//        super.init(fetchRequest: Entry.fetchRequest(), managedObjectContext: managedObjectContext, sectionNameKeyPath: nil, cacheName: nil)

        
//        self.delegate = self
        
        tryFetch()
    }  
    
    func tryFetch() {
        do {
            try performFetch()
        } catch {
            print("Unresolved error: \(error.localizedDescription)")
        }
    }

//    func controller(_ controller: NSFetchedResultsController<NSFetchRequestResult>, didChange anObject: Any, at indexPath: IndexPath?, for type: NSFetchedResultsChangeType, newIndexPath: IndexPath?) {
//        switch type {
//        case .insert:
//            guard let newIndexPath = newIndexPath else { return }
//            collectionView.performBatchUpdates({
//                collectionView.insertItems(at: [newIndexPath])
//            }, completion: {
//                (finished: Bool) in
//                self.collectionView.reloadItems(at: self.collectionView.indexPathsForVisibleItems)
//            })
//        case .delete:
//            guard let indexPath  = indexPath else { return }
//            collectionView.performBatchUpdates({
//                collectionView.deleteItems(at: [indexPath])
//            }, completion: {
//                (finished: Bool) in
//                self.collectionView.reloadItems(at: self.collectionView.indexPathsForVisibleItems)
//            })
//        case .update, .move:
//            guard let indexPath = indexPath else { return }
//            collectionView.performBatchUpdates({
//                collectionView.reloadItems(at: [indexPath])
//            }, completion: {
//                (finished: Bool) in
//                self.collectionView.reloadItems(at: self.collectionView.indexPathsForVisibleItems)
//            }) // Not adding this seems to cause glitches switching between edit en new entry mode
//        @unknown default:
//            return
//        }
//    }

    
}
