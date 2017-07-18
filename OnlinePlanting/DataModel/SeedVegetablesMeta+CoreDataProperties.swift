//
//  SeedVegetablesMeta+CoreDataProperties.swift
//  OnlinePlanting
//
//  Created by IBM on 04/06/2017.
//  Copyright © 2017 onlinePlanting. All rights reserved.
//

import Foundation
import CoreData


extension SeedVegetablesMeta {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<SeedVegetablesMeta> {
        return NSFetchRequest<SeedVegetablesMeta>(entityName: "SeedVegetablesMeta")
    }

    @NSManaged public var content: String?
    @NSManaged public var cycle: Int16
    @NSManaged public var desc: String?
    @NSManaged public var etime: String?
    @NSManaged public var is_active: Bool
    @NSManaged public var mature_price: String?
    @NSManaged public var name: String?
    @NSManaged public var output: Float
    @NSManaged public var region: String?
    @NSManaged public var seed_price: String?
    @NSManaged public var stime: String?
    @NSManaged public var url: String?
    @NSManaged public var first_letter: String?
    @NSManaged public var imgs: NSSet?
    @NSManaged public var metaVegetables: SeedVegetables?

}

// MARK: Generated accessors for imgs
extension SeedVegetablesMeta {

    @objc(addImgsObject:)
    @NSManaged public func addToImgs(_ value: ImageURL)

    @objc(removeImgsObject:)
    @NSManaged public func removeFromImgs(_ value: ImageURL)

    @objc(addImgs:)
    @NSManaged public func addToImgs(_ values: NSSet)

    @objc(removeImgs:)
    @NSManaged public func removeFromImgs(_ values: NSSet)

}
