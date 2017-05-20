//
//  FarmComment+CoreDataProperties.swift
//  OnlinePlanting
//
//  Created by IBM on 5/16/17.
//  Copyright © 2017 onlinePlanting. All rights reserved.
//

import Foundation
import CoreData


extension FarmComment {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<FarmComment> {
        return NSFetchRequest<FarmComment>(entityName: "FarmComment");
    }

    @NSManaged public var content: String?
    @NSManaged public var grade: Double
    @NSManaged public var id: Int64
    @NSManaged public var parent: Int64
    @NSManaged public var reply_count: Int16
    @NSManaged public var timestamp: NSDate?
    @NSManaged public var url: String?
    @NSManaged public var user: User?

}
