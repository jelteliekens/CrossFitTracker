//
//  MovementFetchedResultController.swift
//  CrossFitTracker
//
//  Created by Jelte Liekens on 13/02/2017.
//  Copyright © 2017 Jelte Liekens. All rights reserved.
//

import Foundation
import CoreData
import ReactiveSwift
import Result

public enum PagingListChange {
    case insert(IndexPath)
    case delete(IndexPath)
    case update(IndexPath)
    case move(IndexPath, IndexPath)
}

public protocol PagingList {
    var changes: Signal<[PagingListChange], NoError> { get }

    var numberOfSections: Int { get }

    func numberOfItemsInSection(section: Int) -> Int

    func object(at indexPath: IndexPath) -> PersistedMovement
}

public final class MovementFetchedResultController: NSObject, PagingList {

    fileprivate let (signal, observer) = Signal<[PagingListChange], NoError>.pipe()

    public var changes: Signal<[PagingListChange], NoError> {
        return signal
    }

    fileprivate var pagingListChanges = [PagingListChange]()

    fileprivate let managedContext: NSManagedObjectContext

    fileprivate lazy var fetchedResultsController: NSFetchedResultsController<PersistedMovement> = {
        let fetchRequest: NSFetchRequest<PersistedMovement> = PersistedMovement.fetchRequest()
        let sort = NSSortDescriptor(key: #keyPath(PersistedMovement.name), ascending: true)
        fetchRequest.sortDescriptors = [sort]

        let fetchedResultsController = NSFetchedResultsController<PersistedMovement>(
            fetchRequest: fetchRequest,
            managedObjectContext: self.managedContext,
            sectionNameKeyPath: nil,
            cacheName: nil
        )

        fetchedResultsController.delegate = self

        return fetchedResultsController
    }()

    public init(managedContext: NSManagedObjectContext) {
        self.managedContext = managedContext

        super.init()

        do {
            try self.fetchedResultsController.performFetch()
        } catch let error as NSError {
            print("Fetching error: \(error), \(error.userInfo)")
        }
    }
}

// MARK: - PagingList

extension MovementFetchedResultController {
    public var numberOfSections: Int {
        guard let sections = fetchedResultsController.sections else {
            return 0
        }

        return sections.count
    }

    public func numberOfItemsInSection(section: Int) -> Int {
        guard let sectionInfo = fetchedResultsController.sections?[section] else {
            return 0
        }

        return sectionInfo.numberOfObjects
    }

    public func object(at indexPath: IndexPath) -> PersistedMovement {
        return fetchedResultsController.object(at: indexPath) as PersistedMovement
    }
}

// MARK: - NSFetchedResultsControllerDelegate

extension MovementFetchedResultController: NSFetchedResultsControllerDelegate {
    public func controllerWillChangeContent(_ controller: NSFetchedResultsController<NSFetchRequestResult>) {
        pagingListChanges = [PagingListChange]()
    }

    public func controller(_ controller: NSFetchedResultsController<NSFetchRequestResult>,
                           didChange anObject: Any,
                           at indexPath: IndexPath?,
                           for type: NSFetchedResultsChangeType,
                           newIndexPath: IndexPath?) {
        var pagingListChange: PagingListChange

        switch type {
        case .insert:
            pagingListChange = .insert(newIndexPath!)
        case .update:
            pagingListChange = .update(indexPath!)
        case .delete:
            pagingListChange = .delete(indexPath!)
        case .move:
            pagingListChange = .move(indexPath!, newIndexPath!)
        }

        pagingListChanges.append(pagingListChange)
    }

    public func controllerDidChangeContent(_ controller: NSFetchedResultsController<NSFetchRequestResult>) {
        observer.send(value: pagingListChanges)
    }
}
