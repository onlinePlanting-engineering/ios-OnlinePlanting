//
//  OPFarmDetailedViewController.swift
//  OnlinePlanting
//
//  Created by IBM on 5/8/17.
//  Copyright © 2017 onlinePlanting. All rights reserved.
//

import UIKit

enum ButttonType: Int {
    case information, comments, activity, album
}

class OPFarmDetailedViewController: UIViewController, SubScrollDelegate {
    
    @IBOutlet weak var farmInformation: UIButton!
    @IBOutlet weak var farmComments: UIButton!
    @IBOutlet weak var activity: UIButton!
    @IBOutlet weak var farmAlbum: UIButton!
    @IBOutlet weak var farmImage: UIImageView!
    @IBOutlet weak var headerView: UIView!
    @IBOutlet weak var headerImageView: UIImageView!
    @IBOutlet weak var bottomNavView: UIView!
    @IBOutlet weak var farmHome: UILabel!
    @IBOutlet weak var farmActivity: UILabel!
    @IBOutlet weak var farmAlbumTitle: UILabel!
    @IBOutlet weak var farmCommentsTitle: UILabel!
    
    
    fileprivate var buttons = [UIButton]()
    var farmData: Farm?
    var newImage: UIImage!
    fileprivate var albumVC: OPFarmAlbumCollectionViewController?
    fileprivate var farmContainerVc: OPFarmContainerViewController?
    fileprivate var currentButton: ButttonType = .information
    
    @IBOutlet weak var rentLand: UIButton!
    
    @IBAction func showRentLand(_ sender: UIButton) {
        
    }
    
    
    @IBAction func detailedButton(_ sender: UIButton) {
        if currentButton == .information { return }
        showSelectedButton(sender)
        buttonAnimation(sender, type: .information)
    }
    
    @IBAction func commentsButton(_ sender: UIButton) {
        if currentButton == .comments { return }
        showSelectedButton(sender)
        buttonAnimation(sender, type: .comments)
    }
    
    @IBAction func farmOther(_ sender: UIButton) {
        if currentButton == .activity { return }
        showSelectedButton(sender)
        buttonAnimation(sender, type: .activity)
    }
    
    @IBAction func showAlbum(_ sender: UIButton) {
        currentButton = .album
        //showSelectedButton(sender)
        buttonAnimation(sender, type: .album)
    }
    
