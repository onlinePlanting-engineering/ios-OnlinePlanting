//
//  Location+CoreDataProperties.swift
//  OnlinePlanting
//
//  Created by IBM on 5/5/17.
//  Copyright © 2017 onlinePlanting. All rights reserved.
//

import Foundation
import CoreData


extension Location {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Location> {
        return NSFetchRequest<Location>(entityName: "Location");
    }

    @NSManaged public var countryCode: String?
    @NSManaged public var country: String?
    @NSManaged public var province: String?
    @NSManaged public var city: String?
    @NSManaged public var subLocality: String?
    @NSManaged public var street: String?

}
