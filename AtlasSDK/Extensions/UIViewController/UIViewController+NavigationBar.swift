//
//  UIViewController+NavigationBar.swift
//  AtlasSDK
//
//  Created by Yelyzaveta Kartseva on 17.05.2021.
//

import UIKit

extension UIViewController {
    
    //MARK: - Defaults
    
    enum Defaults {
        static let width: CGFloat = 24
        static let height: CGFloat = 24
    }
    
    enum Button {
        
        var image: UIImage? {
            return nil
        }
        
    }
    
    //MARK: - Showing
    
    func showNavBar(animated: Bool = false) {
        self.navigationController?.setNavigationBarHidden(false, animated: animated)
    }
    
    func hideNavBar(animated: Bool = false) {
        self.navigationController?.setNavigationBarHidden(true, animated: animated)
    }
    
    func showBackButton() {
        self.navigationItem.hidesBackButton = false
        self.navigationItem.leftBarButtonItem?.customView?.isHidden = false
    }

    func hideBackButton() {
        self.navigationItem.hidesBackButton = true
        self.navigationItem.leftBarButtonItem?.customView?.isHidden = true
    }
    
    //MARK: - Title

    func add(title: String) {
        self.navigationItem.title = title
    }
    
    func add(title: String, font: UIFont, color: UIColor) {
        let label = UILabel()
        let attributed = NSAttributedString(string: title, attributes: [
            .font               : font,
            .foregroundColor    : color
        ])
        label.attributedText = attributed
        self.navigationItem.titleView = label
    }
    
    //MARK: - Colors
    
    func setUpTintForNavBarButton(tint: UIColor, side: Sides) {
        (side == .left ? self.navigationItem.leftBarButtonItem : self.navigationItem.rightBarButtonItem)?.customView?.tintColor = tint
        (side == .left ? self.navigationItem.leftBarButtonItem : self.navigationItem.rightBarButtonItem)?.tintColor = tint
        self.navigationController?.navigationBar.tintColor = tint
    }
    
    func setUpNavigationBar(color: UIColor) {
        self.navigationController?.navigationBar.barTintColor = color
    }
    
    func setTransparentNavigationBar() {
        self.navigationController?.navigationBar.setBackgroundImage(UIImage(), for: .default)
        self.navigationController?.navigationBar.shadowImage = UIImage()
        self.navigationController?.navigationBar.isTranslucent = true
        self.navigationController?.view.backgroundColor = .clear
    }
    
    //MARK: - Buttons
    
    func set(button: Button, for side: Sides, action: Selector) {
        let navigationButton = self.createButton(from: button, selector: action)
        if side == .left {
            self.setLeft(button: navigationButton)
            return
        }
        if side == .right {
            self.setRight(button: navigationButton)
            return
        }
        fatalError("[UIViewController]: set(button:,_side:,action:) need implementation for side: \(side)")
    }
    
    private func setLeft(button: UIButton) {
        self.navigationItem.backBarButtonItem = UIBarButtonItem(title: "", style: .plain, target: nil, action: nil)
        self.navigationItem.leftBarButtonItem = UIBarButtonItem(customView: button)
    }
    
    private func setRight(button: UIButton) {
        self.navigationItem.rightBarButtonItem = UIBarButtonItem(title: "", style: .plain, target: nil, action: nil)
        self.navigationItem.rightBarButtonItem = UIBarButtonItem(customView: button)
    }
    
    private func createButton(from button: Button, selector: Selector) -> UIButton {
        let navigationButton = UIButton(type: .custom)
        navigationButton.setImage(button.image, for: .normal)
        navigationButton.addTarget(self, action: selector, for: .touchUpInside)
        navigationButton.bounds = CGRect(x: 0, y: 0, width: Defaults.width, height: Defaults.height)
        return navigationButton
        
    }
}
