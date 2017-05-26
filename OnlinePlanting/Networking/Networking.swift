//
//  Networking.swift
//  OnlinePlanting
//
//  Created by Alex on 4/25/17.
//  Copyright © 2017 onlinePlanting. All rights reserved.
//

import UIKit
import Alamofire
import SwiftyJSON

let GlobaleUrl = ""

enum RequestType: Int {
    case requestTypeGet
    case requestTypePost
}

class Networking {
    
    static var shareInstance: Networking {
        struct Static {
            static let instance: Networking = Networking()
        }
        return Static.instance
    }
    
    var baseURL: String! {
        get {
            return "http://192.168.1.100:8000"
        }
    }
    
    lazy var token: String? = {
        let token = UserDefaults.standard.value(forKey: "token") as? String
        return token
    }()
}

extension Networking {
    
    func isLoginOrRegisterAPI(_ api: String) -> Bool {
        if api == WebServiceAPIMapping.UserLogin.rawValue || api == WebServiceAPIMapping.UserRegistraion.rawValue {
            return true
        } else {
            return false
        }
    }
    
    func initialHeaders() -> [String : String]? {
        let headers = [
            "Allow": "POST,OPTIONS",
            "Content-Type": "application/json"
        ]
        return headers
    }
    
    func getHeaders() -> [String : String]? {
        guard let unwrapToken = token else { return nil }
        let headers = [
        "Authorization": "Token \(unwrapToken)"
        ]
        return headers
    }
    
    func getFarmHeader() -> [String : String]? {
        guard let unwrapToken = token else { return nil }
        let headers = [
            "Allow": "GET,OPTIONS",
            "Content-Type": "application/json",
            "Authorization": "Token \(unwrapToken)"
        ]
        return headers
    }
    
    func updatedHeaders() -> [String : String]? {
        guard let unwrapToken = token else { return nil }
        let headers = [
            "Content-Type":"multipart/form-data",
            "Authorization": "Token \(unwrapToken)"
        ]
        return headers
    }
    
    //POST request
    func postRequest(urlString : String, params : [String : Any], success : @escaping (_ response : [String : Any])->(), failture : @escaping (_ error : Error)->()) {
        
        Alamofire.request(urlString, method: HTTPMethod.post, parameters: params).responseJSON { (response) in
            switch response.result{
            case .success:
                if let value = response.result.value as? [String: Any] {
                    success(value)
                    let json = JSON(value)
                    print(json)
                }
            case .failure(let error):
                failture(error)
            }
            
        }
    }
    
    //GET request
    func getRequest(urlString: String, params : [String : Any], success : @escaping (_ response : [String : AnyObject])->(), failture : @escaping (_ error : Error)->()) {
        
        Alamofire.request(urlString, method: .get, parameters: params)
            .responseJSON { (response) in
                switch response.result {
                case .success(let value):
                    success(value as! [String : AnyObject])
                    let json = JSON(value)
                    print(json)
                case .failure(let error):
                    failture(error)
                    print("error:\(error)")
                }
        }
    }
    
    func downloadFileRequest(_ fileURL:String, finalPath: URL?,
                      completeHandler:((_ localPath: URL?, _ error: NSError?)->())? = nil,
                      progressHandler:((_ bytesRead: Int64?, _ totalBytesRead: Int64?, _ totalBytesExpectedToRead: Int64?)->())? = nil)
    {
        
        var localPath: URL? = finalPath
        let url = GlobaleUrl + fileURL
        
        Alamofire.download(url, method: HTTPMethod.get) { (temporaryURL, response) -> (destinationURL: URL, options: DownloadRequest.DownloadOptions) in
            if let path = localPath {
                return (path, [.removePreviousFile, .createIntermediateDirectories])
            } else {
                let directoryURL = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)[0]
                let pathComponent = response.suggestedFilename
                localPath = directoryURL.appendingPathComponent(pathComponent!)
                return (localPath!, [.removePreviousFile, .createIntermediateDirectories])
            }
            }.responseData { (downloadResponse) in
                if let error = downloadResponse.error as NSError? {
                    completeHandler?(localPath, error)
                } else {
                    completeHandler?(localPath, nil)
                }
            }
    }
}
