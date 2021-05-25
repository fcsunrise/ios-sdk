//
//  UITableView+CellRegistration.swift
//  AtlasSDK
//
//  Created by Yelyzaveta Kartseva on 17.05.2021.
//

import UIKit

extension UITableView {

    func registerCells<T: AutoIndentifierCell>(cells: [T.Type]) {
        for cell in cells {
            self.register(UINib(nibName: cell.nibName, bundle: BundleHelper.bundle), forCellReuseIdentifier: cell.identifier)
        }
    }
    
    func register(cells: [AutoIndentifierCell.Type]) {
        for cell in cells {
            self.register(UINib(nibName: cell.nibName, bundle: BundleHelper.bundle), forCellReuseIdentifier: cell.identifier)
        }
    }
    
    func getReusableCell<T: AutoIndentifierCell>(type: T.Type, for indexPath: IndexPath) -> T? {
        return self.dequeueReusableCell(withIdentifier: type.identifier, for: indexPath) as? T
    }
    
}
