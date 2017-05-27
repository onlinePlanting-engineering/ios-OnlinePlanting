

import Foundation
import UIKit

protocol presentAnimatorDelegate: NSObjectProtocol {
    func addMaskViewToPrevious()
    func removeMaskViewFromPrevious()
}

class PresentAnimator: NSObject,UIViewControllerAnimatedTransitioning{
    let duration = 0.4
    var originFrame = CGRect.zero
    weak var delegate: presentAnimatorDelegate?
    
    func transitionDuration(using transitionContext: UIViewControllerContextTransitioning?) -> TimeInterval {
        return duration
    }
    
    func animateTransition(using transitionContext: UIViewControllerContextTransitioning) {
        
        let containView = transitionContext.containerView
        let toView = transitionContext.view(forKey: UITransitionContextViewKey.to)!
        let finalFrame = toView.frame
        toView.frame.origin = CGPoint(x: originFrame.origin.x, y: originFrame.origin.y)
        containView.addSubview(toView)
        delegate?.addMaskViewToPrevious()
        UIView.animate(withDuration: duration, animations: {() -> Void in
            toView.frame.origin = CGPoint(x: finalFrame.origin.x, y: finalFrame.origin.y)
            }) { (finished) -> Void in
                transitionContext.completeTransition(true)
        }
    }
}

class DismisssAnimator:NSObject,UIViewControllerAnimatedTransitioning{
    let duration = 0.4
    var originFrame = CGRect.zero
    weak var delegate: presentAnimatorDelegate?
    func transitionDuration(using transitionContext: UIViewControllerContextTransitioning?) -> TimeInterval {
        return duration
    }
    
    func animateTransition(using transitionContext: UIViewControllerContextTransitioning) {
        let containView = transitionContext.containerView
        let toView = transitionContext.view(forKey: UITransitionContextViewKey.to)! //Collection View
        let fromView = transitionContext.view(forKey: UITransitionContextViewKey.from)!
        containView.addSubview(toView)
        containView.bringSubview(toFront: fromView)
        UIView.animate(withDuration: duration, animations: { () -> Void in
            fromView.frame.origin = CGPoint(x: self.originFrame.origin.x, y: self.originFrame.origin.y)
            }) { [weak self] (finished) -> Void in
                self?.delegate?.removeMaskViewFromPrevious()
                transitionContext.completeTransition(true)
        }
    }
}
