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
    
    fileprivate var selectedDataSource = ["A-01","A-02","A-03"]

    override func viewDidLoad() {
        super.viewDidLoad()
        
        setNavigarationBar()
        
        selectedCollectionView.delegate = self
        selectedCollectionView.dataSource = self
        blankShoppingCar.isHidden = true
        confirmButton.layer.cornerRadius = confirmButton.bounds.height / 2
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
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 0
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 4
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        //collectionView.deleteItems(at: [indexPath])
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return UIEdgeInsets.init(top: 0, left: 0, bottom: 0, right: 0)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: 60, height: 32)
        
    }
}


