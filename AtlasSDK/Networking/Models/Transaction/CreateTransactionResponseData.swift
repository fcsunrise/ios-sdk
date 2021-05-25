//
//  CreateTransactionResponseData.swift
//  AtlasSDK
//
//  Created by Yelyzaveta Kartseva on 18.05.2021.
//

import Foundation
import Marshal

public struct CreateTransactionResponseData {
    
    public let status: Int
    public var result: JSONObject?
    public let paymentID: String?
    public var oltpID: Int?
    public let serviceID: Int
    public let pointID: String
    public let amount: Int
    public var externalCommission: Int?
    public var externalTransactionID: Int?
    
}

//MARK: - Unmarshaling
extension CreateTransactionResponseData: Unmarshaling {
    
    public init(object: MarshaledObject) throws {
        self.status                 = try object.any(for: APIParameterName.status.rawValue) as! Int
        self.result                 = object.optionalAny(for: APIParameterName.result.rawValue) as? JSONObject
        self.paymentID              = object.optionalAny(for: APIParameterName.paymentId.rawValue) as? String
        self.oltpID                 = object.optionalAny(for: APIParameterName.oltpID.rawValue) as? Int
        self.serviceID              = try object.any(for: APIParameterName.serviceID.rawValue) as! Int
        self.pointID                = try object.any(for: APIParameterName.pointID.rawValue) as! String
        self.amount                 = try object.any(for: APIParameterName.amount.rawValue) as! Int
        self.externalCommission     = object.optionalAny(for: APIParameterName.externalCommission.rawValue) as? Int
        self.externalTransactionID  = object.optionalAny(for: APIParameterName.externalTransactionID.rawValue) as? Int
    }
    
}

//MARK: - JSONMarshaling
extension CreateTransactionResponseData: JSONMarshaling {
    
    public func jsonObject() -> JSONObject {
        return [
            APIParameterName.status.rawValue                : self.status,
            APIParameterName.result.rawValue                : self.result,
            APIParameterName.paymentId.rawValue             : self.paymentID,
            APIParameterName.oltpID.rawValue                : self.oltpID,
            APIParameterName.serviceID.rawValue             : self.serviceID,
            APIParameterName.pointID.rawValue               : self.pointID,
            APIParameterName.amount.rawValue                : self.amount,
            APIParameterName.externalCommission.rawValue    : self.externalCommission,
            APIParameterName.externalTransactionID.rawValue : self.externalTransactionID
        ]
    }
    
}
