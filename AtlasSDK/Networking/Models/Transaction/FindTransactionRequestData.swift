//
//  FindTransactionRequestData.swift
//  AtlasSDK
//
//  Created by Yelyzaveta Kartseva on 19.05.2021.
//

import Foundation
import Marshal

struct FindTransactionRequestData {
    
    var auth: AuthData?
    var locale: String
    var paymentID: String?
    var externalTransactionID: String?
    var oltpID: String?
    
    init(paymentID: String, auth: AuthData, locale: String) {
        self.auth = auth
        self.paymentID = paymentID
        self.locale = locale
    }
    
    init(externalTransactionID: String, auth: AuthData, locale: String) {
        self.auth = auth
        self.externalTransactionID = externalTransactionID
        self.locale = locale
    }
    
    init(oltpID: String, auth: AuthData, locale: String) {
        self.auth = auth
        self.oltpID = oltpID
        self.locale = locale
    }
    
}

//MARK: - JSONMarshaling
extension FindTransactionRequestData: JSONMarshaling {
    
    func jsonObject() -> JSONObject {
        if self.paymentID != nil {
            return [
                APIParameterName.auth.rawValue                  : self.auth?.jsonObject(),
                APIParameterName.locale.rawValue                : self.locale,
                APIParameterName.paymentId.rawValue             : self.paymentID,
            ]
        }
        if self.externalTransactionID != nil {
            return [
                APIParameterName.auth.rawValue                  : self.auth?.jsonObject(),
                APIParameterName.locale.rawValue                : self.locale,
                APIParameterName.externalTransactionID.rawValue : self.externalTransactionID,
            ]
        }
        return [
            APIParameterName.auth.rawValue                  : self.auth?.jsonObject(),
            APIParameterName.locale.rawValue                : self.locale,
            APIParameterName.oltpID.rawValue                : self.oltpID,
        ]
    }
    
}
