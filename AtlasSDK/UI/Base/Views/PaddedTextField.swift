//
//  PaddedTextField.swift
//  AtlasSDK
//
//  Created by Yelyzaveta Kartseva on 19.05.2021.
//

import UIKit

@IBDesignable
class PaddedTextField: UITextField {
    
    //MARK: - Properties
    
    @IBInspectable var topPadding: CGFloat = 0
    
    @IBInspectable var leftPadding: CGFloat = 0
    
    @IBInspectable var bottomPadding: CGFloat = 0
    
    @IBInspectable var rightPadding: CGFloat = 0
    
    private var padding: UIEdgeInsets {
        return UIEdgeInsets(top: self.topPadding, left: self.leftPadding, bottom: self.bottomPadding, right: self.rightPadding)
    }
    
    //MARK: - Lifecycle

    override open func textRect(forBounds bounds: CGRect) -> CGRect {
        return bounds.inset(by: self.padding)
    }

    override open func placeholderRect(forBounds bounds: CGRect) -> CGRect {
        return bounds.inset(by: self.padding)
    }

    override open func editingRect(forBounds bounds: CGRect) -> CGRect {
        return bounds.inset(by: self.padding)
    }
    
}
