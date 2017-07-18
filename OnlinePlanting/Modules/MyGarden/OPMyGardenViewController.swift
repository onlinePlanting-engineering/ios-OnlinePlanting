//
//  OPMyGardenViewController.swift
//  OnlinePlanting
//
//  Created by Alex on 4/27/17.
//  Copyright © 2017 onlinePlanting. All rights reserved.
//

import UIKit

class OPMyGardenViewController: UIViewController {
    
    fileprivate var blogVC: EditorDemoController?
    
    lazy var rightUserItem: UIBarButtonItem = {
        let userImage = UIImage(named: "profile")
        let rightUserItem = UIBarButtonItem.createBarButtonItemWithImage(userImage!, CGRect(x: 0, y: 0, width: 30, height: 30), self, #selector(writeArticle))
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
        UIApplication.shared.statusBarStyle = .default
        navigationController?.navigationBar.topItem?.title = nil
        navigationController?.navigationBar.topItem?.rightBarButtonItem = rightUserItem
    }
    
    func writeArticle(){
        let storyboardNav = UIStoryboard.init(name: "Blog", bundle: nil).instantiateInitialViewController() as? UINavigationController
        blogVC = storyboardNav?.childViewControllers.first as? EditorDemoController
        if let vc = blogVC {
            navigationController?.pushViewController(vc, animated: true)
        }
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
