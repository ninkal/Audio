//
//  ServerClass.swift
//  Amistos
//
//  Created by chawtech solutions on 3/26/18.
//  Copyright © 2018 chawtech solutions. All rights reserved.
//


import UIKit
import Alamofire
import SwiftyJSON

public struct ERNetworkManagerResponse {    /// The server's response to the URL request
    public let responseDict: NSDictionary?
    /// The error encountered while executing or validating the request.
    public let message: String?
    
    /// Status of the request.
    public let success: Bool?
    var _metrics: AnyObject?
    init(response: NSDictionary?, status: Bool?,error: String?) {
        
        self.message = error
        self.responseDict = response
        self.success = status
    }
}

class ServerClass: NSObject {
    var arrRes = [[String:AnyObject]]()
    class var sharedInstance:ServerClass {
        struct Singleton {
            static let instance = ServerClass()
        }
        return Singleton.instance
    }
    
    private static var Manager: Alamofire.SessionManager = {
        // Create the server trust policies
        let serverTrustPolicies: [String: ServerTrustPolicy] = [
            TRUST_BASE_URL: .disableEvaluation  
        ]
        // Create custom manager
        let configuration = URLSessionConfiguration.default
        configuration.httpAdditionalHeaders = Alamofire.SessionManager.defaultHTTPHeaders
        let manager = Alamofire.SessionManager(
            configuration: URLSessionConfiguration.default,
            serverTrustPolicyManager: ServerTrustPolicyManager(policies: serverTrustPolicies)
        )
        return manager
    }()
    
    func getRequestWithUrlParameters(_ sendJson:[String:Any], path:String, successBlock:@escaping (_ response: JSON )->Void , errorBlock: @escaping (_ error: NSError) -> Void ){
        var headerField : [String : String] = [:]
        if UserDefaults.standard.object(forKey: USER_DEFAULTS_KEYS.LOGIN_TOKEN) != nil  {
            headerField = ["Content-Type":"application/json", "XAPIKEY":X_API_KEY, "APPTOKEN":UserDefaults.standard.value(forKey: USER_DEFAULTS_KEYS.LOGIN_TOKEN) as! String]
        }
        else {
            headerField = ["Content-Type":"application/json","XAPIKEY":X_API_KEY]
        }
        ServerClass.Manager.request(path, method: .get, encoding: JSONEncoding.default, headers: headerField).responseJSON { (response) in
            switch response.result {
            case .success:
                if let value = response.result.value {
                    successBlock(JSON(value ))
                }
            case .failure(let error):
                errorBlock(error as NSError)
            }
        }
    } 
    
    func postRequestWithUrlParameters(_ sendJson:[String:Any], path:String, successBlock:@escaping (_ response: JSON )->Void , errorBlock: @escaping (_ error: NSError) -> Void ){
        var headerField : [String : String] = [:]
        if UserDefaults.standard.object(forKey: USER_DEFAULTS_KEYS.LOGIN_TOKEN) != nil  {
            headerField = ["Content-Type":"application/json", "XAPIKEY":X_API_KEY, "APPTOKEN":UserDefaults.standard.value(forKey: USER_DEFAULTS_KEYS.LOGIN_TOKEN) as! String]
        }
        else {
            headerField = ["Content-Type":"application/json","XAPIKEY":X_API_KEY]
        }
        ServerClass.Manager.request(path, method: .post, parameters: sendJson, encoding: JSONEncoding.default, headers: headerField).responseJSON { (response) in
            switch response.result {
            case .success:
                if let value = response.result.value {
                    successBlock(JSON(value ))
                }
            case .failure(let error):
                errorBlock(error as NSError)
            }
        }
    }
    
