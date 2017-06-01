//
//  FarmActivityTableViewCell.swift
//  OnlinePlanting
//
//  Created by IBM on 5/15/17.
//  Copyright © 2017 onlinePlanting. All rights reserved.
//

import UIKit

class FarmActivityTableViewCell: UITableViewCell {

    @IBOutlet weak var containerView: UIView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        containerView.layer.cornerRadius = 3
        containerView.layer.masksToBounds = true
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
