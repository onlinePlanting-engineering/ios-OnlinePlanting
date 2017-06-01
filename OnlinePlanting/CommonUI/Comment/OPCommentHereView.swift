//
//  OPCommentHereView.swift
//  OnlinePlanting
//
//  Created by IBM on 5/14/17.
//  Copyright © 2017 onlinePlanting. All rights reserved.
//

import UIKit

class OPCommentHereView: UIView {
    
    @IBOutlet weak var textfield: OPTextField!
    var type = "CommentHere"
    @IBOutlet weak var commentNumber: UILabel!
    override func draw(_ rect: CGRect) {
        textfield.layer.borderWidth = 0.5
        textfield.layer.borderColor = UIColor.lightGray.cgColor
        textfield.layer.cornerRadius = 5
        textfield.layer.masksToBounds = true
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setup()
    }
    
    convenience init(_ leftView: UIView?, frame: CGRect) {
        self.init(frame: frame)
        
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    func setup() {
        let subVieww = UINib(nibName: "OPCommentHereView", bundle: nil)
            .instantiate(withOwner: self, options: nil).first as! UIView
        subVieww.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        subVieww.frame = self.bounds
        addSubview(subVieww)
    }
}