    func putRequestWithUrlParameters(_ sendJson:[String:Any], path:String, successBlock:@escaping (_ response: JSON )->Void , errorBlock: @escaping (_ error: NSError) -> Void ){
        var headerField : [String : String] = [:]
        if UserDefaults.standard.object(forKey: USER_DEFAULTS_KEYS.LOGIN_TOKEN) != nil  {
            headerField = ["Content-Type":"application/json", "XAPIKEY":X_API_KEY, "APPTOKEN":UserDefaults.standard.value(forKey: USER_DEFAULTS_KEYS.LOGIN_TOKEN) as! String]
        }
        else {
            headerField = ["Content-Type":"application/json","XAPIKEY":X_API_KEY]
        }
        ServerClass.Manager.request(path, method: .put, parameters: sendJson, encoding: JSONEncoding.default, headers: headerField).responseJSON
            { (response) in
                switch response.result {
                case .success:
                    if let value = response.result.value {
                        successBlock(JSON(value ))
                    }
                case .failure(let error):
                    errorBlock(error as NSError)
                }
        }
    }
    
    func deleteRequestWithUrlParameters(_ sendJson:[String:Any], path:String, successBlock:@escaping (_ response: JSON )->Void , errorBlock: @escaping (_ error: NSError) -> Void ){
        var headerField : [String : String] = [:]
        if UserDefaults.standard.object(forKey: USER_DEFAULTS_KEYS.LOGIN_TOKEN) != nil  {
            headerField = ["Content-Type":"application/json", "XAPIKEY":X_API_KEY, "APPTOKEN":UserDefaults.standard.value(forKey: USER_DEFAULTS_KEYS.LOGIN_TOKEN) as! String]
        }
        else {
            headerField = ["Content-Type":"application/json","XAPIKEY":X_API_KEY]
        }
        ServerClass.Manager.request(path, method: .delete, parameters: sendJson, encoding: JSONEncoding.default, headers: headerField).responseJSON { (response) in
            switch response.result {
            case .success:
                if let value = response.result.value {
                    successBlock(JSON(value ))
                }
            case .failure(let error):
                errorBlock(error as NSError)
            }
        }
    }
    
    func sendMultipartRequestToServer(apiUrlStr:String, imageKeyName:String, imageUrl:URL?, successBlock:@escaping (_ response: JSON)->Void , errorBlock: @escaping (_ error: NSError) -> Void ){
        let headerField = ["XAPIKEY":X_API_KEY]
        Alamofire.upload(multipartFormData: { multipartFormData in
            multipartFormData.append(imageUrl! , withName: imageKeyName)
        },to:apiUrlStr, method: .post, headers : headerField,
          encodingCompletion: { encodingResult in
            switch encodingResult {
            case .success(let upload, _, _):
                upload.responseJSON { response in
                    if let value = response.result.value {
                        successBlock(JSON(value ))
                    }
                }
            case .failure(let error):
                errorBlock(error as NSError)
            }
        })
    }
    
    func sendImageMultipartRequestToServerWithToken(apiUrlStr:String, imageKeyName:String, imageUrl:URL?, successBlock:@escaping (_ response: JSON)->Void , errorBlock: @escaping (_ error: NSError) -> Void ){
        let headerField = ["XAPIKEY":X_API_KEY,"APPTOKEN":UserDefaults.standard.value(forKey: USER_DEFAULTS_KEYS.LOGIN_TOKEN) as! String]
        Alamofire.upload(multipartFormData: { multipartFormData in
            multipartFormData.append(imageUrl! , withName: imageKeyName)
        },to:apiUrlStr, method: .post, headers : headerField,
          encodingCompletion: { encodingResult in
            switch encodingResult {
            case .success(let upload, _, _):
                upload.responseJSON { response in
                    if let value = response.result.value {
                        successBlock(JSON(value ))
                    }
                }
            case .failure(let error):
                errorBlock(error as NSError)
            }
        })
    }
    
    func getTimeZoneGoogleApi(path:String, successBlock:@escaping (_ response: JSON )->Void , errorBlock: @escaping (_ error: NSError) -> Void ){
        ServerClass.Manager.request(path, method: .get, encoding: JSONEncoding.default, headers: [:]).responseJSON { (response) in
            switch response.result {
            case .success:
                if let value = response.result.value {
                    successBlock(JSON(value ))
                }
            case .failure(let error):
                errorBlock(error as NSError)
            }
        }
    }
}
