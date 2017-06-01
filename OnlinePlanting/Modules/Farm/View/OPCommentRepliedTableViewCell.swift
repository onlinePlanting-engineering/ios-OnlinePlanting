//
//  OPCommentRepliedTableViewCell.swift
//  OnlinePlanting
//
//  Created by IBM on 5/17/17.
//  Copyright © 2017 onlinePlanting. All rights reserved.
//

import UIKit
import SDWebImage

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
        
        replyNumber.isHidden = true
        
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    func updateDataSource(_ comments: Comment?, _ parentComment: Comment? = nil){
        guard let commentContent = comments else { return }
        content.text = commentContent.content
        var user = ""
        if let currentUser = commentContent.user?.profile?.nickname != "" ? commentContent.user?.profile?.nickname: commentContent.user?.username {
                user = "\(currentUser)"
        }
        if let parent = parentComment {
            if let parentUser = parent.user?.profile?.nickname != "" ? parent.user?.profile?.nickname: commentContent.user?.username {
                user += " 回复 \(parentUser)"
            }
        }
        username.text = user
        let count  = String(commentContent.reply_count)
        replyPlus.text = "+\(count)"
        if count == "0" {
            replyNumber.backgroundColor = UIColor.lightGray
        } else {
            replyNumber.backgroundColor = UIColor(hexString: OPGreenColor)
        }
        guard let time = commentContent.timestamp else { return }
        replyDate.text = TimeUtils.timeAgoSinceDate(time, numericDates: false)
        var url = ""
        guard let userimageURL = commentContent.user?.profile?.img_heading else { return }
        url = userimageURL
        if !url.hasPrefix(Networking.shareInstance.baseURL) {
            url = Networking.shareInstance.baseURL + url
        }
        userImage.sd_setImage(with: URL(string: url), placeholderImage: UIImage(named: "user_default"))
    }

}
