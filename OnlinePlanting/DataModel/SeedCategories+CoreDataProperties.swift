//
//  SeedCategories+CoreDataProperties.swift
//  OnlinePlanting
//
//  Created by IBM on 02/06/2017.
//  Copyright © 2017 onlinePlanting. All rights reserved.
//

import Foundation
import CoreData


extension SeedCategories {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<SeedCategories> {
        return NSFetchRequest<SeedCategories>(entityName: "SeedCategories")
    }

    @NSManaged public var url: String?
    @NSManaged public var name: String?
    @NSManaged public var vegetables: NSSet?

}

// MARK: Generated accessors for vegetables
extension SeedCategories {

    @objc(addVegetablesObject:)
    @NSManaged public func addToVegetables(_ value: SeedVegetables)

    @objc(removeVegetablesObject:)
    @NSManaged public func removeFromVegetables(_ value: SeedVegetables)

    @objc(addVegetables:)
    @NSManaged public func addToVegetables(_ values: NSSet)

    @objc(removeVegetables:)
    @NSManaged public func removeFromVegetables(_ values: NSSet)

}
