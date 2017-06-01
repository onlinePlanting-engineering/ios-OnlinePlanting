//
//  OPFarmRendNoticeViewController.swift
//  OnlinePlanting
//
//  Created by IBM on 5/21/17.
//  Copyright © 2017 onlinePlanting. All rights reserved.
//

import UIKit

class OPFarmRendNoticeViewController: UIViewController {
    
    var farm: Farm?
    @IBOutlet weak var noticeWebView: UIWebView!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        setNavigarationBar()
        // Do any additional setup after loading the view.
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        guard let contentURL = farm?.notice, let url = URL(string: contentURL) else { return }
        noticeWebView.loadRequest(URLRequest(url: url))
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func setNavigarationBar() {
        guard let backImage = UIImage(named: "login_close") else { return }
        let leftArrowItem = UIBarButtonItem.createBarButtonItemWithImage(backImage, CGRect(x: 0, y: 0, width: 28, height: 30), self, #selector(dismissCurrentView))
        navigationItem.leftBarButtonItem = leftArrowItem
        
        navigationController?.navigationBar.barTintColor = UIColor.init(hexString: "#2D363C")
        navigationController?.navigationBar.isTranslucent = false
        
    }
    
    func dismissCurrentView(){
        dismiss(animated: true, completion: nil)
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
