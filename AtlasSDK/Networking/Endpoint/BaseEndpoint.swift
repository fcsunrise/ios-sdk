//
//  BaseEndpoint.swift
//  AtlasSDK
//
//  Created by Yelyzaveta Kartseva on 17.05.2021.
//

import Foundation
import Alamofire
import Marshal

class BaseEndpoint {
    
    var method: HTTPMethod {
        return .post
    }
    
    init(attributes: Parameters?) {
        self.parameters = attributes
    }
    
    var encoding: ParameterEncoding {
        return JSONEncoding.default
    }
    
    var parameters: JSONObject?
    
    var headers: HTTPHeaders {
        return [
            APIHeaders.contentType.rawValue: APIContentType.applicationJSON.rawValue
        ]
    }
}

struct BaseResponse {
    let success: Bool
}

extension BaseResponse: Unmarshaling {
    init(object: MarshaledObject) throws {
        self.success = object.optionalAny(for: APIParameterName.success.rawValue) as? Bool ?? true
    }
}
