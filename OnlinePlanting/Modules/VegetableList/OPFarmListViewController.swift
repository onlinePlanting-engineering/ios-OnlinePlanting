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
    
    var lastPosition: CGFloat = 0
    var originalNavbarHeight:CGFloat = 0.0
    var minimumNavbarHeight:CGFloat = 0
    let duration = 0.5
    fileprivate var farmDetailedVC: OPFarmDetailedViewController?
    lazy var presentAnimator = PresentAnimator()
    lazy var dismissAnimator = DismisssAnimator()
    
    lazy var rightArrowItem: UIBarButtonItem = {
        let searchImage = UIImage(named: "search")
        let rightArrowItem = UIBarButtonItem.createBarButtonItemWithImage(searchImage!, CGRect(x: 0, y: 0, width: 22, height: 22), self, #selector(showSearchBar))
        return rightArrowItem
    }()
    
    lazy var searchView: UIView = {
        let searchView = UIView.init(frame: CGRect(x: 0, y: 0, width: UIScreen.main.bounds.width - 20, height: 32))
        let cancelButton = UIButton.init(frame: CGRect.init(x: 0, y: 0, width: 60, height: 20))
        cancelButton.setAttributedTitle(NSAttributedString.init(string: "Cancel", attributes: [NSForegroundColorAttributeName: UIColor(hexString: OPGreenColor),NSFontAttributeName: UIFont(name: "Helvetica Neue", size: 15)!]), for: .normal)
        let searchBar = UISearchBar(frame: CGRect.init(x: 0, y: 0, width: 280, height: 30))
        searchBar.delegate = self
        searchBar.placeholder = "按照农场名字, 城市查询"
        searchBar.tintColor = UIColor(hexString: OPGreenColor) 
        searchView.addSubview(searchBar)
        searchView.addSubview(cancelButton)
        cancelButton.addTarget(self, action: #selector(closeSearchBar), for: .touchUpInside)
        cancelButton.translatesAutoresizingMaskIntoConstraints = false
        cancelButton.widthAnchor.constraint(equalToConstant: 60).isActive = true
        cancelButton.heightAnchor.constraint(equalToConstant: 20).isActive = true
        cancelButton.centerYAnchor.constraint(equalTo: searchView.centerYAnchor).isActive = true
        cancelButton.trailingAnchor.constraint(equalTo: searchView.trailingAnchor, constant: 0).isActive = true
        cancelButton.titleLabel?.sizeToFit()
        searchBar.translatesAutoresizingMaskIntoConstraints = false
        searchBar.widthAnchor.constraint(equalToConstant: 280).isActive = true
        searchBar.heightAnchor.constraint(equalToConstant: 22).isActive = true
        searchBar.centerYAnchor.constraint(equalTo: searchView.centerYAnchor).isActive = true
        searchBar.centerXAnchor.constraint(equalTo: searchView.centerXAnchor, constant: 0).isActive = true
        return searchView
    }()
    
    lazy var refresh: UIRefreshControl = {
        let refresh = UIRefreshControl()
        refresh.addTarget(self, action: #selector(reloadFarmList), for: .valueChanged)
        return refresh
    }()
    
    lazy var oploadingView: OPLoadingIndicator = {
        let oploadingView = OPLoadingIndicator.init(frame: CGRect(x: 0, y: 0, width: 96, height: 70))
        oploadingView.image = UIImage(named: "hud_loading")
        oploadingView.titleView.text = "Loading"
        oploadingView.titleView.textColor = UIColor.white
        oploadingView.backgroundColor = UIColor.clear
        return oploadingView
    }()
    
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
    
    func prepareUI() {
        let nib = UINib(nibName: "OPFarmTableViewCell", bundle: Bundle.main)
        tableView.register(nib, forCellReuseIdentifier: "OPFarmTableViewCell")
        tableView.delegate = self
        tableView.dataSource = self
        
        tableView.addSubview(refresh)
        OPDataService.sharedInstance.getFarmList() { (success, error) in
            if success {
                print("load farm list success")
            } else {
                print("load farm list failed")
            }
        }
        updateNSPredicate("")
    }
    
    func clearSearchCondition() {
        for view in searchView.subviews {
            if view.isKind(of: UISearchBar.self) {
                    let textField = (view as? UISearchBar)?.value(forKey: "searchField") as! UITextField
                    textField.text = ""
                }
        }
    }
    
    func updateNSPredicate(_ search: String) {
        let request = NSFetchRequest<NSFetchRequestResult>(entityName: "Farm")
        request.sortDescriptors = [NSSortDescriptor(key: "id", ascending: false)]
        if search != "" {
            request.predicate = NSPredicate(format: "name CONTAINS[cd] %@ OR addr CONTAINS[cd] %@", search, search)
        }
        self.fetchedResultsController = NSFetchedResultsController(fetchRequest: request, managedObjectContext: appDelegate.dataStack.mainContext, sectionNameKeyPath: nil, cacheName: nil)
    }
    
    func reloadFarmList() {
        refresh.beginRefreshing()
        OPDataService.sharedInstance.getFarmList() { [weak self] (success, error) in
            if success {
                print("load farm list success")
            } else {
                print("load farm list failed")
            }
            self?.refresh.endRefreshing()
        }
    }
    
    
    func setNavigarationBar() {
        navigationController?.navigationBar.isTranslucent = false
        navigationController?.navigationBar.titleTextAttributes = [
            NSForegroundColorAttributeName: UIColor.init(hexString: "#2D363C")]
        navigationController?.navigationBar.topItem?.title = "入住农场"
        
        navigationController?.navigationBar.topItem?.rightBarButtonItem = rightArrowItem
        navigationController?.navigationBar.topItem?.leftBarButtonItem = nil
    }
    
    func showSearchBar() {
       navigationController?.navigationBar.topItem?.titleView = searchView
        navigationController?.navigationBar.topItem?.rightBarButtonItem = nil
    }
    
    func closeSearchBar() {
        clearSearchCondition()
        UIView.animate(withDuration: 0.3) { [weak self] in
            self?.updateNSPredicate("")
            self?.navigationController?.navigationBar.topItem?.titleView = nil
            self?.navigationController?.navigationBar.topItem?.rightBarButtonItem = self?.rightArrowItem
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        UIApplication.shared.statusBarStyle = .default
        setNavigarationBar()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
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
        return 340
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "OPFarmTableViewCell", for: indexPath as IndexPath) as! OPFarmTableViewCell
        guard let farm = fetchedResultsController?.object(at: indexPath) as? Farm else { return cell }
        cell.updateBasicDataSource(farm)
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let nav = storyboard?.instantiateViewController(withIdentifier: "farmDetailedNav") as? UINavigationController
        farmDetailedVC = nav?.childViewControllers.first as? OPFarmDetailedViewController
        nav?.transitioningDelegate = self
        let cell = tableView.cellForRow(at: indexPath) as! OPFarmTableViewCell
        guard let farm = fetchedResultsController?.object(at: indexPath) as? Farm else { return }
        farmDetailedVC?.newImage = cell.framImage.image
        farmDetailedVC?.farmData = farm
        let cellRect = tableView.convert(cell.frame, to: tableView)
        let currentScreenCell = tableView.convert(cellRect, to: tableView.backgroundView!)
        presentAnimator.originFrame = currentScreenCell
        dismissAnimator.originFrame = currentScreenCell
        guard let navigatVc = nav else { return }
        present(navigatVc, animated: true, completion: nil)
        cell.setSelected(false, animated: true)
    }
    
    override func controllerDidChangeContent(_ controller: NSFetchedResultsController<NSFetchRequestResult>) {
        super.controllerDidChangeContent(controller)
        
    }
    
    override func scrollViewWillBeginDragging(_ scrollView: UIScrollView) {
        closeSearchBar()
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

extension OPFarmListViewController: UISearchBarDelegate {
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        print("test is:\(searchText)")
        updateNSPredicate(searchText)
    }
}
