//
//  UIWindow+KeyWindow.swift
//  AtlasSDK
//
//  Created by Yelyzaveta Kartseva on 17.05.2021.
//

import UIKit

extension UIWindow {
    
    static func getKeyWindow() -> UIWindow? {
        return UIApplication.shared.connectedScenes
            .filter({$0.activationState == .foregroundActive})
            .map({$0 as? UIWindowScene})
            .compactMap({$0})
            .first?.windows
            .filter({$0.isKeyWindow}).first
    }
}

