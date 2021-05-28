//
//  AuthManager.swift
//  AtlasSDK
//
//  Created by Yelyzaveta Kartseva on 17.05.2021.
//

import Foundation
import Marshal

class AuthManager: NSObject {
    
    //MARK: - Properties
    
    var pointToken: String?
    
    var pointID: String?
    
    //MARK: - Lifecycle
    
    func createHash(with parameters: JSONObject) -> String? {
        guard let pointToken = self.pointToken else {
            return nil
        }
        guard let dictionaryJSON = JSONSerializeUtils.dictionaryToJSON(dictionary: parameters) else {
            return nil
        }
        let jsonString = dictionaryJSON.replacingOccurrences(of: " ", with: "") + pointToken
        let encripted = CryptoHelper.shared.md5(string: jsonString.replacingOccurrences(of: "\\", with: ""))
        return encripted
    }
    
}
