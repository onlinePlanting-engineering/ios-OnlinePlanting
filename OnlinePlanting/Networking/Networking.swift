//
//  Networking.swift
//  OnlinePlanting
//
//  Created by IBM on 4/25/17.
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
            return "http://dry-shore-37942.herokuapp.com"
        }
    }
}

extension Networking {
    
    func configHeaders() -> [String : String]? {
        let headers = [
            "Allow": "POST,OPTIONS",
            "Content-Type": "application/json"
        ]
        return headers
    }
    
    //POST request
    func postRequest(urlString : String, params : [String : Any], success : @escaping (_ response : [String : AnyObject])->(), failture : @escaping (_ error : Error)->()) {
        
        Alamofire.request(urlString, method: HTTPMethod.post, parameters: params).responseJSON { (response) in
            switch response.result{
            case .success:
                if let value = response.result.value as? [String: AnyObject] {
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
    
    //update load
    func upLoadImageRequest(urlString : String, params:[String:String], data: [Data], name: [String],success : @escaping (_ response : [String : AnyObject])->(), failture : @escaping (_ error : Error)->()){
        
        let headers = ["content-type":"multipart/form-data"]
        
        Alamofire.upload(
            multipartFormData: { multipartFormData in
                let flag = params["flag"]
                let userId = params["userId"]
                
                multipartFormData.append((flag?.data(using: String.Encoding.utf8)!)!, withName: "flag")
                multipartFormData.append( (userId?.data(using: String.Encoding.utf8)!)!, withName: "userId")
                
                for i in 0..<data.count {
                    multipartFormData.append(data[i], withName: "appPhoto", fileName: name[i], mimeType: "image/png")
                }
        },
            to: urlString,
            headers: headers,
            encodingCompletion: { encodingResult in
                switch encodingResult {
                case .success(let upload, _, _):
                    upload.responseJSON { response in
                        if let value = response.result.value as? [String: AnyObject]{
                            success(value)
                            let json = JSON(value)
                            print(json)
                        }
                    }
                case .failure(let encodingError):
                    failture(encodingError)
                }
        })
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
                if let error = downloadResponse.error as? NSError {
                    completeHandler?(localPath, error)
                } else {
                    completeHandler?(localPath, nil)
                }
            }
    }
}
