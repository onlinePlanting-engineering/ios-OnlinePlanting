//
//  OPTabBarController.swift
//  OnlinePlanting
//
//  Created by Alex on 4/27/17.
//  Copyright © 2017 onlinePlanting. All rights reserved.
//

import UIKit

class OPTabBarController: UITabBarController {
    
    fileprivate var indexFlag = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()

        prepareUI()
        // Do any additional setup after loading the view.
    }
    
    func prepareUI() {
        tabBar.tintColor = UIColor(hexString: OPGreenColor)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func tabBar(_ tabBar: UITabBar, didSelect item: UITabBarItem) {
        if let index = tabBar.items?.index(of: item) {
            if indexFlag != index {
                animationWithIndex(index: index)
            }
        }
    }
    
    func animationWithIndex(index: Int) {
        var arr = [UIView]()
        for tabBarButton in tabBar.subviews {
            if tabBarButton.isKind(of: NSClassFromString("UITabBarButton")!) {
                arr.append(tabBarButton)
            }
        }
        for imageView in arr[index].subviews {
            if imageView.isKind(of: NSClassFromString("UITabBarSwappableImageView")!) {
                imageView.layer.removeAllAnimations()
                let pulse = CAKeyframeAnimation(keyPath: "transform.scale")
                pulse.calculationMode = kCAAnimationCubic
                pulse.values = [0.5,0.8,1.0,1.1,1.2,1.15,1.1,1.0]
                pulse.duration = 0.8
                imageView.layer.add(pulse, forKey: nil)
                indexFlag = index
            }
        }
    }
}
