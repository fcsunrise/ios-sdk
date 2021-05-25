//
//  AtlasPayViewModel.swift
//  AtlasSDK
//
//  Created by Yelyzaveta Kartseva on 24.05.2021.
//

import Foundation

protocol AtlasTableViewCell {
    
}

class AtlasPayViewModel: NSObject {
    
    //MARK: - Defaults
    
    enum Defaults {
        static let paymentMask: String = "Оплата счета #"
        static let cardNumberLength: Int = 16
        static let cardCVVLength: Int = 3
    }
    
    enum Section: Int, CaseIterable {
        case paymentGeneral = 0
        case cardInfo
        case actionButtons
        case paymentCompanies
        
        var cellsCount: Int {
            switch self {
            case .paymentGeneral:
                if AtlasSDK.shared.paymentLogo != nil {
                    return PaymentGeneralCells.allCases.count
                }
                return 1
            case .cardInfo:
                return CardInfoCells.allCases.count
            case .actionButtons:
                return ActionButtons.allCases.count
            case .paymentCompanies:
                return PaymentCompanies.allCases.count
            }
        }
    }
    
    enum PaymentGeneralCells: Int, CaseIterable, AtlasTableViewCell {
        case logo = 0
        case sum
    }
    
    enum CardInfoCells: Int, CaseIterable, AtlasTableViewCell {
        case cardNumber = 0
        case cardDates
        case cardCVV
    }
    
    enum ActionButtons: Int, CaseIterable, AtlasTableViewCell {
        case pay = 0
        
        var name: String {
            switch self {
            case .pay:
                return "Оплатить"
            }
        }
    }
    
    enum PaymentCompanies: Int, CaseIterable, AtlasTableViewCell {
        case logos = 0
    }
    
    //MARK: - Properties
    
    private var amount: Int?
    
    private var fullAmount: Double?
        
    private var transactionID: String?
        
    private var cardNumber: String?
    
    private var expirationMonth: String?
    
    private var expirationYear: String?
    
    private var cvv: String?
    
    //MARK: - Lifecycle
    
    func set(fullAmount: Double?) {
        self.fullAmount = fullAmount
    }
    
    func set(number: String?) {
        self.cardNumber = number?.replacingOccurrences(of: " ", with: "")
    }
    
    func set(transactionID: String) {
        self.transactionID = transactionID
    }
    
    func set(amount: Int) {
        self.amount = amount
    }
    
    func set(expirationMonth: String?) {
        self.expirationMonth = expirationMonth
    }
    
    func set(expirationYear: String?) {
        self.expirationYear = expirationYear
    }
    
    func set(cvv: String?) {
        self.cvv = cvv
    }
    
    func getSectionsCount() -> Int {
        return Section.allCases.count
    }
    
    func getSectionType(from section: Int) -> Section? {
        return Section(rawValue: section)
    }
    
    func getCellType(from row: Int, section: Section) -> AtlasTableViewCell? {
        switch section {
        case .paymentGeneral:
            if self.isLogoEnabled() {
                return PaymentGeneralCells(rawValue: row)
            }
            return PaymentGeneralCells.sum
        case .cardInfo:
            return CardInfoCells(rawValue: row)
        case .actionButtons:
            return ActionButtons(rawValue: row)
        default:
            return PaymentCompanies(rawValue: row)
        }
    }
    
    func getCardFields() -> HostToHostFields? {
        guard let number = self.cardNumber,
           let year = self.expirationYear,
           let month = self.expirationMonth,
           let cvv = self.cvv else {
            return nil
        }
        if number.count != Defaults.cardNumberLength || cvv.count != Defaults.cardCVVLength {
            return nil
        }
        let shortYear = year.suffix(2)
        let expireDate = month + "/" + shortYear
        return HostToHostFields(cardNumber: number, expireDate: expireDate, cvv: cvv)
    }
    
    func getCardNumber() -> String? {
        return self.cardNumber
    }
    
    func getTransactionAmount() -> String? {
        guard let amount = self.fullAmount else {
            return nil
        }
        let prepared = String(format: "%.2f", amount / 100.0)
        return prepared.description
    }
    
    func getTransactionCoinsAmount() -> Int? {
        return self.amount
    }
    
    func getTransactionNumberTitle() -> String? {
        guard let number = self.transactionID else {
            return nil
        }
        return Defaults.paymentMask + number
    }
    
    func getTransactionNumber() -> String? {
        return self.transactionID
    }
    
    func getCardExpirationMonth() -> String? {
        return self.expirationMonth
    }
    
    func getCardExpirationYear() -> String? {
        return self.expirationYear
    }
    
    //MARK: - Private
    
    private func isLogoEnabled() -> Bool {
        return AtlasSDK.shared.paymentLogo != nil
    }
    
}
