//
//  NetworkTools.swift
//  AlamofireUse
//

import UIKit
import Alamofire

enum MethodType {
    case GET
    case POST
}

class NetworkTools {
    class func requestData(type: MethodType, URLString : String, parameters: [String : Any]? = nil, finishedCallback: @escaping (_ result : AnyObject) -> ()) {
        

        let method = type == .GET ? HTTPMethod.get : HTTPMethod.post
        
        
        Alamofire.request(URLString, method: method, parameters: parameters).responseJSON { (responseString) in
            
            guard let result = responseString.result.value else {
                print(responseString.result.error)
                return
            }
            
            
            finishedCallback(result as AnyObject)
        }
    }
    
}
