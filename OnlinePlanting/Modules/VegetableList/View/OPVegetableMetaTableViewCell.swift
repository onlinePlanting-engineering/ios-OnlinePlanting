//
//  OPVegetableMetaTableViewCell.swift
//  OnlinePlanting
//
//  Created by IBM on 02/06/2017.
//  Copyright © 2017 onlinePlanting. All rights reserved.
//

import UIKit

protocol OPVegetableMetaTableViewCellDelegate: NSObjectProtocol {
    func updateVegetableImage(_ meta: SeedVegetablesMeta?, handler:@escaping ((_ image: Images?, _ success:Bool, _ error:NSError?)->()))
}

class OPVegetableMetaTableViewCell: UITableViewCell {
    
    @IBOutlet weak var vegetableImage: UIImageView!
    @IBOutlet weak var name: UILabel!
    weak var delegate: OPVegetableMetaTableViewCellDelegate?

    override func awakeFromNib() {
        super.awakeFromNib()
        
        vegetableImage.layer.cornerRadius = vegetableImage.layer.bounds.height / 2
        vegetableImage.layer.masksToBounds = true
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    func updateDataSource(_ meta: SeedVegetablesMeta?) {
        guard let data = meta else { return }
        name.text = data.name
        
        delegate?.updateVegetableImage(meta, handler: { [weak self] (imageData, success, error) in
            guard let image = imageData, let url = image.img else {  return }
            if success {
                image.imageURL = URL.init(string: Networking.shareInstance.baseURL! + url)
                image.loadImageWithCompletionHandler { [weak self](image, error) in
                    if error != nil {
                        //error happens
                    } else {
                        //success
                        self?.vegetableImage.image = image
                    }
                }
            }
        })
    }

}
