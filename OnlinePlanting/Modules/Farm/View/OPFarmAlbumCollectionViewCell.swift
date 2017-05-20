//
//  OPFarmAlbumCollectionViewCell.swift
//  OnlinePlanting
//
//  Created by IBM on 5/20/17.
//  Copyright © 2017 onlinePlanting. All rights reserved.
//

import UIKit

class OPFarmAlbumCollectionViewCell: UICollectionViewCell {
    
    @IBOutlet weak var albumImage: UIImageView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }
    
    func updateDataSource(_ imageUrl: FarmImage?){
        guard let imageData = imageUrl, let url = imageData.img else { return }
        imageData.imageURL = URL.init(string: url)
        imageData.loadImageWithCompletionHandler { [weak self](image, error) in
            if error != nil {
                //error happens
            } else {
                //success
                self?.albumImage.image = image
            }
        }
    }
    
}
