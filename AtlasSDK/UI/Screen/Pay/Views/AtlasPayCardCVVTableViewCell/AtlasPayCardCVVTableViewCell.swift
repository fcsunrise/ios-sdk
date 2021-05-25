//
//  AtlasPayCardCVVTableViewCell.swift
//  AtlasSDK
//
//  Created by Yelyzaveta Kartseva on 13.04.2021.
//

import UIKit

class AtlasPayCardCVVTableViewCell: UITableViewCell {
    
    //MARK: - Defaults
    
    private enum Defaults {
        static let cvvLenght: Int = 3
    }
    
    //MARK: - Properties
    
    @IBOutlet weak private var vInput: BorderedTextFieldView!
    @IBOutlet weak private var lblInfo: UILabel!
    
    weak var delegate: BorderedTextFieldViewDelegate? {
        didSet {
            self.prepareDelegates()
        }
    }
    
    //MARK: - Lifecycle
    
    override func awakeFromNib() {
        super.awakeFromNib()
        self.updateUI()
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        self.vInput.set(text: nil)
    }
    
    private func updateUI() {
        self.vInput.inputType = .cvv
        self.vInput.buttonImage = SDKImage.info
        self.vInput.buttonName = SDKButton.info.title
        self.vInput.maxCharactersCount = Defaults.cvvLenght
        self.vInput.inputMask = nil
        self.vInput.set(contentType: UITextContentType.password)
    }
    
    private func prepareDelegates() {
        self.vInput.delegate = self.delegate
    }
    
}

//MARK: - AutoIndentifierCell
extension AtlasPayCardCVVTableViewCell: AutoIndentifierCell {}
