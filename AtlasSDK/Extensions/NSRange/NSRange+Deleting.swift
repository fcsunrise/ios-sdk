//
//  NSRange+Deleting.swift
//  AtlasSDK
//
//  Created by Yelyzaveta Kartseva on 17.05.2021.
//

import Foundation

extension NSRange {
    
    var isDeleting: Bool {
        return self.length > 0
    }
    
}
