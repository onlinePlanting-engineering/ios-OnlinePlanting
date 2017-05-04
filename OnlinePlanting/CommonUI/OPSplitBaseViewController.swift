//
//  OPSplitBaseViewController.swift
//  OnlinePlanting
//
//  Created by IBM on 5/4/17.
//  Copyright © 2017 onlinePlanting. All rights reserved.
//

import UIKit

class OPSplitBaseViewController: UIViewController {
    
    lazy var commonBackgroundImage: UIImageView  = {
        let commonBackgroundImage = UIImageView()
        self.view.addSubview(commonBackgroundImage)
        commonBackgroundImage.translatesAutoresizingMaskIntoConstraints = false
        commonBackgroundImage.widthAnchor.constraint(equalToConstant: self.view.bounds.height).isActive = true
        commonBackgroundImage.heightAnchor.constraint(equalToConstant: self.view.bounds.width)
        commonBackgroundImage.centerXAnchor.constraint(equalTo: self.view.centerXAnchor).isActive = true
        commonBackgroundImage.centerYAnchor.constraint(equalTo: self.view.centerYAnchor).isActive = true
        return commonBackgroundImage
    }()
    
    lazy var commonBackgroundEffectiveView: UIVisualEffectView  = {
        let blurEffect = UIBlurEffect(style: .light)
        let commonBackgroundEffectiveView = UIVisualEffectView(effect: blurEffect)
        self.view.addSubview(commonBackgroundEffectiveView)
        commonBackgroundEffectiveView.translatesAutoresizingMaskIntoConstraints = false
        commonBackgroundEffectiveView.widthAnchor.constraint(equalToConstant: self.view.bounds.width).isActive = true
        commonBackgroundEffectiveView.heightAnchor.constraint(equalToConstant: self.view.bounds.height)
        commonBackgroundEffectiveView.centerXAnchor.constraint(equalTo: self.view.centerXAnchor).isActive = true
        commonBackgroundEffectiveView.centerYAnchor.constraint(equalTo: self.view.centerYAnchor).isActive = true
        return commonBackgroundEffectiveView
    }()

    override func viewDidLoad() {
        super.viewDidLoad()

        prepareUI()
        // Do any additional setup after loading the view.
    }
    
    func prepareUI() {
        commonBackgroundImage.image = UIImage(named: "login_background")
        _ = commonBackgroundEffectiveView
//        for view in commonBackgroundEffectiveView.subviews {
//            view.backgroundColor = UIColor.black
//            view.alpha = 0.35
//        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
