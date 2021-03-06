//
//  OPCommentInputView.swift
//  OnlinePlanting
//
//  Created by IBM on 5/14/17.
//  Copyright © 2017 onlinePlanting. All rights reserved.
//

import UIKit

class OPCommentInputView: UIView {
    
    
    @IBOutlet weak var commentTextView: OPCommentTextView!

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
        let subVieww = UINib(nibName: "OPCommentInputView", bundle: nil)
            .instantiate(withOwner: self, options: nil).first as! UIView
        subVieww.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        subVieww.frame = self.bounds
        addSubview(subVieww)
    }

}
