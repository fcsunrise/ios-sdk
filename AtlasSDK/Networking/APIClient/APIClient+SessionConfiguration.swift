//
//  APIClient+SessionConfiguration.swift
//  AtlasSDK
//
//  Created by Yelyzaveta Kartseva on 17.05.2021.
//

import Foundation
import Alamofire

extension APIClient {
    
    var sessionConfiguration: URLSessionConfiguration {
        let configuration = URLSessionConfiguration.default
        return configuration
    }
    
}
