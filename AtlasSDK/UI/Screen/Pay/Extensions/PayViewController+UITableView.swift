//
//  PayViewController+UITableView.swift
//  AtlasSDK
//
//  Created by Yelyzaveta Kartseva on 24.05.2021.
//

import UIKit

//MARK: - UITableViewDelegate
extension PayViewController: UITableViewDelegate {
    
}

//MARK: - UITableViewDataSource
extension PayViewController: UITableViewDataSource {
    
    public func numberOfSections(in tableView: UITableView) -> Int {
        self.uiViewModel.getSectionsCount()
    }
    
    //MARK: - Cells
    
    public func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        guard let section = self.uiViewModel.getSectionType(from: section) else {
            return 0
        }
        return section.cellsCount
    }
    
    public func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let section = self.uiViewModel.getSectionType(from: indexPath.section) else {
            return UITableViewCell()
        }
        guard let cellType = self.uiViewModel.getCellType(from: indexPath.row, section: section) else {
            return UITableViewCell()
        }
        switch cellType {
        
        case AtlasPayViewModel.PaymentGeneralCells.logo:
            let cell = tableView.getReusableCell(type: AtlasPayLogoTableViewCell.self, for: indexPath)!
            cell.logo = AtlasSDK.shared.paymentLogo
            return cell
        case AtlasPayViewModel.PaymentGeneralCells.sum:
            let sum = self.uiViewModel.getTransactionAmount()
            let cell = tableView.getReusableCell(type: AtlasPayGeneralSumTableViewCell.self, for: indexPath)!
            cell.sum = sum
            return cell
        case AtlasPayViewModel.CardInfoCells.cardNumber:
            let number = self.uiViewModel.getCardNumber()
            let cell = tableView.getReusableCell(type: AtlasPayCardNumberTableViewCell.self, for: indexPath)!
            cell.cardNumber = number
            cell.delegate = self
            return cell
        case AtlasPayViewModel.CardInfoCells.cardDates:
            let month = self.uiViewModel.getCardExpirationMonth()
            let year = self.uiViewModel.getCardExpirationYear()
            let cell = tableView.getReusableCell(type: AtlasPayCardDatesTableViewCell.self, for: indexPath)!
            cell.delegate = self
            cell.month = month
            cell.year = year
            return cell
        case AtlasPayViewModel.CardInfoCells.cardCVV:
            let cell = tableView.getReusableCell(type: AtlasPayCardCVVTableViewCell.self, for: indexPath)!
            cell.delegate = self
            return cell
        case AtlasPayViewModel.ActionButtons.pay:
            let cell = tableView.getReusableCell(type: AtlasPayActionButtonTableViewCell.self, for: indexPath)!
            let payButtonEnabled = self.uiViewModel.getCardFields() != nil
            cell.title = AtlasPayViewModel.ActionButtons.pay.name
            cell.delegate = self
            cell.isActive = payButtonEnabled
            cell.indexPath = indexPath
            self.setPayButton(enabled: payButtonEnabled)
            return cell
        case AtlasPayViewModel.PaymentCompanies.logos:
            let cell = tableView.getReusableCell(type: AtlasPayCompaniesTableViewCell.self, for: indexPath)!
            return cell
        default:
            return UITableViewCell()
        }
    }
    
    //MARK: - Header
    
    public func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 0.5
    }
    
    public func tableView(_ tableView: UITableView, estimatedHeightForHeaderInSection section: Int) -> CGFloat {
        return 0.5
    }
    
    //MARK: - Footer
    
    public func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return 0.5
    }
    
    public func tableView(_ tableView: UITableView, estimatedHeightForFooterInSection section: Int) -> CGFloat {
        return 0.5
    }
    
}
