//
//  OPTextField.swift
//  OnlinePlanting
//
//  Created by IBM on 4/28/17.
//  Copyright © 2017 onlinePlanting. All rights reserved.
//

import UIKit

@IBDesignable
class OPTextField: UITextField {
    
    @IBInspectable var placeHolderColor: UIColor? {
        didSet {
            guard let placeStrig = placeholder, let color = placeHolderColor else { return }
            self.attributedPlaceholder = NSAttributedString(string: placeStrig, attributes: [NSForegroundColorAttributeName : color])
        }
    }
    
    @IBInspectable var letfView: UIImage? {
        didSet {
            let leftBigView = UIView(frame: CGRect(x: 0, y: 0, width: 40, height: 32))
            let leftImageV = UIImageView()
            leftImageV.image = letfView
            leftImageV.frame = CGRect(x: 0, y: 0, width: 32, height: 32)
            leftImageV.contentMode = UIViewContentMode.scaleAspectFit
            leftBigView.addSubview(leftImageV)
            self.leftView = leftBigView
            self.leftViewMode = UITextFieldViewMode.always

        }
    }

    override func draw(_ rect: CGRect) {
        super.draw(rect)
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
    }
    
    convenience init(_ leftView: UIView?, frame: CGRect) {
        self.init(frame: frame)
        
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
}
