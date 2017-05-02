//
//  OPHomeViewController.swift
//  OnlinePlanting
//
//  Created by Alex on 4/27/17.
//  Copyright © 2017 onlinePlanting. All rights reserved.
//

import UIKit

class OPHomeViewController: UIViewController {
    
    @IBOutlet weak var user: UIImageView!
    
    @IBAction func updateProfile(_ sender: UIButton) {
        let nickname = "Alex"
        let gender = 1
        let address = "Ningbo, Zhe Jiang"
        let image = user.image
        OPDataService.sharedInstance.updateUserProfile(nickname, address: address, gender: gender, headImage: image) { (success, error) in
            if success {
                print("success")
            } else {
                print("failed")
            }
        }
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
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
