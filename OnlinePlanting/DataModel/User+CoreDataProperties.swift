//
//  User+CoreDataProperties.swift
//  OnlinePlanting
//
//  Created by IBM on 5/16/17.
//  Copyright © 2017 onlinePlanting. All rights reserved.
//

import Foundation
import CoreData


extension User {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<User> {
        return NSFetchRequest<User>(entityName: "User");
    }

    @NSManaged public var id: Int64
    @NSManaged public var username: String?
    @NSManaged public var profile: Profile?
    @NSManaged public var farmcomment: NSSet?

}

// MARK: Generated accessors for farmcomment
extension User {

    @objc(addFarmcommentObject:)
    @NSManaged public func addToFarmcomment(_ value: FarmComment)

    @objc(removeFarmcommentObject:)
    @NSManaged public func removeFromFarmcomment(_ value: FarmComment)

    @objc(addFarmcomment:)
    @NSManaged public func addToFarmcomment(_ values: NSSet)

    @objc(removeFarmcomment:)
    @NSManaged public func removeFromFarmcomment(_ values: NSSet)

}
