//
//  OPMeDetailedTableViewCell.swift
//  OnlinePlanting
//
//  Created by IBM on 5/4/17.
//  Copyright © 2017 onlinePlanting. All rights reserved.
//

import UIKit

class OPMeDetailedTableViewCell: UITableViewCell {

    @IBOutlet weak var title: UILabel!
    @IBOutlet weak var profileinfor: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        backgroundColor = UIColor.white
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
