//
//  BundleHelper.swift
//  AtlasSDK
//
//  Created by Yelyzaveta Kartseva on 14.05.2021.
//

import Foundation
import UIKit

class BundleHelper: NSObject {
    
    static var bundle: Bundle {
        let myBundle = Bundle(for: Self.self)
        guard let resourceBundleURL = myBundle.url(
            forResource: "AtlasSDK", withExtension: "bundle")
            else {
            fatalError("AtlasSDK.bundle not found!")
        }
        guard let resourceBundle = Bundle(url: resourceBundleURL)
            else {
            fatalError("Cannot access AtlasSDK.bundle!")
        }
        return resourceBundle
    }
    
}
