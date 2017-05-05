//
//  UpdateProfileTableViewCell.swift
//  OnlinePlanting
//
//  Created by IBM on 5/5/17.
//  Copyright © 2017 onlinePlanting. All rights reserved.
//

import UIKit

class UpdateProfileTableViewCell: UITableViewCell {

    
    @IBOutlet weak var updateTextField: UITextField!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        updateTextField.borderStyle = .none
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
