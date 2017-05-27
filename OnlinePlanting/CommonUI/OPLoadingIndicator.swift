//
//  OPLoadingIndicator.swift
//  cellWebview
//
//  Created by IBM on 5/10/17.
//  Copyright © 2017 onlinePlanting. All rights reserved.
//

import UIKit

@IBDesignable
class OPLoadingIndicator: UIView {
    
    var isAnimating = false
    
    lazy var imageView: UIImageView = {
        let imageView = UIImageView()
        imageView.image = self.image
        self.addSubview(imageView)
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.centerXAnchor.constraint(equalTo: self.centerXAnchor).isActive = true
        imageView.topAnchor.constraint(equalTo: self.topAnchor, constant: 5).isActive = true
        imageView.heightAnchor.constraint(equalToConstant: 36).isActive = true
        imageView.widthAnchor.constraint(equalToConstant: 36).isActive = true
        return imageView
    }()
    
    lazy var titleView: UILabel = {
        let titleView = UILabel()
        titleView.font = UIFont(name: "Helvetica Neue", size: 14)
        titleView.textAlignment = .center
        titleView.text = "Loading"
        self.addSubview(titleView)
        titleView.translatesAutoresizingMaskIntoConstraints = false
        titleView.centerXAnchor.constraint(equalTo: self.centerXAnchor).isActive = true
        titleView.topAnchor.constraint(equalTo: self.topAnchor, constant: 46).isActive = true
        return titleView
    }()

    
    @IBInspectable var image: UIImage? {
        didSet {
            let _ = imageView
        }
    }
    
    @IBInspectable var titleColor: UIColor? {
        didSet {
            titleView.textColor = titleColor
        }
    }
    
    override func draw(_ rect: CGRect) {
        layer.cornerRadius = 10
        layer.masksToBounds = true
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
    }
    
    convenience init(_ title: String?, frame: CGRect) {
        self.init()
        titleView.text = title
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        
    }
    
    open func startAnimating() {
        if isAnimating { return }
        isAnimating = true
        let animation = CABasicAnimation(keyPath: "transform.rotation")
        animation.toValue = 2*Double.pi
        animation.duration = 1
        animation.repeatCount = .infinity
        imageView.layer.add(animation, forKey: nil)
        transform = CGAffineTransform.init(scaleX: 0.0, y: 0.0)
        UIView.animate(withDuration: 0.2) { [weak self] in
            self?.transform = CGAffineTransform.init(scaleX: 1.0, y: 1.0)
            self?.alpha = 0.75
        }
    }
    
    open func stopAnimating() {
        if !isAnimating { return }
        isAnimating = false
        transform = CGAffineTransform.init(scaleX: 1.0, y: 1.0)
        UIView.animate(withDuration: 0.2, animations: { [weak self] in
            self?.alpha = 0.0
             self?.transform = CGAffineTransform.init(scaleX: 0.0, y: 0.0)
        }) { [weak self](finished) in
            self?.imageView.layer.removeAllAnimations()
        }
    }

}
