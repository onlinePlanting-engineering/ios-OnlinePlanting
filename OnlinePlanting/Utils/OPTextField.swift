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
    
    var customType = ""
    
    @IBInspectable var placeHolderColor: UIColor? {
        didSet {
            guard let placeStrig = placeholder, let color = placeHolderColor else { return }
            self.attributedPlaceholder = NSAttributedString(string: placeStrig, attributes: [NSForegroundColorAttributeName : color, NSFontAttributeName: UIFont(name: "Helvetica Neue", size: 15)! ])
            self.tintColor = .white
        }
    }
    
    @IBInspectable var letfView: UIImage? {
        didSet {
            let leftBigView = UIView(frame: CGRect(x: 0, y: 0, width: 38, height: 32))
            let leftImageV = UIImageView()
            leftImageV.image = letfView
            leftImageV.frame = CGRect(x: 0, y: 0, width: 28, height: 28)
            leftImageV.contentMode = UIViewContentMode.scaleAspectFit
            leftBigView.addSubview(leftImageV)
            self.leftView = leftBigView
            self.leftViewMode = UITextFieldViewMode.always

        }
    }
    
    func setDoneOnKeyboard() {
        let keyboardToolbar = UIToolbar()
        keyboardToolbar.backgroundColor = UIColor.darkGray
        keyboardToolbar.sizeToFit()
        let flexBarButton = UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: nil, action: nil)
        let doneBarButton = UIBarButtonItem(barButtonSystemItem: .done, target: self, action: #selector(dismissKeyboard))
        keyboardToolbar.items = [flexBarButton, doneBarButton]
        inputAccessoryView = keyboardToolbar
    }
    
    func dismissKeyboard() {
        resignFirstResponder()
    }

    override func draw(_ rect: CGRect) {
        super.draw(rect)
        
        keyboardAppearance = .dark
        borderStyle = .none
        clearButtonMode = .whileEditing
        textColor = UIColor.darkGray
        
        //setDoneOnKeyboard()
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
