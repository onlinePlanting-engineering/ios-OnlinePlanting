//
//  OPComentTableViewCell.swift
//  OnlinePlanting
//
//  Created by IBM on 5/12/17.
//  Copyright © 2017 onlinePlanting. All rights reserved.
//

import UIKit
import SDWebImage

class OPComentTableViewCell: UITableViewCell {
    
    
    @IBOutlet weak var userImageView: UIImageView!
    @IBOutlet weak var username: UILabel!
    @IBOutlet weak var commentContent: UILabel!
    @IBOutlet weak var comemmentDate: UILabel!
    @IBOutlet weak var replyNumber: UILabel!
    @IBOutlet weak var commentContainer: UIView!
    
    @IBOutlet weak var replyBackground: UIView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        replyBackground.layer.cornerRadius = 3
        replyBackground.layer.masksToBounds = true
        
        userImageView.layer.cornerRadius = userImageView.bounds.height / 2
        userImageView.layer.masksToBounds = true
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    func updateDataSource(_ comments: FarmComment?){
        guard let content = comments else { return }
        commentContent.text = content.content
        username.text = content.user?.profile?.nickname != "" ? content.user?.profile?.nickname: content.user?.username
        
        let count  = String(content.reply_count)
        if count == "0" {
            replyBackground.backgroundColor = UIColor.lightGray
        } else {
            replyBackground.backgroundColor = UIColor(hexString: OPGreenColor)
        }
        replyNumber.text = "+\(count)"
        guard let time = content.timestamp else { return }
        comemmentDate.text = TimeUtils.timeAgoSinceDate(time, numericDates: false)
        
        var url = ""
        guard let userimageURL = content.user?.profile?.img_heading else { return }
        url = userimageURL
        if !url.hasPrefix(Networking.shareInstance.baseURL) {
            url = Networking.shareInstance.baseURL + url
        }
        userImageView.sd_setImage(with: URL(string: url), placeholderImage: UIImage(named: "user_default"))
    }

}
