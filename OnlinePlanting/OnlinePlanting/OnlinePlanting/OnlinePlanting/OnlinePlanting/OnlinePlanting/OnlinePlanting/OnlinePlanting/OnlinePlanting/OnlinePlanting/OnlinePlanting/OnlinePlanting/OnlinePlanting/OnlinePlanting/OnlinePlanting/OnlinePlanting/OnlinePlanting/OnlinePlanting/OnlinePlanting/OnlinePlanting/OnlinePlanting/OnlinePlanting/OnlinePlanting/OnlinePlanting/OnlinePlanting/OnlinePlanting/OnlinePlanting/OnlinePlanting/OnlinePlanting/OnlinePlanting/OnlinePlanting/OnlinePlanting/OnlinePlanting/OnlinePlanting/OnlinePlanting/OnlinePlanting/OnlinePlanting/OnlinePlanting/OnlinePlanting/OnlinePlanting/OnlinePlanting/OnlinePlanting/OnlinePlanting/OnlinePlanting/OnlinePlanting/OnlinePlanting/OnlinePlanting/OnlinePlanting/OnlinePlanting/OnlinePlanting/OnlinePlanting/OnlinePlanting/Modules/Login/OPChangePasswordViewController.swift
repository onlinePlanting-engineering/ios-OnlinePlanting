//
//  OPChangePasswordViewController.swift
//  OnlinePlanting
//
//  Created by IBM on 4/30/17.
//  Copyright © 2017 onlinePlanting. All rights reserved.
//

import UIKit

class OPChangePasswordViewController: UIViewController {
    
    @IBOutlet weak var emailContainerView: UIView!
    @IBOutlet weak var phoneContainerView: UIView!
    
    @IBAction func emailChange(_ sender: UIButton) {
        emailContainerView.alpha = 0.0
        UIView.animate(withDuration: 0.75, animations: { [weak self] in
            self?.phoneContainerView.alpha = 1.0
        }, completion: nil)
    }
    
    
    @IBAction func closeKeboard(_ sender: UITapGestureRecognizer) {

    }
    
    
    @IBAction func phoneChange(_ sender: UIButton) {
        phoneContainerView.alpha = 0.0
        UIView.animate(withDuration: 0.75, animations: { [weak self] in
            self?.emailContainerView.alpha = 1.0
            }, completion: nil)
    }

    @IBAction func closeChangePasswordVc(_ sender: UITapGestureRecognizer) {
        dismiss(animated: true, completion: nil)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        phoneContainerView.alpha = 0.0
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
}
