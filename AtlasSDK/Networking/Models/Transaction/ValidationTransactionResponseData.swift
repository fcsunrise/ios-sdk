//
//  ValidationTransactionResponseData.swift
//  AtlasSDK
//
//  Created by Yelyzaveta Kartseva on 24.05.2021.
//

import Foundation
import Marshal

public struct ValidationTransactionResponseData {
    
    var commision: AtlasCommision?
    var maxAmount: Int?
    var message: String?
    var validationInfo: String?
    
}

//MARK: - Unmarshaling
extension ValidationTransactionResponseData: Unmarshaling {
    
    public init(object: MarshaledObject) throws {
        self.commision = SerializerUtils.getObjectOf(type: AtlasCommision.self, from: object, by: APIParameterName.commission.rawValue)
        self.maxAmount = object.optionalAny(for: APIParameterName.maxAmount.rawValue) as? Int
        self.message = object.optionalAny(for: APIParameterName.messageText.rawValue) as? String
        self.validationInfo = object.optionalAny(for: APIParameterName.validationInfo.rawValue) as? String
    }
    
}
