//
//  UIView+NibLoaded.swift
//  AtlasSDK
//
//  Created by Yelyzaveta Kartseva on 17.05.2021.
//

import UIKit
import QuickLayout

extension UIView {
    
    @discardableResult
    func fromNib<T : UIView>() -> T? {
        guard let contentView = BundleHelper.bundle.loadNibNamed(type(of: self).className, owner: self, options: nil)?.first as? T else {
            return nil
        }
        addSubview(contentView)
        contentView.fillSuperview()
        return contentView
    }
    
}
