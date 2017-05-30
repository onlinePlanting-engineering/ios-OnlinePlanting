//
//  CommentURL+CoreDataProperties.swift
//  OnlinePlanting
//
//  Created by IBM on 29/05/2017.
//  Copyright © 2017 onlinePlanting. All rights reserved.
//

import Foundation
import CoreData


extension CommentURL {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<CommentURL> {
        return NSFetchRequest<CommentURL>(entityName: "CommentURL")
    }

    @NSManaged public var url: String?
    @NSManaged public var farmowner: Farm?

}
