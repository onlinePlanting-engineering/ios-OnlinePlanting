//
//  OPDataService.swift
//  OnlinePlanting
//
//  Created by Alex on 4/27/17.
//  Copyright © 2017 onlinePlanting. All rights reserved.
//

import Foundation

class OPDataService: NSObject {
    
    static var sharedInstance: OPDataService {
        
        struct Static {
            static let instance: OPDataService = OPDataService()
        }
        return Static.instance
    }
    
    
    func userRegistration(_ username: String, email:String, pwd: String, handler: @escaping ((_ success:Bool, _ error:NSError?)->())) {
        Networking.shareInstance.userRegister(username, emailaddress: email, password: pwd) { (success, json, error) in
            if success {
                print("json is: \(json)")
                handler(true, nil)
            } else {
                handler(false, error)
            }
        }
    }
    
    func userLogin(_ username: String, email:String, pwd: String, handler: @escaping ((_ success:Bool, _ error:NSError?)->())) {
        Networking.shareInstance.userLogin(username, emailaddress: email, password: pwd) { (success, json, error) in
            if success {
                handler(true, nil)
            } else {
                handler(false, error)
            }
        }
    }

}
