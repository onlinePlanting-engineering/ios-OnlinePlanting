//
//  OPFarmDetailedViewController.swift
//  OnlinePlanting
//
//  Created by IBM on 5/8/17.
//  Copyright © 2017 onlinePlanting. All rights reserved.
//

import UIKit

class OPFarmDetailedViewController: UIViewController {

    
    @IBOutlet weak var farmOther: UIButton!
    @IBOutlet weak var farmComments: UIButton!
    @IBOutlet weak var detailed: UIButton!
    @IBOutlet weak var farmImage: UIImageView!
    var newImage: UIImage!
    var farmData: Farm?
    @IBOutlet weak var buttonAnimatedView: UIView!
    @IBOutlet weak var webview: UIWebView!
    
    @IBAction func detailedButton(_ sender: UIButton) {
        buttonAnimation(sender)
    }
    
    @IBAction func commentsButton(_ sender: UIButton) {
        buttonAnimation(sender)
    }
    
    @IBAction func farmOther(_ sender: UIButton) {
        buttonAnimation(sender)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        farmImage.image = newImage
        UIApplication.shared.statusBarStyle = .default
        setNavigarationBar()
        prepareUI()
        // Do any additional setup after loading the view.
    }
    
    func prepareUI() {
        detailed.setTitleColor(UIColor(hexString: OPGreenColor), for: .normal)
        detailed.tag = 0
        farmComments.setTitleColor(UIColor.darkGray, for: .normal)
        farmComments.tag = 1
        farmOther.setTitleColor(UIColor.darkGray, for: .normal)
        farmOther.tag = 2
        
        webview.scrollView.showsVerticalScrollIndicator = false
        webview.scrollView.showsHorizontalScrollIndicator = false
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        loadFarmData()
    }
    
    func loadFarmData() {
        guard let contentURL = farmData?.content, let url = URL(string: contentURL) else { return }
        webview.loadRequest(URLRequest(url: url))
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func setNavigarationBar() {
        guard let backImage = UIImage(named: "back_black") else { return }
        let leftArrowItem = UIBarButtonItem.createBarButtonItemWithImage(backImage, CGRect(x: 0, y: 0, width: 28, height: 30), self, #selector(dismissCurrentView))
        navigationItem.leftBarButtonItem = leftArrowItem
        
        navigationController?.navigationBar.barTintColor = UIColor.white
        navigationController?.navigationBar.isTranslucent = false
    }
    
    func dismissCurrentView(){
        dismiss(animated: true, completion: nil)
    }
    
    func buttonAnimation(_ button: UIButton) {
        
        if button.tag == 0 {
            detailed.setTitleColor(UIColor(hexString: OPGreenColor), for: .normal)
            farmComments.setTitleColor(UIColor.darkGray, for: .normal)
            farmOther.setTitleColor(UIColor.darkGray, for: .normal)
        } else if button.tag == 1 {
            detailed.setTitleColor(UIColor.darkGray, for: .normal)
            farmComments.setTitleColor(UIColor(hexString: OPGreenColor), for: .normal)
            farmOther.setTitleColor(UIColor.darkGray, for: .normal)
        } else if button.tag == 2 {
            detailed.setTitleColor(UIColor.darkGray, for: .normal)
            farmComments.setTitleColor(UIColor.darkGray, for: .normal)
            farmOther.setTitleColor(UIColor(hexString: OPGreenColor), for: .normal)
        }
        
        UIView.animate(withDuration: 0.2, animations: {[weak self] in
            self?.buttonAnimatedView.center.x = button.center.x
        }, completion: nil)
    }
}
