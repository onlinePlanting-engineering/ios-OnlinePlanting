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
    
    func getFarmList(handler: @escaping ((_ success:Bool, _ error:NSError?)->())) {
        Networking.shareInstance.getFarmList() { (success, json, error) in
            guard let data = json?["data"].arrayObject as? [[String : Any]] else { return }
            Sync.changes(data, inEntityNamed: "Farm", dataStack: appDelegate.dataStack, completion: { (error) in
                if error != nil {
                    handler(false, error)
                } else {
                    //self.fetchCurrentUserObjects()
                    handler(true, nil)
                }
            })

        }
    }
    
    func getFarmComment(_ farmId: Int16?, handler: @escaping ((_ success:Bool, _ error:NSError?)->())) {
        
        Networking.shareInstance.getFarmComments(farmId) { (success, json, error) in
            
            guard let data = json?["data"].arrayObject as? [[String : Any]] else { return }
            Sync.changes(data, inEntityNamed: "FarmComment", dataStack: appDelegate.dataStack, operations: [.Insert, .Update], completion: { (error) in
                if error != nil {
                    handler(false, error)
                } else {
                    handler(true, nil)
                }
            })

        }
    }
    
    func getRepliedComment(_ parentId: Int64?, handler: @escaping ((_ success:Bool, _ error:NSError?)->())) {
        Networking.shareInstance.getRepliedComments(parentId, handler: {(success, json, error) in
            
            guard let jsonData = json?["data"]["replies"].arrayObject as? [[String : Any]] else { return }
            var tempdata = [[String : Any]]()
            for var data in jsonData{
                data.removeValue(forKey: "replies")
                guard let id = data["id"] else { return }
                data["url"] = "/api/comments/\(id)"
                tempdata.append(data)
            }
            
            Sync.changes(tempdata, inEntityNamed: "FarmComment", dataStack: appDelegate.dataStack, operations: [.Insert, .Update], completion: { (error) in
                if error != nil {
                    handler(false, error)
                } else {
                    //self.fetchCurrentUserObjects()
                    handler(true, nil)
                }
            })
        })
    }
    
    func createFarmComment(_ type: String?, object_id: Int16?, parent_id: Int64?, content: String?, grade: String?,handler: @escaping ((_ success:Bool, _ error:NSError?)->())) {
        Networking.shareInstance.createComment(type, object_id: object_id, parent_id: parent_id, content: content, grade: grade) { [weak self](success, json, error) in
            if success {
                if parent_id == nil {
                self?.getFarmComment(object_id, handler: { (success, error) in
                    if success {
                        handler(true, nil)
                    } else {
                        handler(true, nil)
                    }
                })
                } else {
                    self?.getRepliedComment(parent_id, handler: { (success, error) in
                        if success {
                            //after updating the child data, then update the parent data
                            self?.getFarmComment(object_id, handler: { (success, error) in
                                if success {
                                    handler(true, nil)
                                } else {
                                    handler(true, nil)
                                }
                            })
                        } else {
                            handler(true, nil)
                        }
                    })
                }
            } else {
                handler(false, error)
            }
        }
    }
    
    
    
    func fetchCurrentUserObjects() {
        let request = NSFetchRequest<NSFetchRequestResult>(entityName: "FarmComment")
        request.sortDescriptors = [NSSortDescriptor(key: "id", ascending: true)]
        let farm = (try! appDelegate.dataStack.mainContext.fetch(request)) as! [FarmComment]
        print("farm information is: \(farm[0].content)")
    }
}
