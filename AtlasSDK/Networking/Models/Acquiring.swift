//
//  Acquiring.swift
//  AtlasSDK
//
//  Created by Yelyzaveta Kartseva on 17.05.2021.
//

import Foundation
import Marshal

struct Acquiring {
    
    var service: String?
    var commision: String?
    var bankTerminal: String?
    var serviceName: String?
    var serviceComment: String?
    var paymentDirection: Int?
}

//MARK: - JSONMarshaling
extension Acquiring: JSONMarshaling {
    
    func jsonObject() -> JSONObject {
        return [
            APIParameterName.service.rawValue : self.service,
            APIParameterName.commission.rawValue : self.commision,
            APIParameterName.bankTerminal.rawValue : self.bankTerminal,
            APIParameterName.serviceName.rawValue : self.serviceName,
            APIParameterName.serviceComment.rawValue : self.serviceComment,
            APIParameterName.paymentDirection.rawValue : self.paymentDirection
        ]
    }
    
}
