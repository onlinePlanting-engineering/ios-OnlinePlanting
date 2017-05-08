//
//  OPDataService.swift
//  OnlinePlanting
//
//  Created by Alex on 4/27/17.
//  Copyright © 2017 onlinePlanting. All rights reserved.
//

import Foundation
import CoreData
import Sync

class OPDataService: NSObject {
    
    static var sharedInstance: OPDataService {
        
        struct Static {
            static let instance: OPDataService = OPDataService()
        }
        return Static.instance
    }
    
    func userRegistration(_ username: String?, pwd: String?, handler: @escaping ((_ success:Bool, _ error:NSError?)->())) {
        Networking.shareInstance.userRegister(username, password: pwd) { (success, json, error) in
            if success {
                print("json is: \(json)")
                handler(true, nil)
            } else {
                handler(false, error)
            }
        }
    }
    
    func userLogin(_ username: String?, pwd: String?, handler: @escaping ((_ success:Bool, _ error:NSError?)->())) {
        Networking.shareInstance.userLogin(username, password: pwd) { (success, json, error) in
            if success {
                guard let token = json?["token"].string else { handler(false, nil)
                    return }
                if token != "" {
                    UserDefaults.standard.set(token, forKey: "token")
                    UserDefaults.standard.synchronize()
                    handler(true, nil)
                } else {
                    handler(false, nil)
                }
            } else {
                handler(false, error)
            }
        }
    }
    
    func getUserProfile(handler: @escaping ((_ success:Bool, _ error:NSError?)->())) {
        Networking.shareInstance.getUserProfile() { (success, json, error) in
            if success {
                guard let data = json?.dictionaryObject?["data"] as? [String: Any] else { return }
                Sync.changes([data], inEntityNamed: "User", dataStack: appDelegate.dataStack) { error in
                    handler(true, nil)
                }
            } else {
                handler(false, error)
            }
        }
    }
    
    func updateUserProfile(_ userId: Int64?, username: String?, gender: String?, address: String?, nickname: String?, portriate: UIImage?, handler: @escaping ((_ success:Bool, _ error:NSError?)->())) {
        Networking.shareInstance.updateUserProfile(userId, username: username, gender: gender, address: address, nickname: nickname, portriate: portriate) { (success, json, error) in
            if success {
                guard let data = json?.dictionaryObject?["data"] as? [String: Any] else { return }
                Sync.changes([data], inEntityNamed: "User", dataStack: appDelegate.dataStack) { error in
                    handler(true, nil)
//                    let user = (try! Sync.fetch(appDelegate.currentUser?.id, inEntityNamed: "User", using: appDelegate.dataStack.mainContext)) as! User
//                    appDelegate.currentUser = user
                }
            } else {
                handler(false, error)
            }
        }
    }
    
    func saveUserLocationData(_ parameters: [String: String]?,handler: @escaping ((_ success:Bool, _ error:NSError?)->())) {
        guard let parameter = parameters else { return }
        Sync.changes([parameter], inEntityNamed: "Location", dataStack: appDelegate.dataStack, completion: { (error) in
            if error != nil {
                handler(false, error)
            } else {
                handler(true, nil)
            }
        })
    }
}
