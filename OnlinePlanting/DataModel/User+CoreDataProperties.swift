//
//  User+CoreDataProperties.swift
//  OnlinePlanting
//
//  Created by IBM on 5/2/17.
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

}
