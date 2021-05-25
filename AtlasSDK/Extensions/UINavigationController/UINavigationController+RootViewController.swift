//
//  UINavigationController+RootViewController.swift
//  AtlasSDK
//
//  Created by Yelyzaveta Kartseva on 17.05.2021.
//

import UIKit

extension UINavigationController {

    var rootViewController: UIViewController? {
        return viewControllers.first
    }
    
}
