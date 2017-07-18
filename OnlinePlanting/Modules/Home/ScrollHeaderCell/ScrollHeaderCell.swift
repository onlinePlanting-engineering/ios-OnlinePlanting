//
//  ScrollHeaderCell.swift
//  OnlinePlanting
//
//  Created by IBM on 20/06/2017.
//  Copyright © 2017 onlinePlanting. All rights reserved.
//

import UIKit
import SDWebImage

class ScrollHeaderCell: UICollectionViewCell {
    
    @IBOutlet weak var headerImage: UIImageView!

    override func draw(_ rect: CGRect) {
        super.draw(rect)
    }
    
    func updateDataSource(_ image: String?){
        guard let url = image else { return }
        headerImage.sd_setImage(with: URL.init(string: url), placeholderImage: UIImage(named: "toast_image"))
    }
    
}
