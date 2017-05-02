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
    
    func updateUserProfile(_ nickname: String?, address: String?, gender: Int?, image: UIImage?, handler:@escaping ((_ success:Bool, _ json:JSON?, _ error:NSError?)->())) {
        _ = syncWithAppServer(.GetUserProfile, httpMethod: .put, httpHeaders: updatedHeaders(), params: ["nickname": nickname,"addr": address,"gender": gender, "img_heading": image], handler: handler)
    }
    
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
    
}
