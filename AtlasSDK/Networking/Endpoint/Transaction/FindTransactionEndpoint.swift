//
//  FindTransactionEndpoint.swift
//  AtlasSDK
//
//  Created by Yelyzaveta Kartseva on 19.05.2021.
//

import Foundation
import Alamofire
import Marshal

class FindTransactionEndpoint: BaseEndpoint, APIEndpoint {
    
    typealias ResponseType = FindTransactionResponse
    
    var path: String {
        return APIPath.transactionFind
    }
    
}

struct FindTransactionResponse: Unmarshaling {
    
    let result: FindTransactionResponseData
    
    init(object: MarshaledObject) throws {
        result = try FindTransactionResponseData(object: object)
    }
    
}
