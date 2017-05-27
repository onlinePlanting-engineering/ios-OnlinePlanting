//
//  OPLandCollectionViewCell.swift
//  OnlinePlanting
//
//  Created by IBM on 5/22/17.
//  Copyright © 2017 onlinePlanting. All rights reserved.
//

import UIKit

class OPLandCollectionViewCell: UICollectionViewCell {
    
    
    @IBOutlet weak var statusImage: UIImageView!
    @IBOutlet weak var metasName: UILabel!
    
    
    var status: LandStatus = .available {
        didSet {
            changestatus(status)
        }
    }
    
    
    override func draw(_ rect: CGRect) {
        super.draw(rect)
    }
    
    
    func changestatus(_ status: LandStatus) {
        switch status {
        case .available:
            statusImage.image = UIImage.init(named: "land_available")
        case .selected:
            statusImage.image = UIImage.init(named: "land_selected")
        case .unavailable:
            statusImage.image = UIImage.init(named: "land_unavailable")
        }
    }
    
    func undateDataSource(_ number: String) {
        metasName.text = number
    }
}
