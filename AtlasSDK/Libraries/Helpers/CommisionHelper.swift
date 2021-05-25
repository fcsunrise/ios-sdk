//
//  CommisionHelper.swift
//  AtlasSDK
//
//  Created by Yelyzaveta Kartseva on 24.05.2021.
//

import Foundation

class CommisionHelper: NSObject {
    
    //MARK: - Shared
    
    static var shared = CommisionHelper()
    
    //MARK: - Lifecycle
    
    func calculateCommision(amount: Int, max: Int, min: Int, percentage: Int, fixed: Int) -> Double {
        let percentageCommision = (Double(amount)/100.0) * Double(percentage)
        let preparedCommision = Double(fixed) + percentageCommision
        if min == 0 && max == 0 {
            return preparedCommision
        }
        if preparedCommision > Double(max) {
            return Double(max)
        }
        if preparedCommision < Double(min) {
            return Double(min)
        }
        return preparedCommision
    }
    
}
