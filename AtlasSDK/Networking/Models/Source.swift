//
//  Source.swift
//  AtlasSDK
//
//  Created by Yelyzaveta Kartseva on 17.05.2021.
//

import Foundation
import Marshal

struct Source {
    
    var device: String?
    var os: String?
    var userAgent: String?
    
}

//MARK: - JSON
extension Source: JSONMarshaling {
    
    func jsonObject() -> JSONObject {
        return [
            APIParameterName.device.rawValue : self.device,
            APIParameterName.os.rawValue : self.os,
            APIParameterName.userAgent.rawValue : self.userAgent
        ]
    }
    
}
