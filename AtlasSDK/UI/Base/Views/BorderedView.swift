//
//  BorderedView.swift
//  AtlasSDK
//
//  Created by Yelyzaveta Kartseva on 19.05.2021.
//

import UIKit

@IBDesignable
class BorderedView: RoundedView {
    
    @IBInspectable var borderColor: UIColor = .clear {
        didSet {
            self.layer.borderColor = self.borderColor.cgColor
        }
    }
    
    @IBInspectable var borderWidth: CGFloat = 0 {
        didSet {
            self.layer.borderWidth = self.borderWidth
        }
    }
}
