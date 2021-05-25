//
//  APIEndpoint.swift
//  AtlasSDK
//
//  Created by Yelyzaveta Kartseva on 17.05.2021.
//

import Alamofire
import Marshal

protocol APIEndpoint {
    associatedtype ResponseType
    
    var path: String { get }
    var method: HTTPMethod { get }
    var encoding: ParameterEncoding { get }
    var parameters: JSONObject? { get}
    var headers: HTTPHeaders { get }
}
