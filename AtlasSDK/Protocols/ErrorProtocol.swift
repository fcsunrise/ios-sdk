//
//  ErrorProtocol.swift
//  AtlasSDK
//
//  Created by Yelyzaveta Kartseva on 17.05.2021.
//

import Foundation

protocol ErrorProtocol: class {
    
    func didFail(with error: Error)
    
}
