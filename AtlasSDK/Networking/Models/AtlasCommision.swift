//
//  AtlasCommision.swift
//  AtlasSDK
//
//  Created by Yelyzaveta Kartseva on 24.05.2021.
//

import Foundation
import Marshal

public struct AtlasCommision {
    
    var sum: Int?
    var fixed: Int?
    var max: Int?
    var min: Int?
    var percentage: Int?
    
}

//MARK: - AtlasCommision
extension AtlasCommision: Unmarshaling {
    
    public init(object: MarshaledObject) throws {
        self.sum = object.optionalAny(for: APIParameterName.sum.rawValue) as? Int
        if let marshaledObjects = object.optionalAny(for: APIParameterName.value.rawValue) as? [MarshaledObject] {
            for object in marshaledObjects {
                if let max = object.optionalAny(for: APIParameterName.maxSum.rawValue) as? Int {
                    self.max = max
                }
                if let min = object.optionalAny(for: APIParameterName.minSum.rawValue) as? Int {
                    self.min = min
                }
                if let percentage = object.optionalAny(for: APIParameterName.value.rawValue) as? Int {
                    if self.percentage == nil {
                        self.percentage = percentage
                    }
                }
                if let fixed = object.optionalAny(for: APIParameterName.additionalFix.rawValue) as? Int {
                    self.fixed = fixed
                }
            }
        }
    }
    
}
