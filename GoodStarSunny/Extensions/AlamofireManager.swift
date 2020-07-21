//
//  AlamofireManager.swift
//  iCanCheckInApp
//
//  Created by HellöM on 2020/3/30.
//  Copyright © 2020 HellöM. All rights reserved.
//

import UIKit
import Alamofire

class AlamofireManager: NSObject {

    static let shared = AlamofireManager()
    
    func requestAPI(url: String, onSuccess: @escaping (Dictionary<String, Any>) -> (), onError: @escaping (String) -> ()) {
        
        AF.request(url).responseJSON { (response) in
            
            switch response.result {
                
            case .success(let json):
                
                let responseJson = json as! Dictionary<String, Any>
                
                onSuccess(responseJson)
                
            case .failure(let error):
                
                onError("errorerrorerror: \(error.localizedDescription)")
            }
        }
    }
}
