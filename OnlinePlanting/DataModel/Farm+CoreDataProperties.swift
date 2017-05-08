//
//  Farm+CoreDataProperties.swift
//  OnlinePlanting
//
//  Created by IBM on 5/8/17.
//  Copyright © 2017 onlinePlanting. All rights reserved.
//

import Foundation
import CoreData


extension Farm {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Farm> {
        return NSFetchRequest<Farm>(entityName: "Farm");
    }

    @NSManaged public var content: String?
    @NSManaged public var id: Int16
    @NSManaged public var is_delete: Bool
    @NSManaged public var name: String?
    @NSManaged public var notice: String?
    @NSManaged public var owner: String?
    @NSManaged public var price: Double
    @NSManaged public var subject: String?
    @NSManaged public var url: String?
    @NSManaged public var addr: String?
    @NSManaged public var images: NSSet?

}

// MARK: Generated accessors for images
extension Farm {

    @objc(addImagesObject:)
    @NSManaged public func addToImages(_ value: FarmImage)

    @objc(removeImagesObject:)
    @NSManaged public func removeFromImages(_ value: FarmImage)

    @objc(addImages:)
    @NSManaged public func addToImages(_ values: NSSet)

    @objc(removeImages:)
    @NSManaged public func removeFromImages(_ values: NSSet)

}
