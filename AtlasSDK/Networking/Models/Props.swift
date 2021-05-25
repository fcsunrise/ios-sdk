//
//  Props.swift
//  AtlasSDK
//
//  Created by Yelyzaveta Kartseva on 17.05.2021.
//

import Foundation
import Marshal

struct Props {
    
    var name: String?
    var slug: String?
    var value: String?
    
}

//MARK: - JSONMarshaling
extension Props: JSONMarshaling {
    
    func jsonObject() -> JSONObject {
        return [
            APIParameterName.name.rawValue : self.name,
            APIParameterName.slug.rawValue : self.slug,
            APIParameterName.value.rawValue : self.value
        ]
    }
    
}
