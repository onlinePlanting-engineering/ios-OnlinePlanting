//
//  OPVegetableViewController.swift
//  OnlinePlanting
//
//  Created by IBM on 01/06/2017.
//  Copyright © 2017 onlinePlanting. All rights reserved.
//

import UIKit

enum VegetableViewType: Int {
    case listView, collectionView
}

class OPVegetableViewController: UIViewController {
    
    
    @IBOutlet weak var vegetableSearchBar: UISearchBar!
    fileprivate var type: VegetableViewType = .listView
    fileprivate var vegetableContainerVC: OPVegetableContainerViewController?
    
    lazy var chooseAnimation: CAKeyframeAnimation = {
        let chooseAnimation = CAKeyframeAnimation(keyPath: "transform.scale")
        chooseAnimation.calculationMode = kCAAnimationCubic
        chooseAnimation.values = [0.8,1.0,1.2,1.0]
        chooseAnimation.duration = 0.3
        return chooseAnimation
    }()
    
    lazy var rightCollectionItem: UIBarButtonItem = {
        let collectionImage = UIImage(named: "menu_collection")
        let rightCollectionItem = UIBarButtonItem.createBarButtonItemWithImage(collectionImage!, CGRect(x: 0, y: 0, width: 26, height: 26), self, #selector(changeViewType))
        return rightCollectionItem
    }()
    
    lazy var rightTableItem: UIBarButtonItem = {
        let tableImage = UIImage(named: "menu_list")
        let rightTableItem = UIBarButtonItem.createBarButtonItemWithImage(tableImage!, CGRect(x: 0, y: 0, width: 28, height: 22), self, #selector(changeViewType))
        return rightTableItem
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        
        vegetableSearchBar.delegate = self
        vegetableSearchBar.tintColor = UIColor.init(hexString: OPDarkGreenColor)
        OPDataService.sharedInstance.getVegetableList { (success, error) in
            if success {
                print("fetch vegetables data success")
            } else {
                print("fetch vegetables data failed")
            }
        }
        // Do any additional setup after loading the view.
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        setNavigarationBar()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "vegetableContainer" {
            vegetableContainerVC = segue.destination as? OPVegetableContainerViewController
        }
    }
    
    func setNavigarationBar() {
        UIApplication.shared.statusBarStyle = .default
        navigationController?.navigationBar.titleTextAttributes = [
            NSForegroundColorAttributeName: UIColor.init(hexString: "#2D363C")]
        navigationController?.navigationBar.topItem?.title = "当季蔬菜"
        
        if type == .listView {
            navigationController?.navigationBar.topItem?.rightBarButtonItem = rightTableItem
        } else if type == .collectionView {
            navigationController?.navigationBar.topItem?.rightBarButtonItem = rightCollectionItem
        }
    }

    func changeViewType() {
        if type == .listView {
            navigationController?.navigationBar.topItem?.rightBarButtonItem = rightCollectionItem
            type = .collectionView
            vegetableContainerVC?.swapViewControllers("collectionviewsegue")
        } else if type == .collectionView {
            navigationController?.navigationBar.topItem?.rightBarButtonItem = rightTableItem
            type = .listView
            vegetableContainerVC?.swapViewControllers("listviewsegue")
        }
    }
}

extension OPVegetableViewController: UISearchBarDelegate {
    
    func searchBarTextDidBeginEditing(_ searchBar: UISearchBar) {
        searchBar.showsCancelButton = true
    }
    
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        UIView.animate(withDuration: 0.2) {
            searchBar.showsCancelButton = false
            searchBar.text = ""
            searchBar.endEditing(true)
        }
        vegetableContainerVC?.searchItem("")
    }
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        //
        searchBar.showsCancelButton = false
        
    }
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        vegetableContainerVC?.searchItem(searchBar.text)
    }

}
