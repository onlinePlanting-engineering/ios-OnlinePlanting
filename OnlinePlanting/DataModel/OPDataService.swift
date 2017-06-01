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
            guard let data = json?["data"].arrayObject as? [[String : Any]] else {
                handler(false, error)
                return
            }
            Sync.changes(data, inEntityNamed: "Farm", dataStack: appDelegate.dataStack, completion: { (error) in
                if error != nil {
                    handler(false, error)
                } else {
                    handler(true, nil)
                }
            })
            
        }
    }
    
    func getImageGroup(_ group: Int64?, handler: @escaping ((_ success:Bool, _ error:NSError?)->())) {
        Networking.shareInstance.getImageByGroup(group) { (success, json, error) in
            guard let data = json?.dictionaryObject else {
                handler(false, error)
                return
            }
            Sync.changes([data], inEntityNamed: "ImageGroup", dataStack: appDelegate.dataStack, operations: [.Insert, .Update], completion: { (error) in
                if error != nil {
                    handler(false, error)
                } else {
                    handler(true, nil)
                }
            })
        }
    }
    
    func getLandById(_ landId: Int64?, handler: @escaping ((_ success:Bool, _ error:NSError?)->())) {
        Networking.shareInstance.getLandById(landId) { (success, json, error) in
            guard let data = json?["data"].dictionaryObject else {
                handler(false, error)
                return
            }
            Sync.changes([data], inEntityNamed: "Land", dataStack: appDelegate.dataStack, operations: [.Insert, .Update], completion: { (error) in
                if error != nil {
                    handler(false, error)
                } else {
                    handler(true, nil)
                }
            })
        }
    }
    
    func getLandByGroup(_ landIds: [Int64]?, handler: @escaping ((_ success:Bool, _ error:NSError?)->())) {
        guard let ids = landIds else {
            handler(false, nil)
            return
        }
        var successCount = 0
        var totalCount = 0
        for id in ids {
            OPDataService.sharedInstance.getLandById(id, handler: { (success, error) in
                if success {
                    successCount += 1
                    if successCount == ids.count {
                        handler(true, nil)
                        return
                    }
                    print("fetch lands data success: \(String(describing: id))")
                } else {
                    handler(false, error)
                    print("fetch lands data failed: \(String(describing: id))")
                    return
                }
                totalCount += 1
                if totalCount == ids.count {
                    handler(false, error)
                }
            })
        }

    }
    
    func getFarmComment(_ farmId: Int16?, handler: @escaping ((_ success:Bool, _ error:NSError?)->())) {
        
        Networking.shareInstance.getFarmComments(farmId) { (success, json, error) in
            guard let data = json?["data"].arrayObject as? [[String : Any]] else {
                handler(false, error)
                return
            }
            Sync.changes(data, inEntityNamed: "Comment", dataStack: appDelegate.dataStack, operations: [.Insert, .Update], completion: { (error) in
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
            guard let jsonData = json?["data"].dictionaryObject else {
                handler(false, error)
                return
            }
            
            Sync.changes([jsonData], inEntityNamed: "Comment", dataStack: appDelegate.dataStack, operations: [.Insert, .Update,], completion: { (error) in
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
    
    func deleteComment(_ commentId: Int64?, parentId: Int64?, handler: @escaping ((_ success:Bool, _ error:NSError?)->())) {
        Networking.shareInstance.deleteComment(commentId) { [weak self](success, json, error) in
            if success {
                do {
                    try Sync.delete(commentId as Any, inEntityNamed: "Comment", using: appDelegate.dataStack.mainContext)
                    if let parent = parentId {
                        self?.getRepliedComment(parent, handler: { (success, error) in
                            if success {
                                handler(true, nil)
                            } else {
                                handler(false, error)
                            }
                        })
                    } else {
                        handler(true,nil)
                    }
                    
                } catch{
                    handler(false, nil)
                    print("delete data error")
                }
            } else {
                handler(false, error)
            }
        }
    }
    
    func fetchCurrentFarmObjects() {
        let request = NSFetchRequest<NSFetchRequestResult>(entityName: "Comment")
        request.sortDescriptors = [NSSortDescriptor(key: "id", ascending: true)]
        _ = (try! appDelegate.dataStack.mainContext.fetch(request)) as! [Comment]
        //print("farm information is: \(farm[0].content)")
    }
    
    func fetchCurrentUserObjects(_ username: String?) -> User? {
        let request = NSFetchRequest<NSFetchRequestResult>(entityName: "User")
        request.sortDescriptors = [NSSortDescriptor(key: "id", ascending: true)]
        guard let user = username else { return nil }
        request.predicate = NSPredicate(format: "username = %@", user)
        let users = (try! appDelegate.dataStack.mainContext.fetch(request)) as! [User]
        if users.count > 0{
            return users[0]
        }
        return nil
    }
    
    func fetchImageGroupById(_ groupId: Int64?) -> [ImageGroup]? {
        let request = NSFetchRequest<NSFetchRequestResult>(entityName: "ImageGroup")
        request.sortDescriptors = [NSSortDescriptor(key: "id", ascending: true)]
        guard let id = groupId else { return nil }
        request.predicate = NSPredicate(format: "id == %lld", id)
        let imageGroup = ((try! appDelegate.dataStack.mainContext.fetch(request)) as? [ImageGroup])
        return imageGroup
    }
    
    func fetchLandByPredication(_ landGroup: [Int64]?) -> [Land]? {
        let request = NSFetchRequest<NSFetchRequestResult>(entityName: "Land")
        request.sortDescriptors = [NSSortDescriptor(key: "id", ascending: true)]
        guard let landgroup = landGroup else { return nil }
        request.predicate = NSPredicate(format: "id in %@",landgroup)
        let lands = ((try! appDelegate.dataStack.mainContext.fetch(request)) as? [Land])
        return lands
    }
    
}
