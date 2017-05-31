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
    
    @IBAction func showinsideLand(_ sender: UIButton) {
        
    }
    
    
    @IBAction func showoutsideLand(_ sender: UIButton) {
        
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        landGroupId = [Int64]()
        landsDir = [String:[Land]]()
        setNavationBar()
        
        // Do any additional setup after loading the view.
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        prepareLandData()
    }
    
    func prepareLandData(){
        OPLoadingHUD.show(UIImage(named: "hud_loading"), title: "Loading", animated: true, delay: 0.0)
        guard let urlGroups = farm?.lands?.allObjects as? [LandURL] else { return }
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
                    //TODO: update UI
                } else if land.is_trusteed && !land.cat {//有棚非托管
                    var landArray = self?.landsDir?[LandType.trusteedNocat.rawValue] as? [Land]
                    if landArray == nil {
                        landArray = [Land]()
                    }
                    landArray?.append(land)
                    self?.landsDir?[LandType.trusteedNocat.rawValue] = landArray
                    //TODO: update UI
                } else if !land.is_trusteed && land.cat {//无棚托管
                    var landArray = self?.landsDir?[LandType.untrusteedCat.rawValue] as? [Land]
                    if landArray == nil {
                        landArray = [Land]()
                    }
                    landArray?.append(land)
                    self?.landsDir?[LandType.untrusteedCat.rawValue] = landArray
                    //TODO: update UI
                } else if !land.is_trusteed && !land.cat {//无棚非托管
                    var landArray = self?.landsDir?[LandType.untrusteedNocat.rawValue] as? [Land]
                    if landArray == nil {
                        landArray = [Land]()
                    }
                    landArray?.append(land)
                    self?.landsDir?[LandType.untrusteedNocat.rawValue] = landArray
                    //TODO: update UI
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
        if segue.identifier == "landDetailed" {
            landDetiledVC = segue.destination as? OPLandViewController
            landDetiledVC?.lands = landsDir?[LandType.trusteedCat.rawValue] as? [Land]
        }
    }

}
