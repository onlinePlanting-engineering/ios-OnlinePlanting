//
//  OPFarmDetailedViewController.swift
//  OnlinePlanting
//
//  Created by IBM on 5/8/17.
//  Copyright © 2017 onlinePlanting. All rights reserved.
//

import UIKit

class OPFarmDetailedViewController: UIViewController, SubScrollDelegate {

    @IBOutlet weak var farmOther: UIButton!
    @IBOutlet weak var farmComments: UIButton!
    @IBOutlet weak var detailed: UIButton!
    @IBOutlet weak var farmImage: UIImageView!
    @IBOutlet weak var buttonAnimatedView: UIView!
    @IBOutlet weak var headerView: UIView!
    @IBOutlet weak var headerImageView: UIImageView!

    var farmData: Farm?
    var newImage: UIImage!
    fileprivate var farmContainerVc: OPFarmContainerViewController?
    fileprivate var currentPage = 0
    fileprivate var scrollOffSet = [Int: CGFloat]()
    fileprivate var previousButton = 0
    
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
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)

    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "embedContainer" {
            farmContainerVc = segue.destination as? OPFarmContainerViewController
            farmContainerVc?.parentVC = self
            farmContainerVc?.delegate = self
            farmContainerVc?.farm = farmData
        }
    }
    
    func customScrollViewDidScroll(_ scrollView: UIScrollView) {

        let offset = scrollView.contentOffset.y
        scrollHeaderView(offset)
    }
    
    func previousPage(_ offset: CGFloat) {
        
        scrollHeaderView(offset)
    }
    
    func scrollHeaderView(_ offset: CGFloat) {
        if offset < 0 {
            var headerTransform = CATransform3DIdentity
            let headerScaleFactor:CGFloat = -(offset) / headerView.bounds.height
            let headerSizevariation = ((headerView.bounds.height * (1.0 + headerScaleFactor)) - headerView.bounds.height)/2.0
            headerTransform = CATransform3DTranslate(headerTransform, 0, headerSizevariation, 0)
            headerTransform = CATransform3DScale(headerTransform, 1.0 + headerScaleFactor, 1.0 + headerScaleFactor, 0)
            headerView.layer.transform = headerTransform
        } else {
            var headerTransform = CATransform3DIdentity
            headerTransform = CATransform3DTranslate(headerTransform, 0, max(-(headerView.bounds.height-min_header), -offset), 0)
            headerView.layer.transform = headerTransform
        }
        
        if (headerView.bounds.height-min_header) < offset {
            headerView.layer.zPosition = 3
        } else {
            headerView.layer.zPosition = 0
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        print("touch begins")
    }
    
    func setNavigarationBar() {
        UIApplication.shared.statusBarStyle = .lightContent
        guard let backImage = UIImage(named: "back_white") else { return }
        let leftArrowItem = UIBarButtonItem.createBarButtonItemWithImage(backImage, CGRect(x: 0, y: 0, width: 28, height: 30), self, #selector(dismissCurrentView))
        navigationItem.leftBarButtonItem = leftArrowItem
        
        navigationController?.navigationBar.barTintColor = UIColor.init(hexString: "#2D363C")
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
            farmContainerVc?.swapViewControllers("contentsegue")
            currentPage = 0
        } else if button.tag == 1 {
            detailed.setTitleColor(UIColor.darkGray, for: .normal)
            farmComments.setTitleColor(UIColor(hexString: OPGreenColor), for: .normal)
            farmOther.setTitleColor(UIColor.darkGray, for: .normal)
            farmContainerVc?.swapViewControllers("commentsegue")
            currentPage = 1
        } else if button.tag == 2 {
            detailed.setTitleColor(UIColor.darkGray, for: .normal)
            farmComments.setTitleColor(UIColor.darkGray, for: .normal)
            farmOther.setTitleColor(UIColor(hexString: OPGreenColor), for: .normal)
            farmContainerVc?.swapViewControllers("activitysegue")
            currentPage = 2
        }
        
        UIView.animate(withDuration: 0.2, animations: {[weak self] in
            self?.buttonAnimatedView.center.x = button.center.x
            //self?.headerView.layer.transform = CATransform3DIdentity
            }, completion: nil)
    }
}
