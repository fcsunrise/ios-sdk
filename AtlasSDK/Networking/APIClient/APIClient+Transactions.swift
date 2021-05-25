//
//  APIClient+Transactions.swift
//  AtlasSDK
//
//  Created by Yelyzaveta Kartseva on 18.05.2021.
//

import Foundation
import Alamofire
import Marshal

extension APIClient {
    
    func validateTransaction(data: CreateTransactionRequestData, completion: @escaping(ValidateTransactionResponse?, Error?) -> Void) -> DataRequest {
        let endpoint = ValidateTransactionEndpoint(attributes: data.jsonObject())
        return self.manager.requestJSON(baseURL, endpoint: endpoint, completion: completion)
        
    }
    
    func createTransaction(data: CreateTransactionRequestData, completion: @escaping(CreateTransactionResponse?, Error?) -> Void) -> DataRequest {
        let endpoint = CreateTransactionEndpoint(attributes: data.jsonObject())
        return self.manager.requestJSON(baseURL, endpoint: endpoint, completion: completion)
    }
    
    func findTransaction(data: FindTransactionRequestData, completion: @escaping(FindTransactionResponse?, Error?) -> Void) -> DataRequest {
        let endpoint = FindTransactionEndpoint(attributes: data.jsonObject())
        return self.manager.requestJSON(baseURL, endpoint: endpoint, completion: completion)
    }
}
