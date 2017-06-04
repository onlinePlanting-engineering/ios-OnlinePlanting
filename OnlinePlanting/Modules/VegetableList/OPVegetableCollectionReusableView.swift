//
//  OPVegetableCollectionReusableView.swift
//  OnlinePlanting
//
//  Created by IBM on 03/06/2017.
//  Copyright © 2017 onlinePlanting. All rights reserved.
//

import UIKit

class OPVegetableCollectionReusableView: UICollectionReusableView {

    @IBOutlet weak var sectionTitle: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    func updateDataSource(_ title: String?) {
        
        sectionTitle.text = title
    }
    
}
