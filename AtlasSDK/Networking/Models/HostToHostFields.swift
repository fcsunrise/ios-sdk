//
//  HostToHostFields.swift
//  AtlasSDK
//
//  Created by Yelyzaveta Kartseva on 24.05.2021.
//

import Foundation
import Marshal

public struct HostToHostFields {
    
    let cardNumber: String
    let expireDate: String
    let cvv: String
    
}

//MARK: - JSONMarshaling
extension HostToHostFields: JSONMarshaling {
    
    public func jsonObject() -> JSONObject {
        return [
            APIParameterName.cardNumber.rawValue        : self.cardNumber,
            APIParameterName.expirationDate.rawValue    : self.expireDate,
            APIParameterName.cvv.rawValue               : self.cvv
        ]
    }
    
}
