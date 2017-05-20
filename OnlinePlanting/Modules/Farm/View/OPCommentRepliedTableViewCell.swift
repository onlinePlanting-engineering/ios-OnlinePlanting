//
//  OPCommentRepliedTableViewCell.swift
//  OnlinePlanting
//
//  Created by IBM on 5/17/17.
//  Copyright © 2017 onlinePlanting. All rights reserved.
//

import UIKit

class OPCommentRepliedTableViewCell: UITableViewCell {

    
    @IBOutlet weak var userImage: UIImageView!
    @IBOutlet weak var content: UILabel!
    @IBOutlet weak var replyDate: UILabel!
    @IBOutlet weak var username: UILabel!
    @IBOutlet weak var replyNumber: UIView!
    @IBOutlet weak var replyPlus: UILabel!
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        self.backgroundColor = UIColor.clear
        
        userImage.layer.cornerRadius = userImage.bounds.height / 2
        userImage.layer.masksToBounds = true
        
        replyNumber.layer.cornerRadius = 3
        replyNumber.layer.masksToBounds = true
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    func updateDataSource(_ comments: FarmComment?){
        guard let commentContent = comments else { return }
        content.text = commentContent.content
        username.text = commentContent.user?.profile?.nickname != "" ? commentContent.user?.profile?.nickname: commentContent.user?.username
        
        let count  = String(commentContent.reply_count)
        replyPlus.text = "+\(count)"
        if count == "0" {
            replyNumber.backgroundColor = UIColor.lightGray
        } else {
            replyNumber.backgroundColor = UIColor(hexString: OPGreenColor)
        }
        guard let time = commentContent.timestamp else { return }
        replyDate.text = TimeUtils.timeAgoSinceDate(time, numericDates: false)
        guard let userimageURL = commentContent.user?.profile?.img_heading else { return }
        userImage.sd_setImage(with: URL(string: userimageURL), placeholderImage: UIImage(named: "user_default"))
    }

}
