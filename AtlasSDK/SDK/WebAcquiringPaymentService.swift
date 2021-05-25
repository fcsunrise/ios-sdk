//
//  WebAcquiringPaymentService.swift
//  AtlasSDK
//
//  Created by Yelyzaveta Kartseva on 20.05.2021.
//

import Foundation
import Marshal

protocol WebAcquiringPaymentServiceDelegate: class {
    
    
}

class WebAcquiringPaymentService: BaseService, TransactionUsecase {
    
    //MARK: - Properties
        
    let transactionNetworkComponent: TransactionNetworkHandlerComponent
    
    var payURLCallback: ((_ payURL: URL, _ paymentID: String) ->())?
    
    var errorCallback: ((APIError) -> Void)?
    
    var threeDsCallBack: ((_ threeDS: URL, _ paymentID: String) ->())?
    
    var findTransactionCallback: ((_ paymentID: String, _ externalTransactionID: Int?, _ oltpID: Int?) -> Void)?
    
    var createTransactionCallback: ((CreateTransactionResponseData) -> Void)?
    
    //MARK: - Initialization
    
    init(with component: TransactionNetworkHandlerComponent) {
        self.transactionNetworkComponent = component
    }
    
    //MARK: - Lifecycle
    
    func pay(amount: Int, serviceID: Int, account: String, references: References?, locale: String) {
        guard let point = Core.shared.authManager.pointID else {
            return
        }
        let fields: JSONObject = [
            APIParameterName.account.rawValue : account
        ]
        self.transactionNetworkComponent.createTransaction(point: point, serviceID: serviceID, amount: amount, operationType: Services.webAcquiring.rawValue, fields: fields, references: references, locale: locale) { [weak self] (response) in
            self?.proceedByPayUrl(with: response)
            self?.createTransactionCallback?(response)
        }
    }
    
    func payByTokenizedCard(amount: Int, serviceID: Int, account: String, references: References?, locale: String, cardToken: String, cvv: String) {
        guard let point = Core.shared.authManager.pointID else {
            return
        }
        let fields: JSONObject = [
            APIParameterName.account.rawValue : account,
            APIParameterName.cardToken.rawValue : cardToken,
            APIParameterName.cvv.rawValue : cvv
        ]
        self.transactionNetworkComponent.createTransaction(point: point, serviceID: serviceID, amount: amount, operationType: Services.webAcquiring.rawValue, fields: fields, references: references, locale: locale) { [weak self] (response) in
            self?.proceedByPayUrl(with: response)
            self?.createTransactionCallback?(response)
        }
    }
    
    func payWithout3Ds(amount: Int, serviceID: Int, account: String, references: References?, locale: String) {
        guard let point = Core.shared.authManager.pointID else {
            return
        }
        let fields: JSONObject = [
            APIParameterName.account.rawValue : account
        ]
        self.transactionNetworkComponent.createTransaction(point: point, serviceID: serviceID, amount: amount, operationType: Services.webAcquiring.rawValue, fields: fields, references: references, locale: locale) { [weak self] (response) in
            self?.proceedByPayUrl(with: response)
            self?.createTransactionCallback?(response)
        }
    }
    
    func payWithout3DsByTokenizedCard(amount: Int, serviceID: Int, account: String, references: References?, locale: String, cardToken: String, cvv: String) {
        guard let point = Core.shared.authManager.pointID else {
            return
        }
        let fields: JSONObject = [
            APIParameterName.account.rawValue : account,
            APIParameterName.cardToken.rawValue : cardToken,
            APIParameterName.cvv.rawValue : cvv
        ]
        self.transactionNetworkComponent.createTransaction(point: point, serviceID: serviceID, amount: amount, operationType: Services.webAcquiring.rawValue, fields: fields, references: references, locale: locale) { [weak self] (response) in
            self?.proceedByPayUrl(with: response)
            self?.createTransactionCallback?(response)
        }
    }
    
    func motoPay(amount: Int, serviceID: Int, account: String, references: References?, locale: String, cardNumber: String, expirationMonth: String, expirationYear: String, cvv: String) {
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
        self.transactionNetworkComponent.createTransaction(point: point, serviceID: serviceID, amount: amount, operationType: Services.motoPayment.rawValue, fields: fields, references: references, locale: locale) { [weak self] (response) in
            
            if let payURLPath = response.result?.optionalAny(for: APIParameterName.payURL.rawValue) as? String, let paymentID = response.paymentID {
                cardFields[APIParameterName.paymentId.rawValue] = paymentID
                let url = URL(string: payURLPath)
                self?.proceedWith(link: url, parameters: cardFields).then({ (json)  in
                    if let _ = json[APIParameterName.result.rawValue] as? Bool {
                        self?.findTransactionCallback?(paymentID, response.externalTransactionID, response.oltpID)
                        return
                    }
                    if let result = json[APIParameterName.result.rawValue] as? [String : Any], let threeDs = result[APIParameterName.threeDs.rawValue] as? String, let link = URL(string: threeDs) {
                        self?.threeDsCallBack?(link, paymentID)
                    }
                }).catch({ (error) in
                    if let apiError = error as? APIError {
                        self?.errorCallback?(apiError)
                    }
                })
            }
            self?.createTransactionCallback?(response)
        }
    }
    
    //MARK: - Private
    
    private func proceedByPayUrl(with response: CreateTransactionResponseData) {
        if let payURLPath = response.result?.optionalAny(for: APIParameterName.payURL.rawValue) as? String, let paymentID = response.paymentID {
            let url = URL(string: payURLPath)
            self.proceedWith(payURL: url, paymentID: paymentID, callback: self.payURLCallback)
        }
    }
    
}
