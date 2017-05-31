//
//  OPLandSelectedCollectionViewCell.swift
//  OnlinePlanting
//
//  Created by IBM on 5/22/17.
//  Copyright © 2017 onlinePlanting. All rights reserved.
//

import UIKit

protocol OPLandSelectedCollectionViewCellProtocol: NSObjectProtocol{
    func removeSelectedMeta()
}

class OPLandSelectedCollectionViewCell: UICollectionViewCell {
    
    
    @IBOutlet weak var landName: UIButton!
    
    override func draw(_ rect: CGRect) {
        super.draw(rect)
        
        layer.cornerRadius = 5
        layer.masksToBounds = true
        layer.borderWidth = 1.0
        layer.borderColor = UIColor.lightGray.cgColor
    }
    
    func updateDataSource(_ meta: Meta?) {
        guard let metadata = meta else { return }
        landName.setTitle(metadata.num, for: .normal)
        
        landName.addTarget(self, action: #selector(removeSelectedMeta), for: .touchUpInside)
    }
    
    func removeSelectedMeta() {
        
    }
}
