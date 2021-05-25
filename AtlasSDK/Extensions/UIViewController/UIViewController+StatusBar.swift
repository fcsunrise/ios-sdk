//
//  UIViewController+StatusBar.swift
//  AtlasSDK
//
//  Created by Yelyzaveta Kartseva on 17.05.2021.
//

import UIKit

extension UIViewController {
    
    var statusBarHeight: CGFloat {
        return self.view.window?.windowScene?.statusBarManager?.statusBarFrame.height ?? 0
    }
    
}
