//
//  NetworkingAPI.swift
//  OnlinePlanting
//
//  Created by Alex on 4/27/17.
//  Copyright © 2017 onlinePlanting. All rights reserved.
//

import Foundation
import SwiftyJSON
import Alamofire

extension Networking {
    
    func userRegister(_ username: String?,password: String?, handler:@escaping ((_ success:Bool, _ json:JSON?, _ error:NSError?)->())) {
        _ = syncWithAppServer(.UserRegistraion, httpMethod: .post, httpHeaders: initialHeaders(), params: ["username": username,"password": password], handler: handler)
    }
    
    func userLogin(_ username: String?, password: String?, handler:@escaping ((_ success:Bool, _ json:JSON?, _ error:NSError?)->())) {
        _ = syncWithAppServer(.UserLogin, httpMethod: .post, httpHeaders: initialHeaders(), params: ["username": username,"password": password],handler: handler)
    }
    
    func getUserProfile(handler:@escaping ((_ success:Bool, _ json:JSON?, _ error:NSError?)->())) {
        _ = syncWithAppServer(.GetUserProfile, httpMethod: .get, httpHeaders: getHeaders(), handler: handler)
    }
    
    func updateUserProfile(_ username: String?, nickname: String?, address: String?, gender: Int16?, image: UIImage?, handler:@escaping ((_ success:Bool, _ json:JSON?, _ error:NSError?)->())) {
        let paramersPost = ["username": username as Any, "profile": ["nickname":nickname as Any,"address":address as Any, "gender": gender as Any]] as [String : Any]
        _ = syncWithAppServer(.GetUserProfile, httpMethod: .put, httpHeaders: updatedHeaders(), params: paramersPost, handler: handler)
    }
    
    func getFarmList(handler:@escaping ((_ success:Bool, _ json:JSON?, _ error:NSError?)->())) {
        _ = syncWithAppServer(.GetFarmList, httpMethod: .get, httpHeaders: getFarmHeader(), params: nil, handler: handler)
    }
    
    func getComments(_ farmId: String?, handler:@escaping ((_ success:Bool, _ json:JSON?, _ error:NSError?)->())) {
        
    }
    
    func createComment(_ type: String?, object_id: String?, parent_id: String, handler:@escaping ((_ success:Bool, _ json:JSON?, _ error:NSError?)->())){
        _ = syncWithAppServer(.GetFarmList, httpMethod: .post, httpHeaders: getFarmHeader(), params: ["type": type,"object_id": object_id, "parent_id": parent_id], handler: handler)
    }
    
//    func deleteComment(_ commentId: String?, handler:@escaping ((_ success:Bool, _ json:JSON?, _ error:NSError?)->())){
//        _ = syncWithAppServer(.GetFarmList, httpMethod: .post, httpHeaders: getFarmHeader(), params: ["type": type,"object_id": object_id, "parent_id": parent_id], handler: handler)
//    }
//    
//    func deleteComment(_ commentId: String?, handler:@escaping ((_ success:Bool, _ json:JSON?, _ error:NSError?)->())){
//        
//    }
    
    
    fileprivate func syncWithAppServer(_ apiMapping: WebServiceAPIMapping, httpMethod: HTTPMethod ,httpHeaders: HTTPHeaders? = nil, params:[String: Any?]? = nil,handler: @escaping ((_ success:Bool, _ json:JSON?, _ error:NSError?)->())) -> DataRequest? {
        
        let url = baseURL! + apiMapping.rawValue
        
        let request = Alamofire.request(url, method: httpMethod, parameters: params, encoding: JSONEncoding.default, headers: httpHeaders).responseJSON { (data) in
            //TODO: waiting for the status code
            let response = data.response
            
            if response?.statusCode == 200 {
                if let value = data.result.value {
                    let json = JSON(value)
                    handler(true, json, nil)
                } else {
                    handler(false, nil, data.result.error as NSError?)
                }
            } else {
                handler(false, nil, data.result.error as NSError?)
            }
        }
        return request
    }
    
    //update profile
    func updateUserProfile(_ userId: Int64?, username: String?, gender: String?, address: String?, nickname: String?, portriate: UIImage?, handler: @escaping ((_ success:Bool, _ json:JSON?, _ error:NSError?)->())) {
        var url = ""
        var params: Parameters = [String: Any]()
        if let myId = userId, let myUsername = username, let myGender = gender, let myAddr = address, let myNickname = nickname {
            url = Networking.shareInstance.baseURL! + "/api/users/\(myId)/"
            
            params = [
                "username": "\(myUsername)",
                "profile.gender": "\(myGender)",
                "profile.addr":  "\(myAddr)",
                "profile.nickname" : "\(myNickname)"
            ]
        }

        Alamofire.upload(multipartFormData: { (multipartFormData) in
            if let userImage = portriate, let imageData = UIImageJPEGRepresentation(userImage,1){
                multipartFormData.append(imageData, withName: "profile.img_heading", fileName: "swift_file.jpeg", mimeType: "image/jpeg")
            }
            
            for (key, value) in params {
                //multipartFormData.append((value as! String).data(using: .utf8)!, withName: key)
                multipartFormData.append("\(value)".data(using: .utf8)!, withName: key)
            }
            
        }, usingThreshold: UInt64.init(), to: url, method: HTTPMethod.put, headers: updatedHeaders(), encodingCompletion: { encodingResult in
            switch encodingResult {
            case .success(let upload, _, _):
                upload.responseJSON { data in
                    let response = data.response
                    
                    if response?.statusCode == 200 {
                        if let value = data.result.value {
                            let json = JSON(value)
                            handler(true, json, nil)
                        } else {
                            handler(false, nil, data.result.error as NSError?)
                        }
                    } else {
                        handler(false, nil, data.result.error as NSError?)
                    }
                }
            case .failure(let encodingError):
                handler(false, nil, encodingError as NSError?)
            }
        })
    }
}
