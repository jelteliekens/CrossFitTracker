//
//  PersistedMovement+CoreDataProperties.swift
//  CrossFitTracker
//
//  Created by Jelte Liekens on 17/02/2017.
//  Copyright © 2017 Jelte Liekens. All rights reserved.
//

import Foundation
import CoreData

extension PersistedMovement {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<PersistedMovement> {
        return NSFetchRequest<PersistedMovement>(entityName: "PersistedMovement")
    }

    @NSManaged public var image: String?
    @NSManaged public var name: String
    @NSManaged public var unique: Int32
}
