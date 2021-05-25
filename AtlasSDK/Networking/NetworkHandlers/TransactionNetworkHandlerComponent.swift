//
//  TransactionNetworkHandlerComponent.swift
//  AtlasSDK
//
//  Created by Yelyzaveta Kartseva on 18.05.2021.
//

import Foundation
import Marshal
import Alamofire

class TransactionNetworkHandlerComponent: BaseNetworkHandler {
    
    func validateTransaction(point: String, serviceID: Int, amount: Int, operationType: Int, fields: JSONObject?, references: References?, locale: String, completion: @escaping(ValidationTransactionResponseData) -> Void) {
        var auth = AuthData(hash: "", point: point)
        var data = CreateTransactionRequestData(auth: auth, serviceID: serviceID, locale: locale, amount: amount, operationType: operationType, fields: fields, references: references)
        let authHash = Core.shared.authManager.createHash(with: data.jsonObject())
        auth.hash = authHash ?? ""
        data.auth = auth
        let request = APIClient.shared.validateTransaction(data: data) { (response, error) in
            if let error = error {
                self.delegate?.state = .failure(APIErrorValidator(error), .validateTransaction)
                return
            }
            guard let result = response?.result else {
                self.delegate?.state = .failure(.objectNotFound(errorDescription: nil), .createTransaction)
                return
            }
            completion(result)
            self.finishRequest(type: .validateTransaction)
        }
        self.startRequest(with: request, type: .validateTransaction)
    }
    
    func createTransaction(point: String, serviceID: Int, amount: Int, operationType: Int, fields: JSONObject?, references: References?, locale: String, completion: @escaping(CreateTransactionResponseData) -> Void) {
        var auth = AuthData(hash: "", point: point)
        var data = CreateTransactionRequestData(auth: auth, serviceID: serviceID, locale: locale, amount: amount, operationType: operationType, fields: fields, references: references)
        let authHash = Core.shared.authManager.createHash(with: data.jsonObject())
        auth.hash = authHash ?? ""
        data.auth = auth
        let request = APIClient.shared.createTransaction(data: data) { (response, error) in
            if let error = error {
                self.delegate?.state = .failure(APIErrorValidator(error), .createTransaction)
                return
            }
            guard let result = response?.result else {
                self.delegate?.state = .failure(.objectNotFound(errorDescription: nil), .createTransaction)
                return
            }
            completion(result)
            self.finishRequest(type: .createTransaction)
        }
        self.startRequest(with: request, type: .createTransaction)
    }

    
    func findTransaction(point: String, paymentID: String?, externalTransactionID: String?, oltpID: String?, locale: String, completion: @escaping(FindTransactionResponseData) -> Void) {
        var auth = AuthData(hash: "", point: point)
        var data: FindTransactionRequestData!
        if paymentID == nil && externalTransactionID == nil && oltpID == nil {
            return
        }
        if let paymentID = paymentID {
            data = FindTransactionRequestData(paymentID: paymentID, auth: auth, locale: locale)
        } else if let externalTransactionID = externalTransactionID {
            data = FindTransactionRequestData(externalTransactionID: externalTransactionID, auth: auth, locale: locale)
        } else if let oltpID = oltpID {
            data = FindTransactionRequestData(oltpID: oltpID, auth: auth, locale: locale)
        }
        let authHash = Core.shared.authManager.createHash(with: data.jsonObject())
        auth.hash = authHash ?? ""
        data.auth = auth
        
        let request = APIClient.shared.findTransaction(data: data) { (response, error) in
            if let error = error {
                self.delegate?.state = .failure(APIErrorValidator(error), .findTransaction)
                return
            }
            guard let result = response?.result else {
                self.delegate?.state = .failure(.objectNotFound(errorDescription: nil), .findTransaction)
                return
            }
            completion(result)
            self.finishRequest(type: .findTransaction)
        }
        self.startRequest(with: request, type: .findTransaction)
    }
    
}
