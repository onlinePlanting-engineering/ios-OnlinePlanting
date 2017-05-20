//
//  FarmImage+CoreDataProperties.swift
//  OnlinePlanting
//
//  Created by IBM on 5/19/17.
//  Copyright © 2017 onlinePlanting. All rights reserved.
//

import Foundation
import CoreData


extension FarmImage {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<FarmImage> {
        return NSFetchRequest<FarmImage>(entityName: "FarmImage");
    }

    @NSManaged public var flags: String?
    @NSManaged public var img: String?
    @NSManaged public var is_delete: Bool
    @NSManaged public var url: String?
    @NSManaged public var owner: Farm?

}
