//
//  APIClient+ServerTrust.swift
//  AtlasSDK
//
//  Created by Yelyzaveta Kartseva on 17.05.2021.
//

import Alamofire
import Foundation

extension APIClient {
    
    var serverTrustPolicies: [String : ServerTrustEvaluating] {
        return [
            "json-m.fcsunrise.com" : DisabledTrustEvaluator(),
        ]
    }
    
}
