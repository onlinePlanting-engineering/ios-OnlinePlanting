//
//  OPVegetableListViewController.swift
//  OnlinePlanting
//
//  Created by Alex on 4/27/17.
//  Copyright © 2017 onlinePlanting. All rights reserved.
//

import UIKit
import CoreData

class OPFarmListViewController: CoreDataTableViewController {
    
    
    @IBOutlet weak var farmTableview: UITableView!
    //@IBOutlet var containerView: UIView!
    var lastPosition: CGFloat = 0
    var originalNavbarHeight:CGFloat = 0.0
    var minimumNavbarHeight:CGFloat = 0
    let duration = 0.5
    fileprivate var farmDetailedVC: OPFarmDetailedViewController?
    lazy var presentAnimator = PresentAnimator()
    lazy var dismissAnimator = DismisssAnimator()
    
    lazy var maskView: UIView = {
        let maskView = UIView()
        maskView.backgroundColor = UIColor.darkGray
        maskView.frame = UIScreen.main.bounds
        return maskView
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        prepareUI()
        // Do any additional setup after loading the view.
    }
    
    lazy var setup: () = {
        let request = NSFetchRequest<NSFetchRequestResult>(entityName: "Farm")
        request.sortDescriptors = [NSSortDescriptor(key: "id", ascending: false)]
        self.fetchedResultsController = NSFetchedResultsController(fetchRequest: request, managedObjectContext: appDelegate.dataStack.mainContext, sectionNameKeyPath: nil, cacheName: nil)
    }()
    
    func prepareUI() {
        
        navigationController?.navigationBar.setBackgroundImage(UIImage(), for: UIBarMetrics.default)
        navigationController?.navigationBar.shadowImage = UIImage()
        navigationController?.navigationBar.isTranslucent = true
        
        guard let search = UIImage(named: "logo") else { return }
        let rightArrowItem = UIBarButtonItem.createBarButtonItemWithImage(search, CGRect(x: 0, y: 0, width: 28, height: 30), self, #selector(dismissSearchView))
        navigationItem.leftBarButtonItem = rightArrowItem
        
        
        let nib = UINib(nibName: "OPFarmTableViewCell", bundle: Bundle.main)
        farmTableview.register(nib, forCellReuseIdentifier: "OPFarmTableViewCell")
        farmTableview.delegate = self
        farmTableview.dataSource = self
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        let _ = setup
        
        OPDataService.sharedInstance.getFarmList() { (success, error) in
            if success {
                print("load farm list success")
            } else {
                print("load farm list failed")
            }
        }
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func dismissSearchView() {
        
    }
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 315
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = farmTableview.dequeueReusableCell(withIdentifier: "OPFarmTableViewCell", for: indexPath as IndexPath) as! OPFarmTableViewCell
        guard let farm = fetchedResultsController?.object(at: indexPath) as? Farm else { return cell }
        cell.updateDataSource(farm)
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let nav = storyboard?.instantiateViewController(withIdentifier: "farmDetailedNav") as? UINavigationController
        farmDetailedVC = nav?.childViewControllers.first as? OPFarmDetailedViewController
        nav?.transitioningDelegate = self
        let cell = farmTableview.cellForRow(at: indexPath) as! OPFarmTableViewCell
        guard let farm = fetchedResultsController?.object(at: indexPath) as? Farm else { return }
        farmDetailedVC?.newImage = cell.framImage.image
        farmDetailedVC?.farmData = farm
        let cellRect = farmTableview.convert(cell.frame, to: farmTableview)
        let currentScreenCell = farmTableview.convert(cellRect, to: view)
        presentAnimator.originFrame = currentScreenCell
        dismissAnimator.originFrame = currentScreenCell
        guard let navigatVc = nav else { return }
        present(navigatVc, animated: true, completion: nil)
        cell.setSelected(false, animated: true)
    }
    
    override func controllerDidChangeContent(_ controller: NSFetchedResultsController<NSFetchRequestResult>) {
        super.controllerDidChangeContent(controller)
        
    }
}

extension OPFarmListViewController: UIViewControllerTransitioningDelegate {
    
    func animationController(forDismissed dismissed: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        return dismissAnimator
    }
    
    func animationController(forPresented presented: UIViewController, presenting: UIViewController, source: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        return presentAnimator
    }
}

extension OPFarmListViewController {

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
        if hide {
            originY = (self.view.frame.height)
        } else {
            originY = (self.view.frame.height) - 49
        }
        
        UIView.animate(withDuration: 0.25, delay: 0, options: .curveEaseIn, animations: {
            self.tabBarController?.tabBar.frame.origin.y = originY
        }, completion: nil)
    }
}

extension OPFarmListViewController: presentAnimatorDelegate {
    func addMaskViewToPrevious() {
        navigationController?.view.addSubview(maskView)
    }
    
    func removeMaskViewFromPrevious() {
        maskView.removeFromSuperview()
    }
}
