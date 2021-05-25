//
//  HostToHostService.swift
//  AtlasSDK
//
//  Created by Yelyzaveta Kartseva on 20.05.2021.
//

import Foundation
import Marshal
import Promise

class HostToHostService: BaseService, TransactionUsecase {
    
    //MARK: - Properties
    
    let transactionNetworkComponent: TransactionNetworkHandlerComponent
            
    var createTransactionCallback: ((CreateTransactionResponseData) -> Void)?
    
    var findTransactionCallback: ((_ paymentID: String, _ externalTransactionID: Int?, _ oltpID: Int?) -> Void)?
    
    var threeDsCallBack: ((_ threeDS: URL, _ paymentID: String) ->())?
    
    var errorCallback: ((APIError) -> Void)?
    
    //MARK: - Initialization
    
    init(with component: TransactionNetworkHandlerComponent) {
        self.transactionNetworkComponent = component
    }
    
    //MARK: - Lifecycle
    
    func pay(amount: Int, account: String, serviceID: Int, references: References?, locale: String, cardNumber: String, expirationMonth: String, expirationYear: String, cvv: String)  {
        guard let point = Core.shared.authManager.pointID else {
            return
        }
        let expirationDate = expirationMonth + "/" + expirationYear
        var cardFields: JSONObject = [
            APIParameterName.cardNumber.rawValue : cardNumber,
            APIParameterName.expirationDate.rawValue : expirationDate,
            APIParameterName.cvv.rawValue : cvv,
            APIParameterName.pointID.rawValue : point,
            APIParameterName.locale.rawValue : locale
        ]
        let fields: JSONObject = [
            APIParameterName.account.rawValue : account
        ]
        self.transactionNetworkComponent.createTransaction(point: point, serviceID: serviceID, amount: amount, operationType: Services.host2host.rawValue, fields: fields, references: references, locale: locale) { [weak self] (response) in
            self?.createTransactionCallback?(response)
            if let payURLPath = response.result?.optionalAny(for: APIParameterName.payURL.rawValue) as? String, let paymentID = response.paymentID, let url = URL(string: payURLPath) {
                
                cardFields[APIParameterName.paymentId.rawValue] = paymentID
                print("LINK: \(url)")
                self?.proceedWith(link: url, parameters: cardFields).then({ (json) in
                    if let _ = json[APIParameterName.result.rawValue] as? Bool {
                        self?.findTransactionCallback?(paymentID, response.externalTransactionID, response.oltpID)
                        return
                    }
                    if let result = json[APIParameterName.result.rawValue] as? [String : Any], let threeDs = result[APIParameterName.threeDs.rawValue] as? String, let link = URL(string: threeDs) {
                        self?.threeDsCallBack?(link, paymentID)
                    }
                }).catch({ [weak self] (error) in
                    if let apiError = error as? APIError {
                        self?.errorCallback?(apiError)
                    }
                })
            }
        }
    }
    
    func payByCardToken(amount: Int, serviceID: Int, account: String, references: References?, locale: String, token: String, cvv: String) {
        guard let point = Core.shared.authManager.pointID else {
            return
        }
        var cardFields: JSONObject = [
            APIParameterName.cardToken.rawValue : token,
            APIParameterName.cvv.rawValue : cvv,
            APIParameterName.pointID.rawValue : point,
            APIParameterName.locale.rawValue : locale
        ]
        let fields: JSONObject = [
            APIParameterName.account.rawValue : account
        ]
        self.transactionNetworkComponent.createTransaction(point: point, serviceID: serviceID, amount: amount, operationType: Services.host2hostToken.rawValue, fields: fields, references: references, locale: locale) { [weak self] (response) in
            self?.createTransactionCallback?(response)
            if let payURLPath = response.result?.optionalAny(for: APIParameterName.payURL.rawValue) as? String, let paymentID = response.paymentID {
                let url = URL(string: payURLPath)
                cardFields[APIParameterName.paymentId.rawValue] = paymentID
                self?.proceedWith(link: url, parameters: cardFields).then({ (json) in
                    if let _ = json[APIParameterName.result.rawValue] as? Bool {
                        self?.findTransactionCallback?(paymentID, response.externalTransactionID, response.oltpID)
                        return
                    }
                    if let result = json[APIParameterName.result.rawValue] as? [String : Any], let threeDs = result[APIParameterName.threeDs.rawValue] as? String, let link = URL(string: threeDs) {
                        self?.threeDsCallBack?(link, paymentID)
                    }
                }).catch({ [weak self] (error) in
                    if let apiError = error as? APIError {
                        self?.errorCallback?(apiError)
                    }
                })
            }
        }
    }
}
