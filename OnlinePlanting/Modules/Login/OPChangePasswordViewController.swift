//
//  OPChangePasswordViewController.swift
//  OnlinePlanting
//
//  Created by IBM on 4/30/17.
//  Copyright © 2017 onlinePlanting. All rights reserved.
//

import UIKit

class OPChangePasswordViewController: UIViewController {
    
    @IBOutlet weak var emailContainerView: UIView!
    @IBOutlet weak var phoneContainerView: UIView!
    @IBOutlet weak var phoneNumber: UIView!
    @IBOutlet weak var securityCode: UIView!
    @IBOutlet weak var newPassword: UIView!
    @IBOutlet weak var passwordToSecurity: NSLayoutConstraint!
    @IBOutlet weak var phoneTextfield: OPTextField!
    fileprivate var isMobilePhone = false
    @IBOutlet weak var sendButton: UIButton!
    @IBOutlet weak var loadingContainer: UIView!
    
    
    @IBAction func sendNewPassword(_ sender: UIButton) {
        showSendButton(false)
    }
    
    
    @IBAction func emailChange(_ sender: UIButton) {
        emailContainerView.alpha = 0.0
        UIView.animate(withDuration: 0.75, animations: { [weak self] in
            self?.phoneContainerView.alpha = 1.0
        }, completion: nil)
    }
    
    
    @IBAction func closeKeboard(_ sender: UITapGestureRecognizer) {

    }
    
    @IBAction func closeChangePasswordVc(_ sender: UITapGestureRecognizer) {
        dismiss(animated: true, completion: nil)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        prepareUI()
        // Do any additional setup after loading the view.
    }
    
    func prepareUI() {
        loadingContainer.layer.cornerRadius = loadingContainer.bounds.height / 2
        loadingContainer.layer.masksToBounds = true
        loadingContainer.isHidden = true
        phoneTextfield.addTarget(self, action: #selector(mobilePhonetextFieldDidChange), for: .editingChanged)
    }
    
    func mobilePhonetextFieldDidChange() {
        guard let content = phoneTextfield.text else { return }
        if content.PhoneNumberIsValidated() {
            isMobilePhone = true
            UIView.animate(withDuration: 0.45, animations: { [weak self] in
                self?.passwordToSecurity.constant = 60
                self?.view.layoutIfNeeded()
                }, completion: nil)
        } else {
            if isMobilePhone {
                isMobilePhone = false
                UIView.animate(withDuration: 0.45, animations: { [weak self] in
                    self?.passwordToSecurity.constant = 0
                    self?.view.layoutIfNeeded()
                    }, completion: nil)
            }
        }
    }
    
    func showSendButton(_ isShow: Bool) {
        if !isShow {
            sendButton.transform = CGAffineTransform(scaleX: 1.0, y: 0.1)
            UIView.animate(withDuration: 0.15, animations: {
                [weak self] () -> Void in
                self?.sendButton.transform = CGAffineTransform(scaleX: 0.2, y: 0.1)
            }) { [weak self] (finished) in
                self?.sendButton.isHidden = true
                self?.loadingContainer.isHidden = false
                self?.loadingContainer.startLoadingAnimation(true)
            }
        } else {
            sendButton.transform = CGAffineTransform(scaleX: 0.1, y: 0.1)
            loadingContainer.startLoadingAnimation(false)
            loadingContainer.isHidden = true
            UIView.animate(withDuration: 0.2, animations: {
                [weak self] () -> Void in
                self?.sendButton.isHidden = false
                self?.sendButton.transform = CGAffineTransform(scaleX: 1, y: 1)
            })
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
}
