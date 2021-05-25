//
//  CardTokenizationService.swift
//  AtlasSDK
//
//  Created by Yelyzaveta Kartseva on 19.05.2021.
//

import Foundation
import Alamofire
import Marshal


class CardTokenizationService: BaseService, TransactionUsecase {
    
    //MARK: - Defaults
    
    //MARK: - Properties
        
    let transactionNetworkComponent: TransactionNetworkHandlerComponent
    
    var createTransactionCallback: ((CreateTransactionResponseData) -> Void)?
    
    var payURLCallback: ((_ payURL: URL, _ paymentID: String) ->())?
    
    //MARK: - Initialization
    
    init(with component: TransactionNetworkHandlerComponent) {
        self.transactionNetworkComponent = component
    }
    
    //MARK: - Lifecycle
    
    func tokenizeCard(serviceID: Int, fields: JSONObject?, references: References?, locale: String) {
        guard let point = Core.shared.authManager.pointID else {
            return
        }
        self.createTransaction(point: point, serviceID: serviceID, amount: 0, operationType: Services.webAcquiring.rawValue, fields: fields, references: references, locale: locale) { [weak self] (response) in
            if let payURLPath = response.result?.optionalAny(for: APIParameterName.payURL.rawValue) as? String, let paymentID = response.paymentID {
                let url = URL(string: payURLPath)
                self?.proceedWith(payURL: url, paymentID: paymentID, callback: self?.payURLCallback)
            }
            self?.createTransactionCallback?(response)
        }
    }
    
}
