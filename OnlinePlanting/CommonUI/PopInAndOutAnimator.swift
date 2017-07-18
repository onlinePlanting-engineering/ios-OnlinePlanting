//
//  OPLoadingIndicator.swift
//  cellWebview
//
//  Created by IBM on 5/10/17.
//  Copyright © 2017 onlinePlanting. All rights reserved.
//

import Foundation
import UIKit

class PopInAndOutAnimator: NSObject, UIViewControllerAnimatedTransitioning {
    
    fileprivate let _operationType : UINavigationControllerOperation
    fileprivate let _transitionDuration : TimeInterval
    
    init(operation: UINavigationControllerOperation) {
        _operationType = operation
        _transitionDuration = 0.6
    }
    
    init(operation: UINavigationControllerOperation, andDuration duration: TimeInterval) {
        _operationType = operation
        _transitionDuration = duration
    }
    
    //MARK: Push and Pop animations performers
    internal func performPushTransition(_ transitionContext: UIViewControllerContextTransitioning) {
        guard let toView = transitionContext.view(forKey: UITransitionContextViewKey.to) else {
                // Something really bad happend and it is not possible to perform the transition
                print("ERROR: Transition impossible to perform since either the destination view or the conteiner view are missing!")
                return
        }
        
        let container = transitionContext.containerView
        guard let parentVC = transitionContext.viewController(forKey: UITransitionContextViewControllerKey.from) as? OPTabBarController,
            let fromViewController = parentVC.childViewControllers[2].childViewControllers.first?.childViewControllers.first as? OPVegetableCollectionViewController,
            let currentCell = fromViewController.sourceCell else {
                // There are not enough info to perform the animation but it is still possible
                // to perform the transition presenting the destination view
                container.addSubview(toView)
                transitionContext.completeTransition(!transitionContext.transitionWasCancelled)
            return
        }
        
        let finalFrame = toView.frame
        if currentCell.frame.origin.x > 0 {
            toView.frame.origin = CGPoint(x: fromViewController.originFrame.origin.x , y: fromViewController.originFrame.origin.y + 64)
        } else {
            toView.frame.origin = CGPoint(x: -UIScreen.main.bounds.width / 2 , y: fromViewController.originFrame.origin.y + 64)
        }
        // Add to container the destination view
        container.addSubview(toView)
        
        UIView.animate(withDuration: _transitionDuration, delay: 0, usingSpringWithDamping: 0.9, initialSpringVelocity: 0, options: [], animations: { () -> Void in
            toView.frame.origin = CGPoint(x: finalFrame.origin.x , y: finalFrame.origin.y + 64)
            }) { _ in
                transitionContext.completeTransition(!transitionContext.transitionWasCancelled)
                
        }
    }
    
    internal func performPopTransition(_ transitionContext: UIViewControllerContextTransitioning) {
        
        guard let toView = transitionContext.view(forKey: UITransitionContextViewKey.to) else {
                // Something really bad happend and it is not possible to perform the transition
                print("ERROR: Transition impossible to perform since either the destination view or the conteiner view are missing!")
                return
        }
        
        let container = transitionContext.containerView
        
        guard let originalParent = transitionContext.viewController(forKey: UITransitionContextViewControllerKey.to) as? OPTabBarController,
            let toViewController = originalParent.childViewControllers[2].childViewControllers.first?.childViewControllers.first as? OPVegetableCollectionViewController,
            let toCollectionView = toViewController.collectionView,
            let fromViewController = transitionContext.viewController(forKey: UITransitionContextViewControllerKey.from),
            let fromView = fromViewController.view,
            let currentCell = toViewController.sourceCell else {
                // There are not enough info to perform the animation but it is still possible
                // to perform the transition presenting the destination view
                container.addSubview(toView)
                transitionContext.completeTransition(!transitionContext.transitionWasCancelled)
                return
        }
        
        // Add destination view to the container view
        container.addSubview(toView)
        
        // Prepare the screenshot of the source view for animation
        let screenshotFromView = UIImageView(image: fromView.screenshot)
        screenshotFromView.frame = fromView.frame
        
        // Prepare the screenshot of the destination view for animation
        let screenshotToView = UIImageView(image: currentCell.screenshot)
        screenshotToView.frame = screenshotFromView.frame
        
        // Add screenshots to transition container to set-up the animation
        container.addSubview(screenshotToView)
        container.insertSubview(screenshotFromView, belowSubview: screenshotToView)
        
        // Set views initial states
        screenshotToView.alpha = 0.0
        fromView.isHidden = true
        currentCell.isHidden = true
        
        let containerCoord = toCollectionView.convert(currentCell.frame.origin, to: container)
        
        UIView.animate(withDuration: _transitionDuration, delay: 0, usingSpringWithDamping: 0.9, initialSpringVelocity: 0, options: [], animations: { () -> Void in
            
            screenshotToView.alpha = 1.0
            screenshotFromView.frame = currentCell.frame
            screenshotFromView.frame.origin = containerCoord
            screenshotToView.frame = screenshotFromView.frame
            
            }) { _ in
                
                currentCell.isHidden = false
                screenshotFromView.removeFromSuperview()
                screenshotToView.removeFromSuperview()
                transitionContext.completeTransition(!transitionContext.transitionWasCancelled)
                
        }
    }
    
    //MARK: UIViewControllerAnimatedTransitioning
    func transitionDuration(using transitionContext: UIViewControllerContextTransitioning?) -> TimeInterval {
        return _transitionDuration
    }
    
    func animateTransition(using transitionContext: UIViewControllerContextTransitioning) {
        if _operationType == .push {
            performPushTransition(transitionContext)
        } else if _operationType == .pop {
            performPopTransition(transitionContext)
        }
    }
}
