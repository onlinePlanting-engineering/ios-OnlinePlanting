//
//  Profile+CoreDataProperties.swift
//  OnlinePlanting
//
//  Created by IBM on 5/2/17.
//  Copyright © 2017 onlinePlanting. All rights reserved.
//

import Foundation
import CoreData


extension Profile {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Profile> {
        return NSFetchRequest<Profile>(entityName: "Profile");
    }

    @NSManaged public var nickname: String?
    @NSManaged public var addr: String?
    @NSManaged public var img_heading: String?
    @NSManaged public var gender: Int16
    @NSManaged public var owner: User?

}
