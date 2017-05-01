//
//  OPRegistrationViewController.swift
//  OnlinePlanting
//
//  Created by IBM on 4/29/17.
//  Copyright © 2017 onlinePlanting. All rights reserved.
//

enum PageStatusType: String {
    case signIn = "signIn"
    case signUp = "signUp"
}

enum OPTextFieldType: String {
    case username = "username"
    case emailaddress = "emailaddress"
    case securitycheck = "securitycheck"
    case password = "password"
}

import UIKit

class OPLoginMainViewController: UIViewController {
    
    
    //Register
    @IBOutlet weak var backGroundImage: UIImageView!
    @IBOutlet weak var usernameView: UIView!
    @IBOutlet weak var usernameTextField: OPTextField!
    @IBOutlet weak var mobilePhoneTextField: OPTextField!
    @IBOutlet weak var mobilePhoneView: UIView!
    @IBOutlet weak var passwordView: UIView!
    @IBOutlet weak var passwordTextField: OPTextField!
    @IBOutlet weak var saveButton: UIButton!
    @IBOutlet weak var registerContainerView: UIView!
    @IBOutlet weak var loginContainerView: UIView!
    @IBOutlet weak var loginButton: UIButton!
    @IBOutlet weak var loadingContainer: UIView!
    fileprivate var pageStatus: PageStatusType = .signUp
    fileprivate var hitMessage = ""
    fileprivate var isMobilePhone = false
    fileprivate let SHA256Interation = 360000
    
    //Login
    @IBOutlet weak var loginUsername: OPTextField!
    @IBOutlet weak var loginPassword: OPTextField!
    
    @IBOutlet weak var securityCodeTextField: OPTextField!
    @IBOutlet weak var securityPhoneView: UIView!
    
    @IBOutlet weak var password2Security: NSLayoutConstraint!
    
    
    @IBAction func getMSMSecurityCode(_ sender: UIButton) {
        
        SMSSDK.getVerificationCode(by: SMSGetCodeMethodSMS, phoneNumber: mobilePhoneTextField.text, zone: "86", customIdentifier: nil) { (error) in
            if (error == nil) {
                print("send Success,please waiting～")
            } else {
                print("request failed")
            }
        }
    }
    
    @IBAction func doRegistration(_ sender: UIButton) {
        let email = "alex_decimal@126.com"
        let username = "Alex_BlackMamba"
        let password = "passw0rd"
        
        SMSSDK.commitVerificationCode(securityCodeTextField.text, phoneNumber: mobilePhoneTextField.text, zone: "86") { (infor, error) in
            if (error == nil) {
                print("success")
                OPDataService.sharedInstance.userRegistration(username, email: email, pwd: password) { [weak self](success, error) in
                    if error != nil {
                        self?.showSaveRegistrationButton(true)
                    } else {
                        if success {
                            
                        } else {
                            self?.showSaveRegistrationButton(true)
                        }
                    }
                }
                
            }else{
                print("failed")
            }
            
        }
        showSaveRegistrationButton(false)
    }
    
    
    @IBAction func doLogin(_ sender: UIButton) {
        if checkUsernamePassword() {
            guard let username = loginUsername.text, let password = loginPassword.text else { return }
            let salt = Data(bytes: [0x73, 0x61, 0x6c, 0x74, 0x44, 0x61, 0x74, 0x61])
            let _ = password.pbkdf2SHA256(password: password, salt: salt, keyByteCount: 16, rounds: SHA256Interation)
            showLoginButton(false)
            OPDataService.sharedInstance.userLogin("", email: username, pwd: password) { [weak self](success, error) in
                if error != nil {
                    self?.showLoginButton(true)
                } else {
                    if success {
                        
                    } else {
                        self?.showLoginButton(true)
                        let image = UIImage.init(named: "toast_password")
                        OPToastWindow.show(image, title: "请检查您的用户名或者密码", content: "Server error or network error")
                    }
                }
            }
            
        } else {
            let image = UIImage.init(named: "toast_password")
            OPToastWindow.show(image, title: "请检查您的用户名或者密码", content: hitMessage)
        }
    }
    
    
    func checkUsernamePassword() -> Bool {
        var errorCount = 0
        closeKeyboard()
        if pageStatus == .signIn {
            if loginUsername.text == "" || loginUsername.text == nil {
                hitMessage = "Please input your email address or phone number"
                errorCount += 1
            }
            if loginPassword.text == "" || loginPassword.text == nil {
                hitMessage = "Please input your password"
                errorCount += 1
            }
            if errorCount == 2 {
                hitMessage = "Please input your email address and password"
                return false
            }
            
            guard let username = loginUsername.text else { return false }
            if (username.EmailIsValidated() || username.PhoneNumberIsValidated()) && errorCount == 0 {
                return true
            } else {
                hitMessage = "Please input valid phone number or password"
                return false
            }
        } else {
            if pageStatus == .signIn {
                if usernameTextField.text == "" || usernameTextField.text == nil {
                    hitMessage = "Please input your user name"
                    errorCount += 1
                }
                if mobilePhoneTextField.text == "" || mobilePhoneTextField.text == nil {
                    hitMessage = "Please input your email address or phone number"
                    errorCount += 1
                }
                if passwordTextField.text == "" || passwordTextField.text == nil {
                    hitMessage = "Please input your password"
                    errorCount += 1
                }
                if errorCount == 3 {
                    hitMessage = "Please input your user name, email address and password"
                    return false
                }
                guard let username = mobilePhoneTextField.text else { return false }
                if (username.EmailIsValidated() || username.PhoneNumberIsValidated()) && errorCount == 0 {
                    return true
                } else {
                    hitMessage = "Please input valid phone number or password"
                    return false
                }
            }
        }
        return false
    }
    
