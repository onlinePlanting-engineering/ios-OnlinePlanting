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
    fileprivate var commentGesture: UITapGestureRecognizer?
    @IBOutlet weak var touchView: UIView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        //self.backgroundColor = UIColor.clear
    }

    func viewComment() {
        print("tap on comments")
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    func addTapGesureForComment() {
        
        if let gestures = touchView.gestureRecognizers {
            for gesture in gestures {
                touchView.removeGestureRecognizer(gesture)
            }
        }
        
        commentGesture = UITapGestureRecognizer(target: self, action: #selector(viewComment))
        guard let gesture = commentGesture else { return }
        touchView.addGestureRecognizer(gesture)
        
    }
    
    func updateDataSource(_ farm: Farm?) {
        addTapGesureForComment()
        
        let imageList = farm?.images?.allObjects as? [FarmImage]
        if let imagecount = imageList?.count, imagecount > 0 {
            guard let imageURL = imageList?.first?.img  else { return }
            framImage.sd_setImage(with: URL(string: imageURL), placeholderImage: UIImage(named: "toast_image"))
        }
        
        if let name = farm?.name, let address = farm?.addr {
            farmTitle.text = "\(name) | \(address)"
        }
    }
    
}
