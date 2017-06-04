//
//  OPFarmContainerViewController.swift
//  OnlinePlanting
//
//  Created by IBM on 5/9/17.
//  Copyright © 2017 onlinePlanting. All rights reserved.
//

import UIKit

class OPVegetableContainerViewController: UIViewController {
    
    let listviewSegue = "listviewsegue"
    let collectionviewSegue = "collectionviewsegue"
    var currentSegue: String?
    
    var contentViewController: OPVegetableTableViewController?
    var commentViewController: OPVegetableCollectionViewController?
    var currentViewController: UIViewController?
    var transactionProcess = false
    var parentVC: UIViewController?

    override func viewDidLoad() {
        super.viewDidLoad()

        currentSegue = listviewSegue
        guard let current = currentSegue else { return }
        performSegue(withIdentifier: current, sender: nil)
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        if segue.identifier == listviewSegue {
            contentViewController = segue.destination as? OPVegetableTableViewController
        } else if segue.identifier == collectionviewSegue {
            commentViewController = segue.destination as? OPVegetableCollectionViewController
        }
        
        // If we're going to the first view controller.
        if segue.identifier == listviewSegue {
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
        else if segue.identifier == collectionviewSegue {
            swapFromViewController(childViewControllers.first, toVC: commentViewController)
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
        if segue == currentSegue || transactionProcess {
            return
        }
        transactionProcess = true
        
        currentSegue = segue
        
        if currentSegue == listviewSegue && (contentViewController != nil) {
            swapFromViewController(currentViewController, toVC: contentViewController)
            return
        }
        
        if currentSegue == collectionviewSegue && (commentViewController != nil) {
            swapFromViewController(currentViewController, toVC: commentViewController)
            return
        }
        guard let current = currentSegue else { return }
        performSegue(withIdentifier: current, sender: nil)
    }

}
