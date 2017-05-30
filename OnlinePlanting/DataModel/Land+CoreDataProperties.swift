//
//  Land+CoreDataProperties.swift
//  OnlinePlanting
//
//  Created by IBM on 29/05/2017.
//  Copyright © 2017 onlinePlanting. All rights reserved.
//

import Foundation
import CoreData


extension Land {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Land> {
        return NSFetchRequest<Land>(entityName: "Land")
    }

    @NSManaged public var id: Int64
    @NSManaged public var url: String?
    @NSManaged public var farm: String?
    @NSManaged public var cat: Bool
    @NSManaged public var is_trusteed: Bool
    @NSManaged public var size: Float
    @NSManaged public var is_active: Bool
    @NSManaged public var metas: NSSet?

}

// MARK: Generated accessors for metas
extension Land {

    @objc(addMetasObject:)
    @NSManaged public func addToMetas(_ value: Meta)

    @objc(removeMetasObject:)
    @NSManaged public func removeFromMetas(_ value: Meta)

    @objc(addMetas:)
    @NSManaged public func addToMetas(_ values: NSSet)

    @objc(removeMetas:)
    @NSManaged public func removeFromMetas(_ values: NSSet)

}
