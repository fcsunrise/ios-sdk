//
//  PayViewController+CellsDelegate.swift
//  AtlasSDK
//
//  Created by Yelyzaveta Kartseva on 24.05.2021.
//

import Foundation

//MARK: - AtlasPayActionButtonTableViewCellDelegate
extension PayViewController: AtlasPayActionButtonTableViewCellDelegate {
    
    func didTouchButton(with indexPath: IndexPath) {
        guard let action = AtlasPayViewModel.ActionButtons(rawValue: indexPath.row) else {
            return
        }
        switch action {
        case .pay:
            self.pay()
        }
    }
    
}

//MARK: - BorderedTextFieldViewDelegate
extension PayViewController: BorderedTextFieldViewDelegate {
    
    func didTouchButton(with name: String?) {
        guard let name = name else {
            return
        }
        guard let buttonType = SDKButton.from(string: name) else {
            return
        }
        if buttonType == .camera {
            self.pushScannerScreen()
        }
    }
    
    func didEnter(text: String?, type: InputType) {
        guard let text = text else {
            return
        }
        switch type {
        case .numbers:
            let filtered = text.replacingOccurrences(of: " ", with: "")
            self.uiViewModel.set(number: filtered)
        case .cvv:
            self.uiViewModel.set(cvv: text)
        case .month:
            self.uiViewModel.set(expirationMonth: text)
        case .year:
            self.uiViewModel.set(expirationYear: text)
        default:
            break
        }
        self.reloadPayButtonIfNeeded()
    }
    
}
