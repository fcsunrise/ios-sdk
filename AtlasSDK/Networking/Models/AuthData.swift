//
//  AuthData.swift
//  AtlasSDK
//
//  Created by Yelyzaveta Kartseva on 17.05.2021.
//

import Foundation
import Marshal

struct AuthData {
    
    var hash: String = ""
    var point: String
    
}

//MARK: - Unmarshaling
extension AuthData: Unmarshaling {
    
    init(object: MarshaledObject) throws {
        self.hash = object.optionalAny(for: APIParameterName.hash.rawValue) as? String ?? ""
        self.point = object.optionalAny(for: APIParameterName.point.rawValue) as! String
    }
    
}

//MARK: - JSONMarshaling
extension AuthData: JSONMarshaling {
    
    func jsonObject() -> JSONObject {
        return [
            APIParameterName.hash.rawValue  : self.hash,
            APIParameterName.point.rawValue : self.point
        ]
    }
    
}
