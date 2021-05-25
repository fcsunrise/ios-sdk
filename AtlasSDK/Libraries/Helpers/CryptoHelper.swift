//
//  CryptoHelper.swift
//  AtlasSDK
//
//  Created by Yelyzaveta Kartseva on 17.05.2021.
//

import Foundation
import CryptoKit

class CryptoHelper: NSObject {
    
    //MARK: - Defaults
    
    private enum Defaults {
        static var format: String = "%02hhx"
    }
    
    //MARK: - Shared
    
    static var shared = CryptoHelper()
    
    //MARK: - Lifecycle
    
    func md5(string: String) -> String {
        let digest = Insecure.MD5.hash(data: string.data(using: .utf8) ?? Data())
        return digest.map {
            String(format: Defaults.format, $0)
        }.joined()
    }
    
}
