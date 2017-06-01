//
//  OPLoadingHUD.swift
//  OnlinePlanting
//
//  Created by IBM on 5/7/17.
//  Copyright © 2017 onlinePlanting. All rights reserved.
//

import UIKit

class OPLoadingHUD: UIWindow {
    
    fileprivate lazy var loadingView: OPLoadingView = {
        let loadingView = OPLoadingView(frame: CGRect(x: 0, y: 0, width: 128, height: 80))
        loadingView.translatesAutoresizingMaskIntoConstraints = false
        
        return loadingView
    }()

    static let sharedWindow: OPLoadingHUD = {
        let window = OPLoadingHUD(frame: UIScreen.main.bounds)
        window.windowLevel = UIWindowLevelAlert + 1
        window.makeKeyAndVisible()
        window.rootViewController = UIViewController()
        return window
    }()
    
    
    
    static func show(_ image: UIImage?, title: String?, animated: Bool, delay: Double) {
        let queue = DispatchQueue(label: "com.example.imagetransform")
        queue.async {
            DispatchQueue.main.async {
                sharedWindow.show(image, title: title, animated: animated, delay: delay)
            }
        }
    }
    
    fileprivate func show(_ image: UIImage?, title: String?, animated: Bool, delay: Double) {
        self.transform = CGAffineTransform.init(scaleX: 0.0, y: 0.0)
        loadingView.icon = image
        loadingView.loadingTitle.text = title
        self.isHidden = false
        if delay != 0.0 {
            DispatchQueue.main.asyncAfter(deadline: .now() + delay, execute: {
                OPLoadingHUD.sharedWindow.hide()
            })
        }
        UIView.animate(withDuration: 0.2) { [weak self] in
            self?.transform = CGAffineTransform.init(scaleX: 1, y: 1)
            self?.alpha = 1.0
            self?.loadingView.loadingImage.startLoadingAnimation(animated)
        }
    }
    
    static func hide() {
        sharedWindow.hide()
    }
    
    fileprivate func hide() {
        loadingView.startLoadingAnimation(false)
        UIView.animate(withDuration: 0.2, animations: {[weak self] in
            self?.transform = CGAffineTransform.init(scaleX: 0.1, y: 0.1)
            self?.alpha = 0.0
        }, completion: { [weak self](finished) in
            self?.isHidden = true
        })
        
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        addSubview(loadingView)
        loadingView.centerXAnchor.constraint(equalTo: self.centerXAnchor).isActive = true
        loadingView.centerYAnchor.constraint(equalTo: self.centerYAnchor).isActive = true
        loadingView.heightAnchor.constraint(equalToConstant: 80).isActive = true
        loadingView.widthAnchor.constraint(equalToConstant: 128).isActive = true
        
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
//    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
//        if !isHidden {
//            hide()
////            if let timer = timer {
////                timer.cancel()
////            }
//        }
//    }
}

class OPLoadingView: UIView {
    
    var icon: UIImage? {
        didSet {
            //update icon image
            loadingImage.image = icon
        }
    }
    
    private lazy var backGroundView: UIView = {
        let backGroundView = UIView()
        backGroundView.layer.cornerRadius = 10
        backGroundView.backgroundColor = UIColor.black
        backGroundView.alpha = 0.7
        return backGroundView
    }()
    
    lazy var loadingImage: UIImageView = {
        let loadingImage = UIImageView()
        return loadingImage
    }()
    
    lazy var loadingTitle: UILabel = {
        let label = UILabel()
        label.numberOfLines = 0
        label.lineBreakMode = .byWordWrapping
        label.font = UIFont(name: "Helvetica Neue", size: 16)
        label.text = "Saving Profile"
        label.textColor = UIColor.white
        return label
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        addSubview(backGroundView)
        addSubview(loadingTitle)
        addSubview(loadingImage)
        backGroundView.frame = bounds
        backGroundView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        loadingTitle.translatesAutoresizingMaskIntoConstraints = false
        loadingImage.translatesAutoresizingMaskIntoConstraints = false
        loadingImage.centerXAnchor.constraint(equalTo: self.centerXAnchor).isActive = true
        loadingImage.topAnchor.constraint(equalTo: self.topAnchor, constant: 10).isActive = true
        loadingImage.heightAnchor.constraint(equalToConstant: 38).isActive = true
        loadingImage.widthAnchor.constraint(equalToConstant: 38).isActive = true
        
        loadingTitle.centerXAnchor.constraint(equalTo: self.centerXAnchor).isActive = true
        loadingTitle.topAnchor.constraint(equalTo: loadingImage.bottomAnchor, constant: 10).isActive = true
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
