//
//  UIWindow+SafeAreaSizes.swift
//  AtlasSDK
//
//  Created by Yelyzaveta Kartseva on 17.05.2021.
//

import UIKit

extension UIWindow {
    
    static var heightOfTopSafeArea: CGFloat {
        var topPadding: CGFloat = 0.0
        if #available(iOS 13.0, *) {
            guard let keyWindow = UIApplication.shared.connectedScenes
                .filter({$0.activationState == .foregroundActive})
                .map({$0 as? UIWindowScene})
                .compactMap({$0})
                .first?.windows
                .filter({$0.isKeyWindow}).first else {
                    return topPadding
            }
            topPadding = keyWindow.safeAreaInsets.top
        } else {
            let window = UIApplication.shared.keyWindow
            topPadding = window?.safeAreaInsets.top ?? 0
        }
        return topPadding
    }
    
    static var bottomSafeArea: CGFloat {
        var bottomPadding: CGFloat = 0.0
        if #available(iOS 13.0, *) {
            guard let keyWindow = UIApplication.shared.connectedScenes
                .filter({$0.activationState == .foregroundActive})
                .map({$0 as? UIWindowScene})
                .compactMap({$0})
                .first?.windows
                .filter({$0.isKeyWindow}).first else {
                    return bottomPadding
            }
            bottomPadding = keyWindow.safeAreaInsets.bottom
        } else {
            let window = UIApplication.shared.keyWindow
            bottomPadding = window?.safeAreaInsets.bottom ?? 0
        }
        return bottomPadding
    }
    
}
