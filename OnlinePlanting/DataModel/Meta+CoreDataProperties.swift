//
//  Meta+CoreDataProperties.swift
//  OnlinePlanting
//
//  Created by IBM on 29/05/2017.
//  Copyright © 2017 onlinePlanting. All rights reserved.
//

import Foundation
import CoreData


extension Meta {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Meta> {
        return NSFetchRequest<Meta>(entityName: "Meta")
    }

    @NSManaged public var url: String?
    @NSManaged public var num: String?
    @NSManaged public var land: Int64
    @NSManaged public var size: Float
    @NSManaged public var price: String?
    @NSManaged public var is_rented: Bool
    @NSManaged public var owner: User?
    @NSManaged public var imgs: ImageURL?
    @NSManaged public var landowner: Land?

}
