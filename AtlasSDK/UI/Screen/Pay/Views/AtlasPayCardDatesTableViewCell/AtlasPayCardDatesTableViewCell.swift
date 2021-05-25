//
//  AtlasPayCardDatesTableViewCell.swift
//  AtlasSDK
//
//  Created by Yelyzaveta Kartseva on 13.04.2021.
//

import UIKit

class AtlasPayCardDatesTableViewCell: UITableViewCell {
    
    //MARK: - Defaults
    
    //MARK: - Properties
    
    @IBOutlet weak private var vInputMonth: BorderedTextFieldView!
    
    @IBOutlet weak private var vInputYear: BorderedTextFieldView!
    
    weak var delegate: BorderedTextFieldViewDelegate? {
        didSet {
            self.prepareDelegates()
        }
    }
    
    var month: String? {
        didSet {
            self.vInputMonth.set(text: self.month)
        }
    }
    
    var year: String? {
        didSet {
            self.vInputYear.set(text: self.year)
        }
    }
    
    //MARK: - Lifecycle
    
    override func awakeFromNib() {
        super.awakeFromNib()
        self.updateUI()
    }
    
    private func updateUI() {
        self.vInputYear.buttonImage = SDKImage.dropDown
        self.vInputYear.buttonName = SDKButton.dropDown.title
        self.vInputYear.inputType = .year
        self.vInputMonth.buttonName = SDKButton.dropDown.title
        self.vInputMonth.buttonImage = SDKImage.dropDown
        self.vInputMonth.inputType = .month
        self.vInputMonth.set(contentType: .name)
        self.vInputYear.set(contentType: .name)
    }
    
    private func prepareDelegates() {
        self.vInputMonth.delegate = self.delegate
        self.vInputYear.delegate = self.delegate
    }
    
}

//MARK: - AutoIndentifierCell
extension AtlasPayCardDatesTableViewCell: AutoIndentifierCell {}
