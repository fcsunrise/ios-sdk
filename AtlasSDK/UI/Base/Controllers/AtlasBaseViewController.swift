//
//  AtlasBaseViewController.swift
//  AtlasSDK
//
//  Created by Yelyzaveta Kartseva on 19.05.2021.
//

import UIKit

public class AtlasBaseViewController: UIViewController {
    
    //MARK: - Properties
    
    //MARK: - Lifecycle
    
    func setNavigationBar(isHidden: Bool) {
        self.navigationController?.isNavigationBarHidden = isHidden
    }
    
}
