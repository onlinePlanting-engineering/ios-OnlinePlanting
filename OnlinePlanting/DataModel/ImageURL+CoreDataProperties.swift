//
//  ImageURL+CoreDataProperties.swift
//  OnlinePlanting
//
//  Created by IBM on 02/06/2017.
//  Copyright © 2017 onlinePlanting. All rights reserved.
//

import Foundation
import CoreData


extension ImageURL {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<ImageURL> {
        return NSFetchRequest<ImageURL>(entityName: "ImageURL")
    }

    @NSManaged public var url: String?
    @NSManaged public var farmowner: Farm?
    @NSManaged public var metaowner: Meta?
    @NSManaged public var vegetableMetaowner: SeedVegetablesMeta?

}
