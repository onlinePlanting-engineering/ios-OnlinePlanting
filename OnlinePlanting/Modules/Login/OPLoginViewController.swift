//
//  OPLoginViewController.swift
//  OnlinePlanting
//
//  Created by Alex on 4/27/17.
//  Copyright © 2017 onlinePlanting. All rights reserved.
//

import UIKit

class OPLoginViewController: UIViewController {

    @IBOutlet weak var backgroundImageView: UIImageView!
    @IBOutlet weak var loginContainerView: UIView!
    @IBOutlet weak var username: UIView!
    @IBOutlet weak var usernameTextField: OPTextField!
    @IBOutlet weak var password: UIView!
    @IBOutlet weak var passwordTextField: OPTextField!
    @IBOutlet weak var passwordUnderLine: UIView!
    @IBOutlet weak var usernameUnderLine: UIView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        backgroundImageView.image = UIImage.init(named: "login_background")
        backgroundImageView.contentMode = .scaleAspectFill
        
        
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
    }
    
    func prepareUI() {
        //username
        usernameTextField.keyboardType = .numberPad
        usernameTextField.borderStyle = .none
        
        //password
        passwordTextField.leftViewMode = UITextFieldViewMode.always
        passwordTextField.borderStyle = .none
    }
    
    func dismissLoginView() {
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
        
    }
    
}
