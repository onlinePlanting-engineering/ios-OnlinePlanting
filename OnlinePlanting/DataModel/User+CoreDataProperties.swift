//
//  User+CoreDataProperties.swift
//  OnlinePlanting
//
//  Created by IBM on 29/05/2017.
//  Copyright © 2017 onlinePlanting. All rights reserved.
//

import Foundation
import CoreData


extension User {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<User> {
        return NSFetchRequest<User>(entityName: "User")
    }

    @NSManaged public var id: Int64
    @NSManaged public var username: String?
    @NSManaged public var farmcomment: NSSet?
    @NSManaged public var profile: Profile?
    @NSManaged public var metaowner: Meta?

}

// MARK: Generated accessors for farmcomment
extension User {

    @objc(addFarmcommentObject:)
    @NSManaged public func addToFarmcomment(_ value: Comment)

    @objc(removeFarmcommentObject:)
    @NSManaged public func removeFromFarmcomment(_ value: Comment)

    @objc(addFarmcomment:)
    @NSManaged public func addToFarmcomment(_ values: NSSet)

    @objc(removeFarmcomment:)
    @NSManaged public func removeFromFarmcomment(_ values: NSSet)

}
