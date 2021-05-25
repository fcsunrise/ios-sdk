//
//  TransactionUsecase.swift
//  AtlasSDK
//
//  Created by Yelyzaveta Kartseva on 19.05.2021.
//

import Foundation
import Marshal
    
//MARK: - Declaration

protocol TransactionUsecase {
    
    var transactionNetworkComponent: TransactionNetworkHandlerComponent { get }
    
    func createTransaction(point: String, serviceID: Int, amount: Int, operationType: Int, fields: JSONObject?, references: References?, locale: String, completion: @escaping(CreateTransactionResponseData) -> Void)
    
    func validateTransaction(point: String, serviceID: Int, amount: Int, operationType: Int, fields: JSONObject?, references: References?, locale: String, completion: @escaping(ValidationTransactionResponseData) -> Void)
    
}

//MARK: - Implementation

extension TransactionUsecase {
    
    func createTransaction(point: String, serviceID: Int, amount: Int, operationType: Int, fields: JSONObject?, references: References?, locale: String, completion: @escaping(CreateTransactionResponseData) -> Void) {
        self.transactionNetworkComponent.createTransaction(point: point, serviceID: serviceID, amount: amount, operationType: operationType, fields: fields, references: references, locale: locale, completion: completion)
    }
    
    func validateTransaction(point: String, serviceID: Int, amount: Int, operationType: Int, fields: JSONObject?, references: References?, locale: String, completion: @escaping (ValidationTransactionResponseData) -> Void) {
        self.transactionNetworkComponent.validateTransaction(point: point, serviceID: serviceID, amount: amount, operationType: operationType, fields: fields, references: references, locale: locale, completion: completion)
    }
    
}
