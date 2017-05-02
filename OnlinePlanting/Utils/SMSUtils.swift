//
//  SMSUtils.swift
//  OnlinePlanting
//
//  Created by ___Alex___ on 5/1/17.
//  Copyright © 2017 onlinePlanting. All rights reserved.
//

import Foundation
import UIKit

class SMSUtils: NSObject {
    
    static var sharedInstance: SMSUtils {
        struct Static {
            static let instance: SMSUtils = SMSUtils()
        }
        return Static.instance
    }
    
    static func getVerificationCode(_ phoneNumber: String?, handler:@escaping (_ success: Bool)->()){
        SMSSDK.getVerificationCode(by: SMSGetCodeMethodSMS, phoneNumber: phoneNumber, zone: "86", customIdentifier: nil) { (error) in
            if (error == nil) {
                print("send Success,please waiting～")
                handler(true)
            } else {
                print("request failed")
                handler(false)
            }
        }
    }
    
    static func commitVerificationCode(_ securityCode: String?, phoneNumber: String?, handler:@escaping (_ success: Bool)->()) {
        SMSSDK.commitVerificationCode(securityCode, phoneNumber: phoneNumber, zone: "86") { (infor, error) in
            if (error == nil) {
                handler(true)
            }else{
                handler(false)
            }
            
        }
    }
}

class OPCountDown: NSObject {

    
    private var countdownTimer: Timer?
    var codeBtn: UIButton?
    var defaultColor: UIColor?
    var dynamicColor: UIColor?
    
    convenience init(button: UIButton, defaultCol: UIColor, dynamicCol: UIColor) {
        self.init()
        codeBtn = button
        defaultColor = defaultCol
        dynamicColor = dynamicCol
    }
    
    private var remainingSeconds: Int = 0 {
        willSet {
            codeBtn?.setTitle("Please wait \(newValue)", for: .normal)
            if newValue <= 0 {
                codeBtn?.setTitle("Get Code", for: .normal)
                isCounting = false
            }
        }
    }
    var isCounting = false {
        willSet {
            if newValue {
                countdownTimer = Timer.scheduledTimer(timeInterval: 1, target: self, selector: #selector(updateTime), userInfo: nil, repeats: true)
                remainingSeconds = 60
                codeBtn?.setTitleColor(dynamicColor, for: .normal)
            } else {
                countdownTimer?.invalidate()
                countdownTimer = nil
                codeBtn?.setTitleColor(defaultColor, for: .normal)
            }
            codeBtn?.isEnabled = !newValue
        }
    }
    
    @objc private func updateTime() {
        remainingSeconds -= 1
    }
}
