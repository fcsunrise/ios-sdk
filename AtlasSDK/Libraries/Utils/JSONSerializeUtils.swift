//
//  JSONSerializeUtils.swift
//  AtlasSDK
//
//  Created by Yelyzaveta Kartseva on 19.05.2021.
//

import Foundation

class JSONSerializeUtils: NSObject {
    
    public static func dictionaryToJSON(dictionary: [AnyHashable : Any]?) -> String? {
        guard let value = dictionary else {
            return nil
        }

        if let jsonData = try? JSONSerialization.data(withJSONObject: value, options: [.sortedKeys]) {
            return String(data: jsonData, encoding: .utf8)
        }
        return nil
    }
    
}
