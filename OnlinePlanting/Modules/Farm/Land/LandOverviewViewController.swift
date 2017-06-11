//
//  LandOverviewViewController.swift
//  OnlinePlanting
//
//  Created by IBM on 5/25/17.
//  Copyright © 2017 onlinePlanting. All rights reserved.
//

import UIKit

enum LandType: String {
    case trusteedCat = "trusteedCat"
    case trusteedNocat = "trusteedNocat"
    case untrusteedCat = "untrusteedCat"
    case untrusteedNocat = "untrusteedNocat"
}

class LandOverviewViewController: UIViewController {
    
    var farm: Farm?
    fileprivate var landGroupId: [Int64]?
    fileprivate var landsDir: [String:[Land]?]?
    fileprivate var landDetiledVC: OPLandViewController?
    
    @IBOutlet weak var circleIscat: UIView!
    @IBOutlet weak var trusteed_isCat: UIButton!
    @IBOutlet weak var untrusteed_isCat: UIButton!
    @IBOutlet weak var circleNocat: UIView!
    @IBOutlet weak var untrusteed_Nocat: UIButton!
    @IBOutlet weak var trusteed_Nocat: UIButton!
    
    @IBAction func showinsideLand(_ sender: UIButton) {
        
    }
    
    
    @IBAction func showoutsideLand(_ sender: UIButton) {
        
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        landGroupId = [Int64]()
        landsDir = [String:[Land]]()
        setNavationBar()
        
        circleIscat.layer.cornerRadius = circleIscat.bounds.height / 2
        circleIscat.layer.masksToBounds = true
        circleIscat.layer.borderWidth = 2
        circleIscat.layer.borderColor = UIColor.init(hexString: OPGreenColor).cgColor
        
        
        trusteed_isCat.layer.cornerRadius = trusteed_isCat.bounds.height / 2
        trusteed_isCat.layer.masksToBounds = true
        trusteed_isCat.layer.borderWidth = 2
        trusteed_isCat.layer.borderColor = UIColor.init(hexString: OPGreenColor).cgColor
        hasavailableLand(false,button: trusteed_isCat)
        untrusteed_isCat.layer.cornerRadius = untrusteed_isCat.bounds.height / 2
        untrusteed_isCat.layer.masksToBounds = true
        untrusteed_isCat.layer.borderWidth = 2
        untrusteed_isCat.layer.borderColor = UIColor.init(hexString: OPGreenColor).cgColor
        hasavailableLand(false,button: untrusteed_isCat)
        
        circleNocat.layer.cornerRadius = circleIscat.bounds.height / 2
        circleNocat.layer.masksToBounds = true
        circleNocat.layer.borderWidth = 2
        circleNocat.layer.borderColor = UIColor.init(hexString: OPGreenColor).cgColor
        
        untrusteed_Nocat.layer.cornerRadius = trusteed_isCat.bounds.height / 2
        untrusteed_Nocat.layer.masksToBounds = true
        untrusteed_Nocat.layer.borderWidth = 2
        untrusteed_Nocat.layer.borderColor = UIColor.init(hexString: OPGreenColor).cgColor
        hasavailableLand(false,button: untrusteed_Nocat)
        trusteed_Nocat.layer.cornerRadius = untrusteed_isCat.bounds.height / 2
        trusteed_Nocat.layer.masksToBounds = true
        trusteed_Nocat.layer.borderWidth = 2
        trusteed_Nocat.layer.borderColor = UIColor.init(hexString: OPGreenColor).cgColor

        hasavailableLand(false,button: trusteed_Nocat)
        // Do any additional setup after loading the view.
    }
    
    func hasavailableLand(_ has: Bool, button: UIButton?) {
        if has {
            button?.isUserInteractionEnabled = true
            button?.backgroundColor = UIColor.init(hexString: OPGreenColor)
            button?.setTitleColor(UIColor.white, for: .normal)
        } else {
            button?.isUserInteractionEnabled = false
            button?.backgroundColor = UIColor.init(hexString: OPGrayColor)
            button?.setTitleColor(UIColor.init(hexString: OPDarkGreenColor), for: .normal)
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        prepareLandData()
    }
    
    func prepareLandData(){
        OPLoadingHUD.show(UIImage(named: "hud_loading"), title: "Loading", animated: true, delay: 0.0)
        guard let urlGroups = farm?.lands?.allObjects as? [LandURL] else {
            OPLoadingHUD.hide()
            return
        }
        landGroupId?.removeAll()
        for landUrl in urlGroups {
            if let groupId = landUrl.url?.components(separatedBy: "/")[4], let idInt64 = Int64(groupId) {
                self.landGroupId?.append(idInt64)
            }
        }
        guard let _  = landGroupId else {
            OPLoadingHUD.hide()
            return
        }

        OPDataService.sharedInstance.getLandByGroup(landGroupId) { [weak self](success, error) in
            self?.landsDir?.removeAll()
            guard let lands = OPDataService.sharedInstance.fetchLandByPredication(self?.landGroupId) else {
                OPLoadingHUD.hide()
                return
            }
            for land in lands {
                if land.is_trusteed && land.cat { //有棚托管
                    var landArray = self?.landsDir?[LandType.trusteedCat.rawValue] as? [Land]
                    if landArray == nil {
                        landArray = [Land]()
                    }
                    landArray?.append(land)
                    self?.landsDir?[LandType.trusteedCat.rawValue] = landArray
                    self?.hasavailableLand(true, button: self?.trusteed_isCat)
                } else if land.is_trusteed && !land.cat {//有棚非托管
                    var landArray = self?.landsDir?[LandType.trusteedNocat.rawValue] as? [Land]
                    if landArray == nil {
                        landArray = [Land]()
                    }
                    landArray?.append(land)
                    self?.landsDir?[LandType.trusteedNocat.rawValue] = landArray
                    self?.hasavailableLand(true, button: self?.trusteed_Nocat)
                } else if !land.is_trusteed && land.cat {//无棚托管
                    var landArray = self?.landsDir?[LandType.untrusteedCat.rawValue] as? [Land]
                    if landArray == nil {
                        landArray = [Land]()
                    }
                    landArray?.append(land)
                    self?.landsDir?[LandType.untrusteedCat.rawValue] = landArray
                    self?.hasavailableLand(true, button: self?.untrusteed_isCat)
                } else if !land.is_trusteed && !land.cat {//无棚非托管
                    var landArray = self?.landsDir?[LandType.untrusteedNocat.rawValue] as? [Land]
                    if landArray == nil {
                        landArray = [Land]()
                    }
                    landArray?.append(land)
                    self?.landsDir?[LandType.untrusteedNocat.rawValue] = landArray
                    self?.hasavailableLand(true, button: self?.untrusteed_Nocat)
                }
            }
            OPLoadingHUD.hide()
        }
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
    
    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        landDetiledVC = segue.destination as? OPLandViewController
        guard let identify = segue.identifier else { return }
        switch identify {
        case LandType.trusteedCat.rawValue:
            landDetiledVC?.lands = landsDir?[LandType.trusteedCat.rawValue] as? [Land]
        case LandType.untrusteedCat.rawValue:
            landDetiledVC?.lands = landsDir?[LandType.untrusteedCat.rawValue] as? [Land]
        case LandType.trusteedNocat.rawValue:
            landDetiledVC?.lands = landsDir?[LandType.trusteedNocat.rawValue] as? [Land]
        case LandType.untrusteedNocat.rawValue:
            landDetiledVC?.lands = landsDir?[LandType.untrusteedNocat.rawValue] as? [Land]
        default:
            break
        }
    }

}
