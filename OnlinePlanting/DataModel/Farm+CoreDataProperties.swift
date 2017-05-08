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
    @NSManaged public var images: NSObject?
    @NSManaged public var is_delete: Bool
    @NSManaged public var name: String?
    @NSManaged public var notice: String?
    @NSManaged public var owner: String?
    @NSManaged public var price: Double
    @NSManaged public var subject: String?
    @NSManaged public var url: String?
    @NSManaged public var imageList: NSSet?

}

// MARK: Generated accessors for imageList
extension Farm {

    @objc(addImageListObject:)
    @NSManaged public func addToImageList(_ value: FarmImage)

    @objc(removeImageListObject:)
    @NSManaged public func removeFromImageList(_ value: FarmImage)

    @objc(addImageList:)
    @NSManaged public func addToImageList(_ values: NSSet)

    @objc(removeImageList:)
    @NSManaged public func removeFromImageList(_ values: NSSet)

}
