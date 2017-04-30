//
//  OPToastWindow.swift
//  OnlinePlanting
//
//  Created by IBM on 4/30/17.
//  Copyright © 2017 onlinePlanting. All rights reserved.
//

import UIKit

class OPToastWindow: UIWindow {
    
    var animationDuration: TimeInterval = 0.2
    fileprivate var timer: DispatchSource?
    static var toasViewController: OPToastViewController?
    
    static let sharedWindow: OPToastWindow = {
        let window = OPToastWindow(frame: UIScreen.main.bounds)
        window.windowLevel = UIWindowLevelAlert + 1
        window.makeKeyAndVisible()
        toasViewController = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "ToasViewController") as? OPToastViewController
        window.rootViewController = toasViewController
        return window
    }()
    
    static func show(_ image: UIImage?, title: String?, content: String?) {
        let _  = sharedWindow
        toasViewController?.toastViewImage.image = image
        toasViewController?.toastTitle.text = title
        toasViewController?.toastLabel.text = content
        let queue = DispatchQueue(label: "com.example.imagetransform")
        queue.async {
            DispatchQueue.main.async {
                sharedWindow.show()
            }
        }
    }
    
    fileprivate func show() {
        self.transform = CGAffineTransform.init(scaleX: 0.1, y: 0.1)
        UIView.animate(withDuration: 0.5, delay: 0, usingSpringWithDamping: 0.5, initialSpringVelocity: 0.6, options: .curveEaseInOut, animations: {
            self.transform = CGAffineTransform.init(scaleX: 1, y: 1)
            self.alpha = 1.0
        }, completion: nil)
    }
    
    static func hide() {
        OPToastWindow.sharedWindow.hide()
    }
    
    fileprivate func hide() {
        UIView.animate(withDuration: 0.5, delay: 0, usingSpringWithDamping: 0.5, initialSpringVelocity: 0.6, options: .curveEaseInOut, animations: {
            self.transform = CGAffineTransform.init(scaleX: 0.1, y: 0.1)
            self.alpha = 0.0
        }, completion: nil)

    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        if !isHidden {
            hide()
            if let timer = timer {
                timer.cancel()
            }
        }
    }
}

class OPToastViewController: UIViewController {
    
    @IBOutlet weak var toastViewImage: UIImageView!
    @IBOutlet weak var toastTitle: UILabel!
    @IBOutlet weak var toastLabel: UILabel!
    @IBOutlet weak var toastContainerView: UIView!
    @IBOutlet weak var toastDismissView: UIButton!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
     
        prepareUI()
    }
    
    func prepareUI() {
        toastContainerView.layer.cornerRadius = 10
        toastContainerView.layer.masksToBounds = true
        
        toastViewImage.layer.cornerRadius = 10
        toastViewImage.layer.masksToBounds = true
        
        toastDismissView.layer.borderWidth = 0
        toastDismissView.layer.cornerRadius = toastDismissView.bounds.height / 2
        toastDismissView.layer.masksToBounds = true
    }
    
    @IBAction func dismissWindow(_ sender: UIButton) {
        OPToastWindow.hide()
    }
    
}
