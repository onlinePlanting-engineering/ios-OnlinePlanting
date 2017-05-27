//
//  FarmComment+CoreDataProperties.swift
//  OnlinePlanting
//
//  Created by IBM on 27/05/2017.
//  Copyright © 2017 onlinePlanting. All rights reserved.
//

import Foundation
import CoreData


extension FarmComment {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<FarmComment> {
        return NSFetchRequest<FarmComment>(entityName: "FarmComment")
    }

    @NSManaged public var content: String?
    @NSManaged public var grade: Double
    @NSManaged public var id: Int64
    @NSManaged public var parent: Int64
    @NSManaged public var reply_count: Int16
    @NSManaged public var timestamp: NSDate?
    @NSManaged public var object_id: Int16
    @NSManaged public var type: String?
    @NSManaged public var url: String?
    @NSManaged public var replies: NSSet?
    @NSManaged public var user: User?

}

// MARK: Generated accessors for replies
extension FarmComment {

    @objc(addRepliesObject:)
    @NSManaged public func addToReplies(_ value: FarmComment)

    @objc(removeRepliesObject:)
    @NSManaged public func removeFromReplies(_ value: FarmComment)

    @objc(addReplies:)
    @NSManaged public func addToReplies(_ values: NSSet)

    @objc(removeReplies:)
    @NSManaged public func removeFromReplies(_ values: NSSet)

}
