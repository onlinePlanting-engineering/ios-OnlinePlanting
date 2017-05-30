//
//  LandURL+CoreDataProperties.swift
//  OnlinePlanting
//
//  Created by IBM on 29/05/2017.
//  Copyright © 2017 onlinePlanting. All rights reserved.
//

import Foundation
import CoreData


extension LandURL {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<LandURL> {
        return NSFetchRequest<LandURL>(entityName: "LandURL")
    }

    @NSManaged public var url: String?
    @NSManaged public var farmowner: Farm?

}
