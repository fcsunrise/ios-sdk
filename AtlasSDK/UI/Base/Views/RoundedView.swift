//
//  RoundedView.swift
//  AtlasSDK
//
//  Created by Yelyzaveta Kartseva on 19.05.2021.
//

import UIKit

class RoundedView: BaseView {
    
    // MARK: - Properties

    @IBInspectable var cornerRadius: CGFloat = 8.0 {
        didSet {
            self.layer.cornerRadius = self.cornerRadius
        }
    }
    
    // MARK: - Lifecycle

    override func layoutSubviews() {
        super.layoutSubviews()
        self.layer.cornerRadius = self.cornerRadius
    }

}
