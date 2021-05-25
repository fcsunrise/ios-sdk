//
//  AtlasPayCardNumberTableViewCell.swift
//  AtlasSDK
//
//  Created by Yelyzaveta Kartseva on 13.04.2021.
//

import UIKit

class AtlasPayCardNumberTableViewCell: UITableViewCell {
    
    //MARK: - Defaults
    
    private enum Defaults {
        static let cardNumberLength: Int = 16
    }
    
    //MARK: - Properties
    
    @IBOutlet weak private var vInput: BorderedTextFieldView!
    
    weak var delegate: BorderedTextFieldViewDelegate? {
        didSet {
            self.vInput.delegate = self.delegate
        }
    }
        
    var cardNumber: String? {
        didSet {
            self.updateCardNumber()
        }
    }
    
    //MARK: - Lifecycle
    
    override func awakeFromNib() {
        super.awakeFromNib()
        self.updateUI()
    }
    
    private func updateUI() {
        self.vInput.buttonImage = SDKImage.camera
        self.vInput.buttonName = SDKButton.camera.title
        self.vInput.inputType = .numbers
        self.vInput.maxCharactersCount = Defaults.cardNumberLength
        self.vInput.inputMask = .card
        self.vInput.set(contentType: .name)
    }
    
    private func updateCardNumber() {
        guard let number = self.cardNumber else {
            self.vInput.set(text: nil)
            return
        }
        var masked = ""
        var source = number
        for _ in 1...4 {
            let next = source.prefix(4)
            let lasted = source.count - 4
            source = source.suffix(lasted).description
            masked.append(next.description)
            masked.append(" ")
        }
        self.vInput.set(text: masked)
    }
    
}

//MARK: - AutoIndentifierCell
extension AtlasPayCardNumberTableViewCell: AutoIndentifierCell {}
