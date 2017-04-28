//
//  OPLoginViewController.swift
//  OnlinePlanting
//
//  Created by Alex on 4/27/17.
//  Copyright © 2017 onlinePlanting. All rights reserved.
//

import UIKit

enum OPTextFieldType: String {
    case username = "username"
    case password = "password"
}

class OPLoginViewController: UIViewController {
    
    @IBOutlet weak var backgroundImageView: UIImageView!
    @IBOutlet weak var loginContainerView: UIView!
    @IBOutlet weak var username: UIView!
    @IBOutlet weak var usernameTextField: OPTextField!
    @IBOutlet weak var password: UIView!
    @IBOutlet weak var passwordTextField: OPTextField!
    @IBOutlet weak var passwordUnderLine: UIView!
    @IBOutlet weak var usernameUnderLine: UIView!
    @IBOutlet weak var loginButton: UIButton!
    @IBOutlet weak var loginLoading: UIView!
    @IBOutlet weak var loadingImage: UIImageView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        backgroundImageView.image = UIImage.init(named: "login_background")
        backgroundImageView.contentMode = .scaleAspectFill
        loginContainerView.alpha = 0
        prepareUI()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        navigationController?.navigationBar.setBackgroundImage(UIImage(), for: UIBarMetrics.default)
        navigationController?.navigationBar.shadowImage = UIImage()
        navigationController?.navigationBar.isTranslucent = true
        
        guard let backImage = UIImage(named: "back_close") else { return }
        let leftArrowItem = UIBarButtonItem.createBarButtonItemWithImage(backImage, CGRect(x: 0, y: 0, width: 28, height: 30), self, #selector(dismissLoginView))
        navigationItem.leftBarButtonItem = leftArrowItem
        
        showLoginContainerAnimation()
    }
    
    func prepareUI() {
        //username
        usernameTextField.keyboardType = .asciiCapableNumberPad
        usernameTextField.borderStyle = .none
        usernameTextField.customType = OPTextFieldType.username.rawValue
        usernameTextField.delegate = self
        
        //password
        passwordTextField.borderStyle = .none
        passwordTextField.customType = OPTextFieldType.password.rawValue
        passwordTextField.delegate = self
        
        loginButton.layer.cornerRadius = 25
        loginButton.layer.masksToBounds = true
        loginLoading.isHidden = true
        loginLoading.layer.cornerRadius = loginLoading.bounds.height / 2
    }
    
    func closeKeyboard() {
        if usernameTextField.isFirstResponder {
            usernameTextField.resignFirstResponder()
        }
        
        if passwordTextField.isFirstResponder {
            passwordTextField.resignFirstResponder()
        }
    }
    
    func dismissLoginView() {
        let storyboard = UIStoryboard.init(name: "Main", bundle: nil)
        if let rootVC = storyboard.instantiateViewController(withIdentifier: "tabbarNav") as? UINavigationController {
            appDelegate.window?.rootViewController = rootVC
        }
        
        dismiss(animated: true, completion: nil)
    }
    
    @IBAction func doRegister(_ sender: UIButton) {
        let email = "alex_decimal@126.com"
        let username = "Alex_BlackMamba"
        let password = "passw0rd"
        
        OPDataService.sharedInstance.userRegistration(username, email: email, pwd: password) { (success, error) in
            if error != nil {
                
            } else {
                
            }
        }
    }
    
    @IBAction func doLogin(_ sender: UIButton) {
        loginButtonAnimation()
        let email = "alex_decimal@126.com"
        let username = "Alex_BlackMamba"
        let password = "passw00rd"
        
        OPDataService.sharedInstance.userLogin(username, email: email, pwd: password) { [weak self] (success, error) in
            if success {
                self?.loadingImage.alpha = 0.0
                UIView.animate(withDuration: 1.0, delay: 0, usingSpringWithDamping: 0.5, initialSpringVelocity: 0.5, options: .curveEaseInOut, animations: {
                    self?.loginLoading.transform = CGAffineTransform(scaleX: 50, y: 50)
                }, completion: { [weak self] (finished) in
                    self?.dismissLoginView()
                    self?.loginLoading.transform = CGAffineTransform(scaleX: 0.1, y: 0.1)
                })
            } else {
                self?.showLoginButton(true)
            }
        }
    }
    
    func startLoadingAnimation(_ animationView: UIView?, isShow: Bool ) {
        if isShow {
            let animationFull : CABasicAnimation = CABasicAnimation(keyPath: "transform.rotation.z")
            animationFull.fromValue     = 0
            animationFull.toValue       = 2*M_PI
            animationFull.duration      = 1
            animationFull.repeatCount   = Float.infinity
            animationView?.layer.add(animationFull, forKey: "rotation")
        } else {
            animationView?.layer.removeAllAnimations()
        }
    }
    
    func showLoginButton(_ isShow: Bool) {
        if !isShow {
            closeKeyboard()
            loginButton.transform = CGAffineTransform(scaleX: 1.0, y: 0.1)
            UIView.animate(withDuration: 0.15, animations: {
                [weak self] () -> Void in
                self?.loginButton.transform = CGAffineTransform(scaleX: 0.2, y: 0.1)
            }) { [weak self] (finished) in
                self?.loginButton.isHidden = true
                self?.loginLoading.isHidden = false
                self?.startLoadingAnimation(self?.loginLoading,isShow: true)
            }
        } else {
            loginButton.transform = CGAffineTransform(scaleX: 0.1, y: 0.1)
            startLoadingAnimation(loginLoading,isShow: false)
            loginLoading.isHidden = true
            UIView.animate(withDuration: 0.2, animations: {
                [weak self] () -> Void in
                self?.loginButton.isHidden = false
                self?.loginButton.transform = CGAffineTransform(scaleX: 1, y: 1)
            })
        }
    }
    
    func showLoginContainerAnimation() {
        loginContainerView.transform = CGAffineTransform(scaleX: 0.1, y: 0.1)
        UIView.animate(withDuration: 0.8, animations: { [weak self] in
            self?.loginContainerView.transform = CGAffineTransform(scaleX: 1.0, y: 1.0)
            self?.loginContainerView.alpha = 1.0
        }, completion: nil)
    }
    
    func loginButtonAnimation() {
        showLoginButton(false)
    }
    
    @IBAction func forgetPassword(_ sender: UIButton) {
        showLoginButton(true)
    }
}

//Mark: textfield related delegate func
extension OPLoginViewController: UITextFieldDelegate {
    func textFieldShouldBeginEditing(_ textField: UITextField) -> Bool {
        if let owntextfield  = textField as? OPTextField {
            if owntextfield.customType == OPTextFieldType.password.rawValue {
                textField.returnKeyType = .done
            }
        }
        return true
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        if let owntextfield  = textField as? OPTextField {
            if owntextfield.customType == OPTextFieldType.password.rawValue {
                showLoginButton(false)
            }
        }
        return true
    }
}



