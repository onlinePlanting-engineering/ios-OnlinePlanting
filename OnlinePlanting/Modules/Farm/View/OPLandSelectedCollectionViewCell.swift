//
//  OPLandSelectedCollectionViewCell.swift
//  OnlinePlanting
//
//  Created by IBM on 5/22/17.
//  Copyright © 2017 onlinePlanting. All rights reserved.
//

import UIKit

class OPLandSelectedCollectionViewCell: UICollectionViewCell {
    
    override func draw(_ rect: CGRect) {
        super.draw(rect)
        
        layer.cornerRadius = 5
        layer.masksToBounds = true
        layer.borderWidth = 1.0
        layer.borderColor = UIColor.lightGray.cgColor
    }
}
