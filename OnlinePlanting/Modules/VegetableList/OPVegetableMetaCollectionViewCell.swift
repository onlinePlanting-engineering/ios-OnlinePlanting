//
//  OPVegetableMetaCollectionViewCell.swift
//  OnlinePlanting
//
//  Created by IBM on 03/06/2017.
//  Copyright © 2017 onlinePlanting. All rights reserved.
//

import UIKit

class OPVegetableMetaCollectionViewCell: UICollectionViewCell {
    
    @IBOutlet weak var collectionImage: UIImageView!
    @IBOutlet weak var collectionName: UILabel!
    weak var delegate: OPVegetableMetaTableViewCellDelegate?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        // Initialization code
    }
    
    func updateDataSource(_ meta: SeedVegetablesMeta?) {
        guard let data = meta else { return }
        collectionName.text = data.name
        
        delegate?.updateVegetableImage(meta, handler: { [weak self] (imageData, success, error) in
            guard let image = imageData, let url = image.img else {  return }
            if success {
                image.imageURL = URL.init(string: Networking.shareInstance.baseURL! + url)
                image.loadImageWithCompletionHandler { [weak self](image, error) in
                    if error != nil {
                        //error happens
                    } else {
                        //success
                        self?.collectionImage.image = image
                    }
                }
            }
        })
    }

}
