//
//  ValidateTransactionEndpoint.swift
//  AtlasSDK
//
//  Created by Yelyzaveta Kartseva on 19.05.2021.
//

import Foundation
import Alamofire
import Marshal

class ValidateTransactionEndpoint: BaseEndpoint, APIEndpoint {
    
    typealias ResponseType = ValidateTransactionResponse
    
    var path: String {
        return APIPath.transactionValidate
    }
    
}

struct ValidateTransactionResponse: Unmarshaling {
    
    let result: ValidationTransactionResponseData
    
    init(object: MarshaledObject) throws {
        self.result = try ValidationTransactionResponseData(object: object)
    }
    
}
