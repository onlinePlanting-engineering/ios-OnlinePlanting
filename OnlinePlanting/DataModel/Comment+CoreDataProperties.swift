//
//  Comment+CoreDataProperties.swift
//  OnlinePlanting
//
//  Created by IBM on 29/05/2017.
//  Copyright © 2017 onlinePlanting. All rights reserved.
//

import Foundation
import CoreData


extension Comment {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Comment> {
        return NSFetchRequest<Comment>(entityName: "Comment")
    }

    @NSManaged public var content: String?
    @NSManaged public var grade: Double
    @NSManaged public var id: Int64
    @NSManaged public var object_id: Int16
    @NSManaged public var parent: Int64
    @NSManaged public var reply_count: Int16
    @NSManaged public var timestamp: NSDate?
    @NSManaged public var type: String?
    @NSManaged public var url: String?
    @NSManaged public var replies: NSSet?
    @NSManaged public var user: User?

}

// MARK: Generated accessors for replies
extension Comment {

    @objc(addRepliesObject:)
    @NSManaged public func addToReplies(_ value: Comment)

    @objc(removeRepliesObject:)
    @NSManaged public func removeFromReplies(_ value: Comment)

    @objc(addReplies:)
    @NSManaged public func addToReplies(_ values: NSSet)

    @objc(removeReplies:)
    @NSManaged public func removeFromReplies(_ values: NSSet)

}
