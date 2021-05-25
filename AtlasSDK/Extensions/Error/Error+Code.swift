//
//  Error+Code.swift
//  AtlasSDK
//
//  Created by Yelyzaveta Kartseva on 17.05.2021.
//

import Foundation

extension Error {
        
    var errorCode: Int {
        return (self as NSError).code
    }
    
}

