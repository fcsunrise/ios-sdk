//
//  Core.swift
//  AtlasSDK
//
//  Created by Yelyzaveta Kartseva on 17.05.2021.
//

import Foundation

class Core: NSObject {
    
    //MARK: - Shared
    
    static var shared = Core()
    
    //MARK: - Properties
    
    private var _authManager = AuthManager()
    
    
    var authManager: AuthManager {
        return self._authManager
    }
    
}
