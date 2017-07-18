//
//  OPLandViewController.swift
//  OnlinePlanting
//
//  Created by IBM on 5/22/17.
//  Copyright © 2017 onlinePlanting. All rights reserved.
//

import UIKit

class OPLandViewController: UIViewController {
    
    @IBOutlet weak var available: UIImageView!
    @IBOutlet weak var selected: UIImageView!
    @IBOutlet weak var unavailable: UIImageView!
    @IBOutlet weak var selectedCollectionView: UICollectionView!
    @IBOutlet weak var blankShoppingCar: UIView!
    @IBOutlet weak var confirmButton: UIButton!
    
    lazy fileprivate(set) var selectedDataSource = [Meta]()
    fileprivate var pageViewVC: OPLandPageViewController?
    
    var is_trusteed = false
    var cat = false
    var lands: [Land]?
    @IBOutlet weak var landPageControl: UIPageControl!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setNavigarationBar()
        
        selectedCollectionView.delegate = self
        selectedCollectionView.dataSource = self
        blankShoppingCar.isHidden = true
        confirmButton.layer.cornerRadius = confirmButton.bounds.height / 2
        
        guard let count = lands?.count  else { return }
        landPageControl.numberOfPages = count
        if count <= 1 { landPageControl.isHidden = true}
        landPageControl.currentPageIndicatorTintColor = UIColor.init(hexString: OPDarkGreenColor)
    }
    
    deinit {
        NotificationCenter.default.removeObserver(self)
    }
    func updateSelectMetasView(_ meta: Meta?, status: MetaStatus, handler:@escaping ((_ success:Bool, _ count: Int)->())){
        guard let metaData = meta else {
            handler(false, selectedDataSource.count)
            return
        }
        if status == .selected {
            if let index = selectedDataSource.index(of: metaData), index >= 0 {
                handler(false, selectedDataSource.count)
                return
            } else {
                selectedDataSource.append(metaData)
                selectedCollectionView.reloadData()
                handler(true, selectedDataSource.count)
            }
        } else if status == .available {
            if let index = selectedDataSource.index(of: metaData), index >= 0 {
                selectedDataSource.remove(at: index)
                let indexpath = IndexPath.init(item: index, section: 0)
                selectedCollectionView.deleteItems(at: [indexpath])
                handler(true, selectedDataSource.count)
            } else {
                handler(false, selectedDataSource.count)
                return
            }
        }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "landPageView" {
            pageViewVC = segue.destination as? OPLandPageViewController
            pageViewVC?.landsData = lands
            pageViewVC?.parentVC = self
            pageViewVC?.pagedelegate = self
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func setNavigarationBar() {
        guard let backImage = UIImage(named: "back_white") else { return }
        let leftArrowItem = UIBarButtonItem.createBarButtonItemWithImage(backImage, CGRect(x: 0, y: 0, width: 28, height: 30), self, #selector(dismissCurrentView))
        navigationItem.leftBarButtonItem = leftArrowItem
        
    }
    
    func dismissCurrentView(){
        let _ = navigationController?.popViewController(animated: true)
    }
}

extension OPLandViewController: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return selectedDataSource.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "OPLandSelectedCollectionViewCell", for: indexPath) as! OPLandSelectedCollectionViewCell
        cell.updateDataSource(selectedDataSource[indexPath.item])
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 0
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 4
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
        NotificationCenter.default.post(name: Notification.Name(rawValue: "RemoveSelectedMeta"), object: nil, userInfo: ["Meta": selectedDataSource[indexPath.item]])
        selectedDataSource.remove(at: indexPath.item)
        collectionView.deleteItems(at: [indexPath])
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return UIEdgeInsets.init(top: 0, left: 0, bottom: 0, right: 0)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: 60, height: 32)
        
    }
}

extension OPLandViewController: OPLandPageViewControllerDelegate {
    func transitionCompleted(_ currentIndex: Int) {
        landPageControl.currentPage = currentIndex
    }
}


