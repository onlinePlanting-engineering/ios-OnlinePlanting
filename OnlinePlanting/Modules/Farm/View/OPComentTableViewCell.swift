//
//  OPComentTableViewCell.swift
//  OnlinePlanting
//
//  Created by IBM on 5/12/17.
//  Copyright © 2017 onlinePlanting. All rights reserved.
//

import UIKit

class OPComentTableViewCell: UITableViewCell {
    
    
    @IBOutlet weak var userImageView: UIImageView!
    @IBOutlet weak var username: UILabel!
    @IBOutlet weak var commentContent: UILabel!
    @IBOutlet weak var comemmentDate: UILabel!
    @IBOutlet weak var commentButton: UIImageView!
    @IBOutlet weak var replyNumber: UILabel!
    @IBOutlet weak var commentContainer: UIView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        commentContainer.layer.cornerRadius = 3
        commentContent.layer.masksToBounds = true
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    func updateDataSource(_ content: String?){
        guard let comment = content else { return }
        commentContent.text = comment
    }

}
