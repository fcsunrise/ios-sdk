//
//  StoryboardInstantiable.swift
//  AtlasSDK
//
//  Created by Yelyzaveta Kartseva on 17.05.2021.
//

import UIKit

protocol StoryboardInstantiable: class {
    
    static var storyboardName: String { get }
    
}

extension StoryboardInstantiable where Self: UIViewController {
    
    static func storyboardInstance() -> Self? {
        let storyboard = UIStoryboard(name: storyboardName, bundle: BundleHelper.bundle)
        return storyboard.instantiateViewController(withIdentifier: String(describing: Self.self)) as? Self
    }
    
    static func navigationController() -> UINavigationController? {
        let storyboard = UIStoryboard(name: storyboardName, bundle: BundleHelper.bundle)
        return storyboard.instantiateInitialViewController()
    }
    
}

