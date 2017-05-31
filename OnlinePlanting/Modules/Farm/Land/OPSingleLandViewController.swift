//
//  OPSingleLandViewController.swift
//  OnlinePlanting
//
//  Created by IBM on 5/22/17.
//  Copyright © 2017 onlinePlanting. All rights reserved.
//

import UIKit
import CoreData

enum MetaStatus: Int {
    case selected, available, unavailable
}

var MAX_META = 3

protocol OPSingleLandViewControllerDelegate: NSObjectProtocol {
    func updateSelectedMetas(_ meta: Meta?, status: MetaStatus, handler:@escaping ((_ success:Bool, _ count: Int)->()))
    func getSelectedMetasNumber()->Int
}

class OPSingleLandViewController: CoreDataCollectionViewController, UICollectionViewDelegateFlowLayout {
    
    var land: Land?
    weak var delegate: OPSingleLandViewControllerDelegate?

    lazy var chooseAnimation: CAKeyframeAnimation = {
        let chooseAnimation = CAKeyframeAnimation(keyPath: "transform.scale")
        chooseAnimation.calculationMode = kCAAnimationCubic
        chooseAnimation.values = [0.8,1.0,1.2,1.0]
        chooseAnimation.duration = 0.3
        return chooseAnimation
    }()
    
    lazy var setup:() = {
        let request = NSFetchRequest<NSFetchRequestResult>(entityName: "Meta")
        request.sortDescriptors = [NSSortDescriptor(key: "land", ascending: false)]
        guard let id = self.land?.id else { return }
        request.predicate = NSPredicate(format:"land == %lld",id)
        self.fetchedResultsController = NSFetchedResultsController(fetchRequest: request, managedObjectContext: appDelegate.dataStack.mainContext, sectionNameKeyPath: nil, cacheName: nil)
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let _  = setup
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
}

extension OPSingleLandViewController {
    
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "OPLandCollectionViewCell", for: indexPath) as! OPLandCollectionViewCell
        guard let meta = fetchedResultsController?.object(at: indexPath) as? Meta else { return cell }
        cell.undateDataSource(meta)
        return cell
    }
    
    override func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let cell = collectionView.cellForItem(at: indexPath) as! OPLandCollectionViewCell
        //add animation
        if cell.status == .unavailable {
            OPLoadingHUD.show(UIImage(named: "land_unavailable"), title: "已经被租用", animated: false, delay: 1)
            return
        }
        
        guard let meta = fetchedResultsController?.object(at: indexPath) as? Meta else { return }
        if cell.status == .available {
            if  delegate?.getSelectedMetasNumber() == MAX_META {
                OPLoadingHUD.show(UIImage(named: "land_selected"), title: "最多选3块", animated: false, delay: 1)
                return
            }
            cell.layer.add(chooseAnimation, forKey: nil)
            cell.status = .selected
            delegate?.updateSelectedMetas(meta, status: .selected, handler: { (success, count) in
                //TODO:
                
            })
        } else if cell.status == .selected {
            cell.layer.add(chooseAnimation, forKey: nil)
            cell.status = .available
            delegate?.updateSelectedMetas(meta, status: .available, handler: { (success, count) in
                //TODO:
            })
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
