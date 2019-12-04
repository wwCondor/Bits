//
//  FetchedResultsController.swift
//  'Bits
//
//  Created by Wouter Willebrands on 18/10/2019.
//  Copyright © 2019 Studio Willebrands. All rights reserved.
//

import UIKit
import CoreData

// Object responsible for performing fetch on the entries
class FetchedResultsController: NSFetchedResultsController<Entry>, NSFetchedResultsControllerDelegate {
    
    private let collectionView: UICollectionView
    
    init(managedObjectContext: NSManagedObjectContext, collectionView: UICollectionView) {
        self.collectionView = collectionView
        super.init(fetchRequest: Entry.fetchRequest(), managedObjectContext: managedObjectContext, sectionNameKeyPath: nil, cacheName: nil)
        
        self.delegate = self
        
        tryFetch()
    }
    
    func tryFetch() {
        do {
            try performFetch()
        } catch {
            print("Unresolved error: \(error.localizedDescription)")
        }
    }
    
    
    
    
//    func controllerWillChangeContent(_ controller: NSFetchedResultsController<NSFetchRequestResult>) {
//        collectionView.reloadData()
//    }
    
    // Depending on the type of change that occured we perform a certain action
    // Adding this method also implements an animation on the specific change
    func controller(_ controller: NSFetchedResultsController<NSFetchRequestResult>, didChange anObject: Any, at indexPath: IndexPath?, for type: NSFetchedResultsChangeType, newIndexPath: IndexPath?) {
        switch type {
        case .insert:
            guard let newIndexPath = newIndexPath else { return }
            collectionView.performBatchUpdates({
                collectionView.insertItems(at: [newIndexPath])
            }, completion: {
                (finished: Bool) in
                self.collectionView.reloadItems(at: self.collectionView.indexPathsForVisibleItems)
            })
        case .delete:
            guard let indexPath  = indexPath else { return }
            collectionView.performBatchUpdates({
                collectionView.deleteItems(at: [indexPath])
            }, completion: {
                (finished: Bool) in
                self.collectionView.reloadItems(at: self.collectionView.indexPathsForVisibleItems)
            })
        case .update, .move:
            guard let indexPath = indexPath else { return }
            collectionView.performBatchUpdates({
                collectionView.reloadItems(at: [indexPath])
            }, completion: {
                (finished: Bool) in
                self.collectionView.reloadItems(at: self.collectionView.indexPathsForVisibleItems)
            }) // Not adding this seems to cause glitches switching between edit en new entry mode
        @unknown default:
            return
        }
    }
    
//    func controllerDidChangeContent(_ controller: NSFetchedResultsController<NSFetchRequestResult>) {
//        collectionView.reloadData()
//    }
    
}
