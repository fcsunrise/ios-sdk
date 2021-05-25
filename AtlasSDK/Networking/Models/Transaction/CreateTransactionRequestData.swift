//
//  CreateTransactionRequestData.swift
//  AtlasSDK
//
//  Created by Yelyzaveta Kartseva on 17.05.2021.
//

import Foundation
import Marshal

struct CreateTransactionRequestData {
    
    var auth: AuthData
    let serviceID: Int
    let locale: String
    let amount: Int
    let operationType: Int
    var fields: JSONObject?
    var references: References?
    
}

//MARK: - JSONMarshaling
extension CreateTransactionRequestData: JSONMarshaling {
    
    func jsonObject() -> JSONObject {
        return [
            APIParameterName.amount.rawValue                    : self.amount,
            APIParameterName.auth.rawValue                      : self.auth.jsonObject(),
            APIParameterName.fields.rawValue                    : self.fields ?? [:],
            APIParameterName.locale.rawValue                    : self.locale,
            APIParameterName.operationType.rawValue             : self.operationType,
            APIParameterName.ref.rawValue                       : self.references?.jsonObject(),
            APIParameterName.serviceID.rawValue                 : self.serviceID
        ]
    }

}
