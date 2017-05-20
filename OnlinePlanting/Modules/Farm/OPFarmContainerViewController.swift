//
//  OPFarmContainerViewController.swift
//  OnlinePlanting
//
//  Created by IBM on 5/9/17.
//  Copyright © 2017 onlinePlanting. All rights reserved.
//

import UIKit

class OPFarmContainerViewController: UIViewController {
    
    let contentSegue = "contentsegue"
    let commentSegue = "commentsegue"
    let activitySegue = "activitysegue"
    var currentSegue: String?
    
    var contentViewController: OPFarmContentViewController?
    var commentViewController: OPFarmCommentViewController?
    var activityViewController: OPActivityTableViewController?
    var currentViewController: UIViewController?
    var transactionProcess = false
    var farm: Farm?
    weak var delegate: SubScrollDelegate?
    var parentVC: UIViewController?

    override func viewDidLoad() {
        super.viewDidLoad()

        currentSegue = contentSegue
        guard let current = currentSegue else { return }
        performSegue(withIdentifier: current, sender: nil)
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        if segue.identifier == contentSegue {
            contentViewController = segue.destination as? OPFarmContentViewController
            contentViewController?.delegate = parentVC as! SubScrollDelegate?
            contentViewController?.farm = self.farm
        } else if segue.identifier == commentSegue {
            commentViewController = segue.destination as? OPFarmCommentViewController
            commentViewController?.delegate = parentVC as! SubScrollDelegate?
            commentViewController?.farm = self.farm
        } else if segue.identifier == activitySegue {
            activityViewController = segue.destination as? OPActivityTableViewController
            activityViewController?.delegate = parentVC as! SubScrollDelegate?
        }
        
        // If we're going to the first view controller.
        if segue.identifier == contentSegue {
            // If this is not the first time we're loading this.
            if childViewControllers.count > 0 {
                swapFromViewController(childViewControllers.first, toVC: commentViewController)
            } else {
                // If this is the very first time we're loading this we need to do
                // an initial load and not a swap.
                addChildViewController(segue.destination)
                let destView = segue.destination.view
                destView?.autoresizingMask = [.flexibleHeight, .flexibleWidth]
                
                destView?.frame = CGRect.init(x: 0, y: 0, width: view.frame.size.width, height: view.frame.size.height)
                view.addSubview(destView!)
                segue.destination.didMove(toParentViewController: self)
            }
        }    // By definition the second view controller will always be swapped with the
            // first one.
        else if segue.identifier == commentSegue {
            swapFromViewController(childViewControllers.first, toVC: commentViewController)
            
        }
        
        else if segue.identifier == activitySegue {
            swapFromViewController(childViewControllers.first, toVC: activityViewController)
        }
    }
    
    func swapFromViewController(_ fromVC: UIViewController?, toVC: UIViewController?) {
        toVC?.view.frame = CGRect(x: 0, y: 0, width: view.frame.size.width, height: view.frame.size.height)
        
        fromVC?.didMove(toParentViewController: nil)
        guard let fromvc = fromVC, let tovc = toVC else { return }
        addChildViewController(tovc)
        currentViewController = toVC
        transition(from: fromvc, to: tovc, duration: 0, options: .transitionCrossDissolve, animations: nil) { [weak self] (finished) in
            fromvc.removeFromParentViewController()
            tovc.didMove(toParentViewController: self)
            self?.transactionProcess = false
        }
    }
    
    public func swapViewControllers(_ segue: String) {
        if transactionProcess {
            return
        }
        transactionProcess = true
        
        currentSegue = segue
        
        if currentSegue == contentSegue && (contentViewController != nil) {
            swapFromViewController(currentViewController, toVC: contentViewController)
            return
        }
        
        if currentSegue == commentSegue && (commentViewController != nil) {
            swapFromViewController(currentViewController, toVC: commentViewController)
            return
        }
        
        if currentSegue == activitySegue && (activityViewController != nil) {
            swapFromViewController(currentViewController, toVC: activityViewController)
            return
        }
        guard let current = currentSegue else { return }
        performSegue(withIdentifier: current, sender: nil)
    }

}
