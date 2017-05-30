//
//  Images+CoreDataProperties.swift
//  OnlinePlanting
//
//  Created by IBM on 30/05/2017.
//  Copyright © 2017 onlinePlanting. All rights reserved.
//

import Foundation
import CoreData


extension Images {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Images> {
        return NSFetchRequest<Images>(entityName: "Images")
    }

    @NSManaged public var img: String?
    @NSManaged public var is_delete: Bool
    @NSManaged public var updated_date: String?
    @NSManaged public var id: Int64
    @NSManaged public var created_date: String?
    @NSManaged public var group: Int64
    @NSManaged public var is_cover: Bool
    @NSManaged public var owner: ImageGroup?

}