    @IBAction func tapCloseKeyBoard(_ sender: UITapGestureRecognizer) {
        closeKeyboard()
    }
    
    
    @IBAction func forgetPassword(_ sender: UIButton) {
        //showLoginButton(true)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        navigationController?.navigationBar.setBackgroundImage(UIImage(), for: UIBarMetrics.default)
        navigationController?.navigationBar.shadowImage = UIImage()
        navigationController?.navigationBar.isTranslucent = true
        
        guard let backImage = UIImage(named: "back_close") else { return }
        let leftArrowItem = UIBarButtonItem.createBarButtonItemWithImage(backImage, CGRect(x: 0, y: 0, width: 28, height: 30), self, #selector(dismissLoginView))
        navigationItem.leftBarButtonItem = leftArrowItem
        navigationController?.navigationBar.titleTextAttributes = [NSForegroundColorAttributeName: UIColor.white]
        
        prepareUI()
        // Do any additional setup after loading the view.
    }
    
    func dismissLoginView() {
        let _ = navigationController?.popViewController(animated: true)
    }
    
    func prepareUI() {
        loginContainerView.alpha = 0
        
        loadingContainer.isHidden = true
        loadingContainer.layer.cornerRadius = loadingContainer.bounds.height / 2
        loadingContainer.layer.masksToBounds = true
        
        navigationItem.title = "Sign Up"
        
        usernameTextField.customType = OPTextFieldType.username.rawValue
        mobilePhoneTextField.customType = OPTextFieldType.emailaddress.rawValue
        mobilePhoneTextField.customType = OPTextFieldType.password.rawValue
        mobilePhoneTextField.addTarget(self, action: #selector(mobilePhonetextFieldDidChange), for: .editingChanged)
        mobilePhoneTextField.delegate = self
    }
    
    func mobilePhonetextFieldDidChange() {
        guard let content = mobilePhoneTextField.text else { return }
        if content.PhoneNumberIsValidated() {
            isMobilePhone = true
            UIView.animate(withDuration: 0.45, animations: { [weak self] in
                self?.password2Security.constant = 60
                self?.loadingContainer.transform = CGAffineTransform.init(translationX: 0, y: 60)
                self?.view.layoutIfNeeded()
                }, completion: nil)
        } else {
            if isMobilePhone {
                isMobilePhone = false
                UIView.animate(withDuration: 0.45, animations: { [weak self] in
                    self?.password2Security.constant = 0
                    self?.loadingContainer.transform = .identity
                    self?.view.layoutIfNeeded()
                    }, completion: nil)
            }
        }
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
    }
    
    @IBAction func loginInRegistration(_ sender: UIButton) {
        closeKeyboard()
        pageStatus = .signIn
        navigationItem.title = "Sign In"
        registerContainerView.alpha = 0.0
        loginContainerView.alpha = 1.0
        UIView.animate(withDuration: 0.65, animations: {[weak self] in
            self?.loginContainerView.transform = CGAffineTransform.init(translationX: 0, y: -53)
            self?.loadingContainer.transform = CGAffineTransform.init(translationX: 0, y: -53)
            }, completion: nil)
    }
    
    @IBAction func backToRegister(_ sender: UIButton) {
        closeKeyboard()
        pageStatus = .signUp
        navigationItem.title = "Sign Up"
        loginContainerView.transform = .identity
        loginContainerView.alpha = 0.0
        loadingContainer.transform = .identity
        registerContainerView.transform = CGAffineTransform(scaleX: 0.1, y: 0.1)
        UIView.animate(withDuration: 0.65, animations: {[weak self] in
            self?.registerContainerView.alpha = 1.0
            UIView.animate(withDuration: 0.8, animations: { [weak self] in
                self?.registerContainerView.transform = CGAffineTransform(scaleX: 1.0, y: 1.0)
                self?.registerContainerView.alpha = 1.0
                }, completion: nil)
            }, completion: nil)
    }
    
    func closeKeyboard() {
        if usernameTextField.isFirstResponder {
            usernameTextField.resignFirstResponder()
        }
        
        if passwordTextField.isFirstResponder {
            passwordTextField.resignFirstResponder()
        }
        
        if mobilePhoneTextField.isFirstResponder {
            mobilePhoneTextField.resignFirstResponder()
        }
        
        if loginUsername.isFirstResponder {
            loginUsername.resignFirstResponder()
        }
        
        if loginPassword.isFirstResponder {
            loginPassword.resignFirstResponder()
        }
        
        if securityCodeTextField.isFirstResponder {
            securityCodeTextField.resignFirstResponder()
        }
    }
    
    
    func showSaveRegistrationButton(_ isShow: Bool) {
        if !isShow {
            closeKeyboard()
            saveButton.transform = CGAffineTransform(scaleX: 1.0, y: 0.1)
            UIView.animate(withDuration: 0.15, animations: {
                [weak self] () -> Void in
                self?.saveButton.transform = CGAffineTransform(scaleX: 0.2, y: 0.1)
            }) { [weak self] (finished) in
                self?.saveButton.isHidden = true
                self?.loadingContainer.isHidden = false
                self?.loadingContainer.startLoadingAnimation(true)
            }
        } else {
            saveButton.transform = CGAffineTransform(scaleX: 0.1, y: 0.1)
            loadingContainer.startLoadingAnimation(false)
            loadingContainer.isHidden = true
            UIView.animate(withDuration: 0.2, animations: {
                [weak self] () -> Void in
                self?.saveButton.isHidden = false
                self?.saveButton.transform = CGAffineTransform(scaleX: 1, y: 1)
            })
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
                self?.loadingContainer.isHidden = false
                self?.loadingContainer.startLoadingAnimation(true)
            }
        } else {
            loginButton.transform = CGAffineTransform(scaleX: 0.1, y: 0.1)
            loadingContainer.startLoadingAnimation(false)
            loadingContainer.isHidden = true
            UIView.animate(withDuration: 0.2, animations: {
                [weak self] () -> Void in
                self?.loginButton.isHidden = false
                self?.loginButton.transform = CGAffineTransform(scaleX: 1, y: 1)
            })
        }
    }
    
}

//Mark: textfield related delegate func
extension OPLoginMainViewController: UITextFieldDelegate {
    func textFieldShouldBeginEditing(_ textField: UITextField) -> Bool {
        return true
    }
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        guard let textContent = textField as? OPTextField , let content = textField.text else { return false }
        print("content is:\(content)")
        if textContent.customType == OPTextFieldType.emailaddress.rawValue && content.PhoneNumberIsValidated() {
            UIView.animate(withDuration: 0.45, animations: { [weak self] in
                self?.password2Security.constant = 50
                self?.view.layoutIfNeeded()
                
                }, completion: nil)
            return true
        }
        return true
    }
}

