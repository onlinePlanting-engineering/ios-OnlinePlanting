//
//  OPFarmTableViewCell.swift
//  OnlinePlanting
//
//  Created by IBM on 5/8/17.
//  Copyright © 2017 onlinePlanting. All rights reserved.
//

import UIKit

class OPFarmTableViewCell: UITableViewCell {
    
    
    @IBOutlet weak var framImage: UIImageView!
    @IBOutlet weak var farmTitle: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    func updateDataSource(_ farm: Farm?) {
        
        let imageList = farm?.imageList?.allObjects as? [FarmImage]
        for farmimage in imageList! {
            print("the image link is:\(farmimage.image)")
        }
        //framImage.sd_setImage(with: URL(string: url), placeholderImage: UIImage(named: "toast_image"))
    }
    
}
