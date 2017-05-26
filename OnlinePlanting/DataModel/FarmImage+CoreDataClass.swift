//
//  FarmImage+CoreDataClass.swift
//  OnlinePlanting
//
//  Created by IBM on 5/19/17.
//  Copyright © 2017 onlinePlanting. All rights reserved.
//

import Foundation
import CoreData
import INSPhotoGallery
import SDWebImage

class FarmImage: NSManagedObject, INSPhotoViewable{
    
    var image: UIImage?
    var thumbnailImage: UIImage?
    
    var imageURL: URL?
    var thumbnailImageURL: URL?
    
    var attributedTitle: NSAttributedString? {
        return NSAttributedString(string: "this is the latest photo from the farm", attributes: [NSForegroundColorAttributeName: UIColor.white])
    }
    
    func loadImageWithCompletionHandler(_ completion: @escaping (_ image: UIImage?, _ error: Error?) -> ()) {
        if let url = imageURL {
            SDWebImageManager.shared().downloadImage(with: url, options: SDWebImageOptions.cacheMemoryOnly, progress: { (min, max) in
                //value is
                //print("min is: \(min) max is: \(max)")
            }, completed: { (image, error, cacheType, success, url) in
//                print("value is: \(String(describing: image))\(String(describing: error))\(cacheType)\(success)\(String(describing: url))")
                completion(image, error)
            })
        } else {
            completion(nil, NSError(domain: "PhotoDomain", code: -1, userInfo: [ NSLocalizedDescriptionKey: "Couldn't load image"]))
        }
    }
    
    func loadThumbnailImageWithCompletionHandler(_ completion: @escaping (_ image: UIImage?, _ error: Error?) -> ()) {
        if let thumbnailImage = thumbnailImage {
            completion(thumbnailImage, nil)
            return
        }
    }
}
