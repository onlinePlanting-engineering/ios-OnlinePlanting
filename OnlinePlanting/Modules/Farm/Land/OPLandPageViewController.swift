//
//  OPLandPageViewController.swift
//  OnlinePlanting
//
//  Created by IBM on 5/22/17.
//  Copyright © 2017 onlinePlanting. All rights reserved.
//

import UIKit

class OPLandPageViewController: UIPageViewController {
    
    var landGroup = [OPSingleLandViewController]()
    var landsData: [Land]?
    var parentVC: OPLandViewController?
    
    
    var currentIndex: Int? {
        guard let viewController = viewControllers?.first as? OPSingleLandViewController else {
            return nil
        }
        
        return landGroup.index(of: viewController)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        prepareData()
    }
    
    func prepareData(){
        guard let lands  = landsData, lands.count > 0 else { return }
        for land in lands {
            let singleVC = UIStoryboard.init(name: "OPFarm", bundle: nil).instantiateViewController(withIdentifier: "OPSingleLandViewController") as! OPSingleLandViewController
            singleVC.land = land
            singleVC.delegate = self
            landGroup.append(singleVC)
        }
        setupPageViewController(0)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    private func setupPageViewController(_ index: Int) {
        dataSource = self
        delegate = self
        automaticallyAdjustsScrollViewInsets = false
        
        setViewControllers([landGroup[index]],
                           direction: .forward,
                           animated: false,
                           completion: nil)
    }
    
    func nextViewController(_ viewController: UIViewController, isAfter: Bool) -> UIViewController? {
        guard let wholeWebView = viewController as? OPSingleLandViewController else { return nil }
        if var index = landGroup.index(of: wholeWebView) {
            index += isAfter ? 1 : -1
            if index >= 0 && index < landGroup.count {
                return landGroup[index]
            }
        }
        return nil
    }
}

extension OPLandPageViewController: UIPageViewControllerDataSource {
    
    func pageViewController(_ pageViewController: UIPageViewController, viewControllerBefore viewController: UIViewController) -> UIViewController? {
        return nextViewController(viewController, isAfter: false)
    }
    
    func pageViewController(_ pageViewController: UIPageViewController, viewControllerAfter viewController: UIViewController) -> UIViewController? {
        return nextViewController(viewController, isAfter: true)
    }
}

extension OPLandPageViewController: UIPageViewControllerDelegate {
    func pageViewController(_ pageViewController: UIPageViewController, willTransitionTo pendingViewControllers: [UIViewController]) {
        //pageDelegate?.willTransition()
    }
    
    func pageViewController(_ pageViewController: UIPageViewController, didFinishAnimating finished: Bool, previousViewControllers: [UIViewController], transitionCompleted completed: Bool) {
        if finished {
            if let currentIndex = currentIndex, currentIndex < landGroup.count {
//                pageDelegate?.transitionCompleted(currentIndex, pageItem: pageItems?[currentIndex], firstUrl: pageItems?.first?.pageUrl )
            }
        }
    }
}

extension OPLandPageViewController: OPSingleLandViewControllerDelegate {
    func updateSelectedMetas(_ meta: Meta?, status: MetaStatus, handler: @escaping ((Bool, Int) -> ())) {
        parentVC?.updateSelectMetasView(meta, status: status, handler: { (success, count) in
            handler(success, count)
        })
    }
    
    func getSelectedMetasNumber() -> Int {
        guard let number = parentVC?.selectedDataSource.count else { return 0}
        return number
    }
}
