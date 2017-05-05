//
//  UIBarButtonItem+Ext.swift
//  OnlinePlanting
//
//  Created by ___Alex___ on 4/28/17.
//  Copyright © 2017 onlinePlanting. All rights reserved.
//

import Foundation
import UIKit

extension UIBarButtonItem {
    
    static func createBarButtonItemWithImage(_ image: UIImage, _ rect: CGRect, _ target: AnyObject, _ method: Selector) -> UIBarButtonItem {
        let Img = image.withRenderingMode(.alwaysOriginal)
        let imgButton = UIButton(type: .custom)
        imgButton.frame = rect
        imgButton.setBackgroundImage(Img, for: .normal)
        imgButton.addTarget(target, action: method, for: .touchUpInside)
        let barButtonItem = UIBarButtonItem(customView: imgButton)
        return barButtonItem
    }
    
    static func createBarButtonItemWithText(_ text: String, _ rect: CGRect, _ target: AnyObject, _ method: Selector, _ color: UIColor, _ fontSize: CGFloat) -> UIBarButtonItem {
        let label = UILabel(frame: rect)
        label.text = text
        label.font = UIFont.init(name: "Helvetica Neue", size: fontSize)
        label.textAlignment = .left
        label.textColor = color
        let tap = UITapGestureRecognizer(target: target, action: method)
        label.addGestureRecognizer(tap)
        label.isUserInteractionEnabled = true
        let barButtonItem = UIBarButtonItem(customView: label)
        return barButtonItem
    }
    
    static func createBarButtonSpace(_ space: CGFloat) -> UIBarButtonItem{
        let barButtonItem = UIBarButtonItem(barButtonSystemItem: .fixedSpace, target: nil, action: nil)
        barButtonItem.width = space
        return barButtonItem
    }
}

