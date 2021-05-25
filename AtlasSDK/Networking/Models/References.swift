//
//  References.swift
//  AtlasSDK
//
//  Created by Yelyzaveta Kartseva on 17.05.2021.
//

import Foundation
import Marshal

struct References {
    
    var successURL: URL?
    var failURL: URL?
    var callbackURL: URL?
    
}

//MARK: - JSONMarshaling
extension References: JSONMarshaling {
    
    func jsonObject() -> JSONObject {
        return [
            APIParameterName.callbackUrl.rawValue : self.callbackURL?.description.addingPercentEncoding(withAllowedCharacters: .urlHostAllowed) ?? "",
            APIParameterName.failUrl.rawValue : self.failURL?.description.addingPercentEncoding(withAllowedCharacters: .urlHostAllowed) ?? "",
            APIParameterName.successUrl.rawValue : self.successURL?.description.addingPercentEncoding(withAllowedCharacters: .urlHostAllowed) ?? ""
        ]
    }
    
}
