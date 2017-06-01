//
//  ImageGroup+CoreDataProperties.swift
//  OnlinePlanting
//
//  Created by IBM on 29/05/2017.
//  Copyright © 2017 onlinePlanting. All rights reserved.
//

import Foundation
import CoreData


extension ImageGroup {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<ImageGroup> {
        return NSFetchRequest<ImageGroup>(entityName: "ImageGroup")
    }

    @NSManaged public var id: Int64
    @NSManaged public var timestamp: String?
    @NSManaged public var desc: String?
    @NSManaged public var imgs: NSSet?

}

// MARK: Generated accessors for imgs
extension ImageGroup {

    @objc(addImgsObject:)
    @NSManaged func addToImgs(_ value: Images)

    @objc(removeImgsObject:)
    @NSManaged func removeFromImgs(_ value: Images)

    @objc(addImgs:)
    @NSManaged public func addToImgs(_ values: NSSet)

    @objc(removeImgs:)
    @NSManaged public func removeFromImgs(_ values: NSSet)

}
