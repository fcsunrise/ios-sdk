//
//  FindTransactionResponseData.swift
//  AtlasSDK
//
//  Created by Yelyzaveta Kartseva on 19.05.2021.
//

import Foundation
import Marshal

public struct FindTransactionResponseData {
    
    public let paymentID: String
    public let receiptNumber: String
    public var isTest: Bool?
    public let status: Int
    public let statusDescription: String
    public let pointID: String
    public let serviceID: Int
    public let amount: Int
    public let externalCommision: Int
    public var created: String?
    public var confirmed: String?
    public var receiptURL: URL?
    public let externalTransactionID: String?
    public var registrationID: String?
    public var additional: JSONObject?
    public var acquiringErrors: JSONObject?
    public var fields: JSONObject?
    
}

//MARK: - Unmarshaling
extension FindTransactionResponseData: Unmarshaling {
    
    public init(object: MarshaledObject) throws {
        self.paymentID = try object.any(for: APIParameterName.paymentId.rawValue) as! String
        self.receiptNumber = try object.any(for: APIParameterName.receiptNumber.rawValue) as! String
        self.isTest = object.optionalAny(for: APIParameterName.isTest.rawValue) as? Bool
        self.status = try object.any(for: APIParameterName.status.rawValue) as! Int
        self.statusDescription = try object.any(for: APIParameterName.statusDescription.rawValue) as! String
        self.pointID = try object.any(for: APIParameterName.pointID.rawValue) as! String
        self.serviceID = try object.any(for: APIParameterName.serviceID.rawValue) as! Int
        self.amount = try object.any(for: APIParameterName.amount.rawValue) as! Int
        self.externalCommision = try object.any(for: APIParameterName.externalCommission.rawValue) as! Int
        self.created = object.optionalAny(for: APIParameterName.created.rawValue) as? String
        self.confirmed = object.optionalAny(for: APIParameterName.confirmed.rawValue) as? String
        if let receiptPath = object.optionalAny(for: APIParameterName.receiptURL.rawValue) as? String {
            self.receiptURL = URL(string: receiptPath)
        }
        self.externalTransactionID = object.optionalAny(for: APIParameterName.externalTransactionID.rawValue) as? String
        self.registrationID = object.optionalAny(for: APIParameterName.registrationID.rawValue) as? String
        self.additional = object.optionalAny(for: APIParameterName.additional.rawValue) as? JSONObject
        self.acquiringErrors = object.optionalAny(for: APIParameterName.acquiringErrors.rawValue) as? JSONObject
        self.fields = object.optionalAny(for: APIParameterName.fields.rawValue) as? JSONObject
    }
    
}

//MARK: - JSONMarshaling
extension FindTransactionResponseData: JSONMarshaling {
    
    public func jsonObject() -> JSONObject {
        return [
            APIParameterName.paymentId.rawValue : self.paymentID,
            APIParameterName.receiptNumber.rawValue : self.receiptNumber,
            APIParameterName.isTest.rawValue : self.isTest,
            APIParameterName.status.rawValue : self.status,
            APIParameterName.statusDescription.rawValue : self.statusDescription,
            APIParameterName.pointID.rawValue : self.pointID,
            APIParameterName.serviceID.rawValue : self.serviceID,
            APIParameterName.amount.rawValue : self.amount,
            APIParameterName.externalCommission.rawValue : self.externalCommision,
            APIParameterName.created.rawValue : self.created,
            APIParameterName.confirmed.rawValue : self.confirmed,
            APIParameterName.receiptURL.rawValue : self.receiptURL,
            APIParameterName.externalTransactionID.rawValue : self.externalTransactionID,
            APIParameterName.registrationID.rawValue : self.registrationID,
            APIParameterName.additional.rawValue : self.additional,
            APIParameterName.acquiringErrors.rawValue : self.acquiringErrors,
            APIParameterName.fields.rawValue : self.fields
        ]
    }
    
}
