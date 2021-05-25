//
//  APIErrorDescription.swift
//  AtlasSDK
//
//  Created by Yelyzaveta Kartseva on 17.05.2021.
//

import Marshal

public struct APIErrorDescription {
    
    public let code: Int
    public let title: String?
    public let text: String?
    
}

//MARK: - Unmarshaling
extension APIErrorDescription: Unmarshaling {
    
    public init(object: MarshaledObject) throws {
        code = try object.any(for: APIParameterName.code.rawValue) as! Int
        title = object.optionalAny(for: APIParameterName.error.rawValue) as? String
        text = object.optionalAny(for: APIParameterName.message.rawValue) as? String
    }
    
}

extension APIErrorDescription {
    
    var isSuccessCode: Bool {
        return self.code == APIErrorCode.success.rawValue
    }
    
}