    func prepareUI(){
        
        farmInformation.tag = 0
        buttons.append(farmInformation)
        farmComments.tag = 1
        buttons.append(farmComments)
        activity.tag = 2
        buttons.append(activity)
        farmAlbum.tag = 3
        buttons.append(farmAlbum)
        
        rentLand.layer.cornerRadius = rentLand.bounds.height / 2
        rentLand.layer.masksToBounds = true
        rentLand.layer.borderWidth = 1
        rentLand.layer.borderColor = UIColor.lightGray.cgColor
        
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        farmImage.image = newImage
        UIApplication.shared.statusBarStyle = .default
        setNavigarationBar()
        
        prepareUI()
        // Do any additional setup after loading the view.
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
    
    
    func showHideTabBar(hidden hide: Bool, animated: Bool) {
        var originY: CGFloat = 0
        if hide {
            originY = (self.view.frame.height)
        } else {
            originY = (self.view.frame.height) - 49
        }
        
        UIView.animate(withDuration: 0.35, delay: 0, options: .curveEaseIn, animations: {[weak self] in
            self?.bottomNavView.frame.origin.y = originY
            }, completion: nil)
    }
    
    func hideOrShowBottomViewBeginScroll(_ scrollView: UIScrollView) {
        
        if scrollView.panGestureRecognizer.translation(in: scrollView).y < 0 {
            showHideTabBar(hidden: true, animated: true)
        }
        else {
            showHideTabBar(hidden: false, animated: true)
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
    
    func setNavigarationBar() {
        UIApplication.shared.statusBarStyle = .lightContent
        guard let backImage = UIImage(named: "back_white") else { return }
        let leftArrowItem = UIBarButtonItem.createBarButtonItemWithImage(backImage, CGRect(x: 0, y: 0, width: 28, height: 30), self, #selector(dismissCurrentView))
        navigationItem.leftBarButtonItem = leftArrowItem
        
        navigationController?.navigationBar.barTintColor = UIColor.init(hexString: "#2D363C")
        navigationController?.navigationBar.isTranslucent = false
        navigationController?.navigationBar.tintColor = UIColor.white
        navigationController?.navigationBar.titleTextAttributes = [
            NSForegroundColorAttributeName : UIColor.white]
        navigationItem.title = farmData?.name
    }
    
    func dismissCurrentView(){
        dismiss(animated: true, completion: nil)
    }
    
    func showSelectedButton(_ button: UIButton) {
        for buttonChange in buttons {
            if button.tag == buttonChange.tag {
                switch button.tag {
                case 0:
                    farmInformation.setBackgroundImage(UIImage(named: "farmHome_selected"), for: .normal)
                    farmComments.setBackgroundImage(UIImage(named: "farmComment_default"), for: .normal)
                    activity.setBackgroundImage(UIImage(named: "farmActivity_default"), for: .normal)
                    farmAlbum.setBackgroundImage(UIImage(named: "farmAlbum_default"), for: .normal)
                    farmHome.textColor = UIColor(hexString: OPGreenColor)
                    farmCommentsTitle.textColor = UIColor.white
                    farmActivity.textColor = UIColor.white
                    farmAlbumTitle.textColor = UIColor.white
                case 1:
                    farmInformation.setBackgroundImage(UIImage(named: "farmHome_default"), for: .normal)
                    farmComments.setBackgroundImage(UIImage(named: "farmComment_selected"), for: .normal)
                    activity.setBackgroundImage(UIImage(named: "farmActivity_default"), for: .normal)
                    farmAlbum.setBackgroundImage(UIImage(named: "farmAlbum_default"), for: .normal)
                    farmHome.textColor = UIColor.white
                    farmCommentsTitle.textColor = UIColor(hexString: OPGreenColor)
                    farmActivity.textColor = UIColor.white
                    farmAlbumTitle.textColor = UIColor.white
                case 2:
                    farmInformation.setBackgroundImage(UIImage(named: "farmHome_default"), for: .normal)
                    farmComments.setBackgroundImage(UIImage(named: "farmComment_default"), for: .normal)
                    activity.setBackgroundImage(UIImage(named: "farmActivity_selected"), for: .normal)
                    farmAlbum.setBackgroundImage(UIImage(named: "farmAlbum_default"), for: .normal)
                    farmHome.textColor = UIColor.white
                    farmCommentsTitle.textColor = UIColor.white
                    farmActivity.textColor = UIColor(hexString: OPGreenColor)
                    farmAlbumTitle.textColor = UIColor.white
                case 3:
                    farmInformation.setBackgroundImage(UIImage(named: "farmHome_default"), for: .normal)
                    farmComments.setBackgroundImage(UIImage(named: "farmComment_default"), for: .normal)
                    activity.setBackgroundImage(UIImage(named: "farmActivity_default"), for: .normal)
                    farmAlbum.setBackgroundImage(UIImage(named: "farmAlbum_selected"), for: .normal)
                    farmHome.textColor = UIColor.white
                    farmCommentsTitle.textColor = UIColor.white
                    farmActivity.textColor = UIColor.white
                    farmAlbumTitle.textColor = UIColor(hexString: OPGreenColor)
                default: break
                }
            }
        }
    }
    
    
    func buttonAnimation(_ button: UIButton, type: ButttonType) {
        
        button.layer.removeAllAnimations()
        let pulse = CAKeyframeAnimation(keyPath: "transform.scale")
        pulse.calculationMode = kCAAnimationCubic
        pulse.values = [0.8,1.0,1.1,1.0]
        pulse.duration = 0.5
        button.layer.add(pulse, forKey: nil)
        
        switch type {
        case .information:
            activity.setTitleColor(UIColor(hexString: OPGreenColor), for: .normal)
            farmComments.setTitleColor(UIColor.darkGray, for: .normal)
            farmInformation.setTitleColor(UIColor.darkGray, for: .normal)
            farmContainerVc?.swapViewControllers("contentsegue")
            currentButton = .information
            
        case .comments:
            activity.setTitleColor(UIColor.darkGray, for: .normal)
            farmComments.setTitleColor(UIColor(hexString: OPGreenColor), for: .normal)
            farmInformation.setTitleColor(UIColor.darkGray, for: .normal)
            farmContainerVc?.swapViewControllers("commentsegue")
            currentButton = .comments
            
        case .activity:
            activity.setTitleColor(UIColor.darkGray, for: .normal)
            farmComments.setTitleColor(UIColor.darkGray, for: .normal)
            farmInformation.setTitleColor(UIColor(hexString: OPGreenColor), for: .normal)
            farmContainerVc?.swapViewControllers("activitysegue")
            currentButton = .activity
        case .album:
            albumVC = UIStoryboard(name: "OPFarm", bundle: nil).instantiateViewController(withIdentifier: "OPFarmAlbumCollectionViewController") as? OPFarmAlbumCollectionViewController
            albumVC?.currentFarm = farmData
            guard let album = albumVC else { return }
            navigationController?.pushViewController(album, animated: true)
            currentButton = .album
        }
    }
}
