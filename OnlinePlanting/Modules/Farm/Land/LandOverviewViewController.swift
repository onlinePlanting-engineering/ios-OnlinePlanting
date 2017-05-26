//
//  LandOverviewViewController.swift
//  OnlinePlanting
//
//  Created by IBM on 5/25/17.
//  Copyright © 2017 onlinePlanting. All rights reserved.
//

import UIKit

class LandOverviewViewController: UIViewController {
    
    
    @IBAction func showinsideLand(_ sender: UIButton) {
        
    }
    
    
    @IBAction func showoutsideLand(_ sender: UIButton) {
        
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        setNavationBar()
        // Do any additional setup after loading the view.
    }
    
    func setNavationBar() {
        navigationItem.title = ""
        guard let backImage = UIImage(named: "back_white") else { return }
        let leftArrowItem = UIBarButtonItem.createBarButtonItemWithImage(backImage, CGRect(x: 0, y: 0, width: 28, height: 30), self, #selector(dismissCurrentView))
        let titleItem = UIBarButtonItem.createBarButtonItemWithText("我要租地", CGRect(x: 0, y: 0, width: 100, height: 30), self, #selector(dismissCurrentView), UIColor.white, 16)
        navigationItem.leftBarButtonItems = [leftArrowItem, titleItem]
    }
    
    func dismissCurrentView() {
        let _ = navigationController?.popViewController(animated: true)
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
