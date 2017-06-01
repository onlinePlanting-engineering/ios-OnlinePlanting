//
//  OPHomeViewController.swift
//  OnlinePlanting
//
//  Created by Alex on 4/27/17.
//  Copyright © 2017 onlinePlanting. All rights reserved.
//

import UIKit

class OPHomeViewController: UIViewController {
    
    lazy var rightUserItem: UIBarButtonItem = {
        let userImage = UIImage(named: "profile")
        let rightUserItem = UIBarButtonItem.createBarButtonItemWithImage(userImage!, CGRect(x: 0, y: 0, width: 30, height: 30), self, #selector(showProfile))
        return rightUserItem
    }()
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        setNavigarationBar()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func setNavigarationBar() {
        navigationController?.navigationBar.topItem?.title = nil
        navigationController?.navigationBar.topItem?.rightBarButtonItem = rightUserItem
    }
    

    func showProfile() {
        let profileVC = UIStoryboard.init(name: "OPMe", bundle: nil).instantiateInitialViewController() as? OPMeViewController
        navigationController?.pushViewController(profileVC!, animated: true)
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
