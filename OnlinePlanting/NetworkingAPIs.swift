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
    
    func userRegister(_ username: String, emailaddress: String, password: String, handler:@escaping ((_ success:Bool, _ json:JSON?, _ error:NSError?)->())) {
        _ = syncWithAppServer(.UserRegistraion, params: ["username": username,"email":emailaddress, "email2": emailaddress, "password": password], handler: handler)
    }
    
    func userLogin(_ username: String, emailaddress: String, password: String, handler:@escaping ((_ success:Bool, _ json:JSON?, _ error:NSError?)->())) {
        _ = syncWithAppServer(.UserLogin, params: ["username": username,"email":emailaddress, "password": password], handler: handler)
    }
    
    fileprivate func syncWithAppServer(_ apiMapping: WebServiceAPIMapping, params:[String: String]? = nil,handler: @escaping ((_ success:Bool, _ json:JSON?, _ error:NSError?)->())) -> DataRequest? {
        
        let url = baseURL! + apiMapping.rawValue
        let request = Alamofire.request(url, method: HTTPMethod.post, parameters: params, encoding: JSONEncoding.default, headers: configHeaders()).responseJSON { (response) in
            //TODO: waiting for the status code
            if let value = response.result.value {
                let json = JSON(value)
                handler(true, json, nil)
            } else {
                handler(false, nil, response.result.error as NSError?)
            }
        }
        return request
    }
    
}
