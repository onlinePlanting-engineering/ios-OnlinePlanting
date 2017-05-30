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
        _ = syncWithAppServer(WebServiceAPIMapping.UserRegistraion.rawValue, httpMethod: .post, httpHeaders: initialHeaders(), params: ["username": username,"password": password], handler: handler)
    }
    
    func userLogin(_ username: String?, password: String?, handler:@escaping ((_ success:Bool, _ json:JSON?, _ error:NSError?)->())) {
        _ = syncWithAppServer(WebServiceAPIMapping.UserLogin.rawValue, httpMethod: .post, httpHeaders: initialHeaders(), params: ["username": username,"password": password],handler: handler)
    }
    
    func getUserProfile(handler:@escaping ((_ success:Bool, _ json:JSON?, _ error:NSError?)->())) {
        _ = syncWithAppServer(WebServiceAPIMapping.GetUserProfile.rawValue, httpMethod: .get, httpHeaders: getHeaders(), handler: handler)
    }
    
    func updateUserProfile(_ username: String?, nickname: String?, address: String?, gender: Int16?, image: UIImage?, handler:@escaping ((_ success:Bool, _ json:JSON?, _ error:NSError?)->())) {
        let paramersPost = ["username": username as Any, "profile": ["nickname":nickname as Any,"address":address as Any, "gender": gender as Any]] as [String : Any]
        _ = syncWithAppServer(WebServiceAPIMapping.GetUserProfile.rawValue, httpMethod: .put, httpHeaders: updatedHeaders(), params: paramersPost, handler: handler)
    }
    
    func getFarmList(handler:@escaping ((_ success:Bool, _ json:JSON?, _ error:NSError?)->())) {
        _ = syncWithAppServer(WebServiceAPIMapping.GetFarmList.rawValue, httpMethod: .get, httpHeaders: getFarmHeader(), params: nil, handler: handler)
    }
    
    func getImageByGroup(_ imageGroupId: Int64?, handler:@escaping ((_ success:Bool, _ json:JSON?, _ error:NSError?)->())) {
        guard let imageGroup = imageGroupId else {
            handler(false, nil, nil)
            return }
        let imageGroupUrl = "\(WebServiceAPIMapping.GetImageByGroup.rawValue)\(imageGroup)/"
        _ = syncWithAppServer(imageGroupUrl, httpMethod: .get, httpHeaders: getHeaders(), urlParams: nil, params: nil,handler: handler)
    }
    

    func getFarmComments(_ farmId: Int16?, handler:@escaping ((_ success:Bool, _ json:JSON?, _ error:NSError?)->())) {
        _ = syncWithAppServer(WebServiceAPIMapping.GetFarmComments.rawValue, httpMethod: .get, httpHeaders: getHeaders(), urlParams: ["type": "farm", "id": farmId], params: nil,handler: handler)
    }
    
    func getRepliedComments(_ parentId: Int64?, handler:@escaping ((_ success:Bool, _ json:JSON?, _ error:NSError?)->())) {
        guard let parent = parentId else {
            handler(false, nil, nil)
            return }
        let parentCommentUrl = "\(WebServiceAPIMapping.GetFarmComments.rawValue)\(parent)/"
        _ = syncWithAppServer(parentCommentUrl, httpMethod: .get, httpHeaders: getHeaders(), urlParams: nil, params: nil,handler: handler)
    }
    
    func createComment(_ type: String?, object_id: Int16?, parent_id: Int64? = nil, content: String?, grade: String?, handler:@escaping ((_ success:Bool, _ json:JSON?, _ error:NSError?)->())){
        let urlParameter = ["type": type as Any,"id": object_id as Any, "parent_id": parent_id as Any] as [String : Any]
        let dataParam = ["content": content, "grade": grade]
        _ = syncWithAppServer(WebServiceAPIMapping.CreateComment.rawValue, httpMethod: .post, httpHeaders: getHeaders(), urlParams: urlParameter, params: dataParam, handler: handler)
    }
    
    func deleteComment(_ commentId: Int64?, handler:@escaping ((_ success:Bool, _ json:JSON?, _ error:NSError?)->())){
        guard let deleteID = commentId else {
            handler(false, nil, nil)
            return }
        let deleteCommentUrl = "\(WebServiceAPIMapping.GetFarmComments.rawValue)\(deleteID)/"
        _ = syncWithAppServer(deleteCommentUrl, httpMethod: .delete, httpHeaders: getFarmHeader(), urlParams: nil,params: nil, handler: handler)
    }
    
    
    fileprivate func syncWithAppServer(_ apiMapping: String, httpMethod: HTTPMethod ,httpHeaders: HTTPHeaders? = nil, urlParams:[String: Any?]? = nil, params:[String: Any?]? = nil, handler: @escaping ((_ success:Bool, _ json:JSON?, _ error:NSError?)->())) -> DataRequest? {
        
        var url = baseURL! + apiMapping
        if let parameters = urlParams {
            var urlParam = "?"
            for (key, value) in parameters {
                if let parameterValue = value {
                    urlParam += "\(key)=\(parameterValue)&"
                }
            }
            let index = urlParam.index(urlParam.endIndex, offsetBy: -1)
            urlParam = urlParam.substring(to: index)
            url += urlParam
        }

        let request = Alamofire.request(url, method: httpMethod, parameters: params, encoding: JSONEncoding.default, headers: httpHeaders).responseJSON { (data) in
            //TODO: waiting for the status code
            let response = data.response
            
            if response?.statusCode == 200 || response?.statusCode == 201 || response?.statusCode == 204 {
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
