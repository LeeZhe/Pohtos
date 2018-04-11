//
//  NetworkTools.swift
//  AlamofireUse
//
//  Created by 古今 on 2016/11/25.
//  Copyright © 2016年 夜风易冷. All rights reserved.
//

import UIKit
import Alamofire

enum MethodType {
    case GET
    case POST
}

class NetworkTools {
    class func requestData(type: MethodType, URLString : String, parameters: [String : NSString]? = nil, finishedCallback: @escaping (_ result : AnyObject) -> ()) {
        
        //1.获取类型
        let method = type == .GET ? HTTPMethod.get : HTTPMethod.post
        
        //2.发送网络请求
        Alamofire.request(URLString, method: method, parameters: parameters).responseJSON { (responseString) in
            //3.获取结果
            guard let result = responseString.result.value else {
                print(responseString.result.error ?? <#default value#>)
                return
            }
            
            //4.将结果回调出去
            finishedCallback(result as AnyObject)
        }
    }
    
}
