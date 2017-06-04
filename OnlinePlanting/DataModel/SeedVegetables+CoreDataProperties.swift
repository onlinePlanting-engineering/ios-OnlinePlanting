//
//  SeedVegetables+CoreDataProperties.swift
//  OnlinePlanting
//
//  Created by IBM on 02/06/2017.
//  Copyright © 2017 onlinePlanting. All rights reserved.
//

import Foundation
import CoreData


extension SeedVegetables {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<SeedVegetables> {
        return NSFetchRequest<SeedVegetables>(entityName: "SeedVegetables")
    }

    @NSManaged public var url: String?
    @NSManaged public var name: String?
    @NSManaged public var categroyName: SeedCategories?
    @NSManaged public var vegmetas: NSSet?

}

// MARK: Generated accessors for vegmetas
extension SeedVegetables {

    @objc(addVegmetasObject:)
    @NSManaged public func addToVegmetas(_ value: SeedVegetablesMeta)

    @objc(removeVegmetasObject:)
    @NSManaged public func removeFromVegmetas(_ value: SeedVegetablesMeta)

    @objc(addVegmetas:)
    @NSManaged public func addToVegmetas(_ values: NSSet)

    @objc(removeVegmetas:)
    @NSManaged public func removeFromVegmetas(_ values: NSSet)

}
