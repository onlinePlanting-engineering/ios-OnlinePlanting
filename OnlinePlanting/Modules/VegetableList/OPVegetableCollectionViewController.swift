//
//  OPVegetableCollectionViewController.swift
//  OnlinePlanting
//
//  Created by IBM on 02/06/2017.
//  Copyright © 2017 onlinePlanting. All rights reserved.
//

import UIKit
import CoreData

class OPVegetableCollectionViewController: CoreDataCollectionViewController, UICollectionViewDelegateFlowLayout {
    
    var sourceCell: UICollectionViewCell?
    var originFrame = CGRect.zero
    fileprivate var detailedVc: OPVegetableDetailedViewController?

    lazy var setup: () = {
        let request = NSFetchRequest<NSFetchRequestResult>(entityName: "SeedVegetablesMeta")
        request.sortDescriptors = [NSSortDescriptor(key: "first_letter", ascending: true), NSSortDescriptor(key: "name", ascending: true)]
        self.fetchedResultsController = NSFetchedResultsController(fetchRequest: request, managedObjectContext: appDelegate.dataStack.mainContext, sectionNameKeyPath: "first_letter", cacheName: nil)
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        collectionView?.register( UINib.init(nibName: "OPVegetableCollectionReusableView", bundle: nil), forSupplementaryViewOfKind: UICollectionElementKindSectionHeader, withReuseIdentifier: "OPVegetableCollectionReusableView")
        
        let _  = setup
        // Do any additional setup after loading the view.
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        navigationController?.navigationBar.barTintColor = UIColor.white
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        navigationController?.delegate = self
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "OPVegetableMetaCollectionViewCell", for: indexPath) as! OPVegetableMetaCollectionViewCell
        guard let farmImage = fetchedResultsController?.object(at: indexPath) as? SeedVegetablesMeta else { return cell }
        cell.delegate = self
        cell.updateDataSource(farmImage)
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: UIScreen.main.bounds.width / 2 - 1, height: UIScreen.main.bounds.width / 2 + 38)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForHeaderInSection section: Int) -> CGSize {
        return CGSize.init(width: UIScreen.main.bounds.width, height: 30)
    }
    
    override func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        var headView = OPVegetableCollectionReusableView()
        if kind == UICollectionElementKindSectionHeader {
            headView = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: "OPVegetableCollectionReusableView", for: indexPath) as! OPVegetableCollectionReusableView
            let section = self.fetchedResultsController?.sections?[indexPath.section]
            let meta = section?.objects?.first as? SeedVegetablesMeta
           headView.updateDataSource(meta?.first_letter)
        }
        return headView
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "OPVegetableDetailedViewController" {
            sourceCell = sender as? OPVegetableMetaCollectionViewCell
            detailedVc = segue.destination as? OPVegetableDetailedViewController
            detailedVc?.picture = (sourceCell as? OPVegetableMetaCollectionViewCell)?.collectionImage.image
            guard let cell = sourceCell, let cellindexPath = collectionView?.indexPath(for: cell) else { return }
            let meta = self.fetchedResultsController?.object(at: cellindexPath) as? SeedVegetablesMeta
            detailedVc?.vegetabletitle = meta?.name
        }
    }
    
    override func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        sourceCell = collectionView.cellForItem(at: indexPath)
        guard let original = sourceCell?.frame else { return }
        let cellRect = collectionView.convert(original, to: collectionView)
        let currentScreenCell = collectionView.convert(cellRect, to: view)
        originFrame = currentScreenCell
        let nav = UIStoryboard.init(name: "OPVegetable", bundle: nil).instantiateViewController(withIdentifier: "vegetableDetailNav") as? UINavigationController
        detailedVc = nav?.childViewControllers.first as? OPVegetableDetailedViewController
        detailedVc?.picture = (sourceCell as? OPVegetableMetaCollectionViewCell)?.collectionImage.image
        guard let cell = sourceCell, let cellindexPath = collectionView.indexPath(for: cell) else { return }
        let meta = self.fetchedResultsController?.object(at: cellindexPath) as? SeedVegetablesMeta
        detailedVc?.vegetabletitle = meta?.name
        guard let vegetableNav = detailedVc else { return }
        navigationController?.pushViewController(vegetableNav, animated: true)
    }

}

extension OPVegetableCollectionViewController: OPVegetableMetaTableViewCellDelegate {
    
    func updateVegetableImage(_ meta: SeedVegetablesMeta?, handler: @escaping ((Images?, Bool, NSError?) -> ())) {
        
        guard let groups = meta?.imgs?.allObjects as? [ImageURL], groups.count > 0 else { return }
        if let groupId = groups.first?.url?.components(separatedBy: "/")[3], let idInt64 = Int64(groupId) {
            OPDataService.sharedInstance.getImageGroup(idInt64) { (success, error) in
                if success {
                    if let imageGroup = OPDataService.sharedInstance.fetchImageGroupById(idInt64), imageGroup.count > 0 {
                        handler(imageGroup.first?.imgs?.allObjects.first as? Images, true, nil)
                    } else {
                        handler(nil, false, error)
                    }
                } else {
                    handler(nil, false, error)
                }
            }
        }
    }
}

extension OPVegetableCollectionViewController {
    
    //hide or show the tabbar while scrolling up and down
    override func scrollViewWillBeginDecelerating(_ scrollView: UIScrollView) {
        if scrollView.panGestureRecognizer.translation(in: scrollView).y < 0 {
            showHideTabBar(hidden: true, animated: true)
        }
        else {
            showHideTabBar(hidden: false, animated: true)
        }
    }
    
    func showHideTabBar(hidden hide: Bool, animated: Bool) {
        var originY: CGFloat = 0
        guard let height = collectionView?.frame.height else { return }
        if hide {
            originY = height + 49
        } else {
            originY = height - 4
        }
        
        UIView.animate(withDuration: 0.25, delay: 0, options: .curveEaseIn, animations: {
            self.tabBarController?.tabBar.frame.origin.y = originY
        }, completion: nil)
    }
}

//MARK: UINavigationControllerDelegate
extension OPVegetableCollectionViewController: UINavigationControllerDelegate {
    func navigationController(_ navigationController: UINavigationController, animationControllerFor operation: UINavigationControllerOperation, from fromVC: UIViewController, to toVC: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        // In this method belonging to the protocol UINavigationControllerDelegate you must
        // return an animator conforming to the protocol UIViewControllerAnimatedTransitioning.
        // To perform the Pop in and Out animation PopInAndOutAnimator should be returned
        return PopInAndOutAnimator(operation: operation)
    }
}

//MARK: CollectionPushAndPoppable
extension OPVegetableCollectionViewController: CollectionPushAndPoppable {

  }


