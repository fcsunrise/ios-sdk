//
//  CreateTransactionEndpoint.swift
//  AtlasSDK
//
//  Created by Yelyzaveta Kartseva on 18.05.2021.
//

import Foundation
import Alamofire
import Marshal

class CreateTransactionEndpoint: BaseEndpoint, APIEndpoint {
    
    typealias ResponseType = CreateTransactionResponse
    
    var path: String {
        return APIPath.transactionCreate
    }
    
}

struct CreateTransactionResponse: Unmarshaling {
    
    let result: CreateTransactionResponseData
    
    init(object: MarshaledObject) throws {
        result = try CreateTransactionResponseData(object: object)
    }
    
}
