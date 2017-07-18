//
//  OPVegetableDefailedViewController.swift
//  OnlinePlanting
//
//  Created by IBM on 11/07/2017.
//  Copyright © 2017 onlinePlanting. All rights reserved.
//

import UIKit

class OPVegetableDefailedViewController: UIViewController {

    @IBOutlet weak var webview: UIWebView!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        webview.loadRequest(URLRequest.init(url: URL.init(string: "http://localhost:8888/2017/07/11/alex-2/")!))
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
