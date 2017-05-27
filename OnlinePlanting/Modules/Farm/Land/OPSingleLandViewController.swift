//
//  OPSingleLandViewController.swift
//  OnlinePlanting
//
//  Created by IBM on 5/22/17.
//  Copyright © 2017 onlinePlanting. All rights reserved.
//

import UIKit

enum LandStatus: Int {
    case selected, available, unavailable
}

class OPSingleLandViewController: CoreDataCollectionViewController, UICollectionViewDelegateFlowLayout {
    
    let dataSource = ["A-001","A-002","A-003","A-004","A-005","A-006","A-007","A-008","A-009","A-010","A-010","A-011","A-012","A-013","A-014","A-015","A-016"]

    lazy var chooseAnimation: CAKeyframeAnimation = {
        let chooseAnimation = CAKeyframeAnimation(keyPath: "transform.scale")
        chooseAnimation.calculationMode = kCAAnimationCubic
        chooseAnimation.values = [0.8,1.0,1.2,1.0]
        chooseAnimation.duration = 0.3
        return chooseAnimation
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return dataSource.count
    }
}

extension OPSingleLandViewController {
    
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "OPLandCollectionViewCell", for: indexPath) as! OPLandCollectionViewCell
        cell.undateDataSource(dataSource[indexPath.item])
        return cell
    }
    
    override func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let cell = collectionView.cellForItem(at: indexPath) as! OPLandCollectionViewCell
        //add animation
        cell.layer.add(chooseAnimation, forKey: nil)
        guard let name = cell.metasName.text else { return }
        if cell.status == .available {
            cell.status = .selected
            NotificationCenter.default.post(name: NSNotification.Name(rawValue: OPNotificationName.landSelected.rawValue), object: nil, userInfo:["Land" : name, "status": "selected"])
        } else if cell.status == .selected {
            cell.status = .available
            NotificationCenter.default.post(name: NSNotification.Name(rawValue: OPNotificationName.landSelected.rawValue), object: nil, userInfo:["Land" : name, "status": "available"])
        } else {
            return
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: 66, height: 66)
        
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 3
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 3
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return UIEdgeInsets.init(top: 20, left: 20, bottom: 0, right: 20)
    }
}
