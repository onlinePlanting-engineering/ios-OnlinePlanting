//
//  Farm+CoreDataProperties.swift
//  OnlinePlanting
//
//  Created by IBM on 30/05/2017.
//  Copyright © 2017 onlinePlanting. All rights reserved.
//

import Foundation
import CoreData


extension Farm {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Farm> {
        return NSFetchRequest<Farm>(entityName: "Farm")
    }

    @NSManaged public var addr: String?
    @NSManaged public var content: String?
    @NSManaged public var id: Int16
    @NSManaged public var is_delete: Bool
    @NSManaged public var name: String?
    @NSManaged public var notice: String?
    @NSManaged public var owner: String?
    @NSManaged public var phone: String?
    @NSManaged public var price: Double
    @NSManaged public var subject: String?
    @NSManaged public var url: String?
    @NSManaged public var home_img_url: String?
    @NSManaged public var comments: NSSet?
    @NSManaged public var imgs: NSSet?
    @NSManaged public var lands: NSSet?

}

// MARK: Generated accessors for comments
extension Farm {

    @objc(addCommentsObject:)
    @NSManaged public func addToComments(_ value: CommentURL)

    @objc(removeCommentsObject:)
    @NSManaged public func removeFromComments(_ value: CommentURL)

    @objc(addComments:)
    @NSManaged public func addToComments(_ values: NSSet)

    @objc(removeComments:)
    @NSManaged public func removeFromComments(_ values: NSSet)

}

// MARK: Generated accessors for imgs
extension Farm {

    @objc(addImgsObject:)
    @NSManaged public func addToImgs(_ value: ImageURL)

    @objc(removeImgsObject:)
    @NSManaged public func removeFromImgs(_ value: ImageURL)

    @objc(addImgs:)
    @NSManaged public func addToImgs(_ values: NSSet)

    @objc(removeImgs:)
    @NSManaged public func removeFromImgs(_ values: NSSet)

}

// MARK: Generated accessors for lands
extension Farm {

    @objc(addLandsObject:)
    @NSManaged public func addToLands(_ value: LandURL)

    @objc(removeLandsObject:)
    @NSManaged public func removeFromLands(_ value: LandURL)

    @objc(addLands:)
    @NSManaged public func addToLands(_ values: NSSet)

    @objc(removeLands:)
    @NSManaged public func removeFromLands(_ values: NSSet)

}
