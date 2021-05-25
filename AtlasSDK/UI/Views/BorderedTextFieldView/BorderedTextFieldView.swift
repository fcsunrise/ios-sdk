//
//  BorderedTextFieldView.swift
//  AtlasSDK
//
//  Created by Yelyzaveta Kartseva on 11.04.2021.
//

import UIKit

protocol BorderedTextFieldViewDelegate: class {
    
    func didTouchButton(with name: String?)
    
    func didEnter(text: String?, type: InputType)
    
}

class BorderedTextFieldView: BaseView {
    
    //MARK: - Defaults
    
    private enum Defaults {
        static let maxYears: Int = 200
    }
    
    //MARK: - Properties
    
    @IBOutlet weak private var tfContent: PaddedTextField!
    @IBOutlet weak private var btnAction: UIButton!
    
    weak var delegate: BorderedTextFieldViewDelegate?
    
    @IBInspectable var placeholder: String = "Название карты" {
        didSet {
            self.updatePlaceholder()
        }
    }
    
    lazy private var monthPicker: UIPickerView = {
        let picker = UIPickerView()
        picker.delegate = self
        picker.dataSource = self
        return picker
    }()
    
    lazy private var yearPicker: UIPickerView = {
        let picker = UIPickerView()
        picker.delegate = self
        picker.dataSource = self
        return picker
    }()
    
    lazy private var years: [Int] = {
        var results = [Int]()
        let current = Calendar.current.component(.year, from: Date())
        for year in current...current + Defaults.maxYears {
            results.append(year)
        }
        return results
    }()
    
    var buttonName: String?
    
    var buttonImage: UIImage? {
        didSet {
            guard let image = self.buttonImage else {
                self.btnAction.isHidden = true
                return
            }
            self.btnAction.isHidden = false
            self.btnAction.setImage(image, for: .normal)
        }
    }
    
    var inputType: InputType = .name {
        didSet {
            self.updateKeyboardType()
        }
    }
        
    var maxCharactersCount: Int?
    
    var inputMask: Mask?
        
    //MARK: - Lifcycle
    
    override func commonInit() {
        super.commonInit()
        self.fromNib()
        self.addToolbar()
        self.prepareDelegates()
    }
    
    func set(text: String?) {
        self.tfContent.text = text
    }
    
    func set(contentType: UITextContentType) {
        if contentType == .password {
            self.tfContent.isSecureTextEntry = true
        } else {
            self.tfContent.isSecureTextEntry = false
        }
        self.tfContent.textContentType = contentType
    }
    
    private func prepareDelegates() {
        self.tfContent.delegate = self
    }
    
    private func updateKeyboardType() {
        switch self.inputType {
        case .name:
            self.tfContent.keyboardType = .default
        case .numbers, .cvv:
            self.tfContent.keyboardType = .numberPad
        case .month:
            self.setMonthPickerInput()
        case .year:
            self.setYearPickerInput()
        }
    }
    
    private func setYearPickerInput() {
        self.tfContent.inputView = self.yearPicker
    }
    
    private func setMonthPickerInput() {
        self.tfContent.inputView = self.monthPicker
    }
    
    private func addToolbar() {
        let bar = UIToolbar()
        let done = UIBarButtonItem(title: "Done", style: .done, target: self, action: #selector(didTapDoneButton))
        bar.items = [done]
        bar.sizeToFit()
        self.tfContent.inputAccessoryView = bar
    }
    
    private func updatePlaceholder() {
        let attributed = NSAttributedString(string: self.placeholder, attributes: [
            .font               : UIFont.systemFont(ofSize: 13, weight: .light),
            .foregroundColor    : UIColor.sdkBlack
        ])
        self.tfContent.attributedPlaceholder = attributed
    }
    
    //MARK: - Handlers
    
    @IBAction private func didTouchButton(_ sender: Any) {
        guard let name = self.buttonName else {
            return
        }
        self.delegate?.didTouchButton(with: name)
        if self.inputType == .month || self.inputType == .year {
            self.tfContent.becomeFirstResponder()
        }
    }
    
    @IBAction private func didChangeText(_ sender: Any) {
        let text = self.tfContent.text
        self.delegate?.didEnter(text: text, type: self.inputType)
    }
    
    @objc private func didTapDoneButton() {
        self.tfContent.endEditing(true)
        let text = self.tfContent.text
        self.delegate?.didEnter(text: text, type: self.inputType)
    }
    
}

//MARK: - UIPickerViewDelegate
extension BorderedTextFieldView: UIPickerViewDelegate {
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        if self.inputType == .month {
            let month = Month.allCases[row].monthNumber
            self.tfContent.text = month
            self.delegate?.didEnter(text: month, type: self.inputType)
        }
        if self.inputType == .year {
            let year = self.years[row].description
            self.tfContent.text = year
            self.delegate?.didEnter(text: year, type: self.inputType)
        }
    }
    
}

//MARK: - UIPickerViewDataSource
extension BorderedTextFieldView: UIPickerViewDataSource {
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        if self.inputType == .month {
            return Month.allCases.count
        }
        if self.inputType == .year {
            return self.years.count
        }
        return 0
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        if self.inputType == .month {
            return Month.allCases[row].monthNumber
        }
        if self.inputType == .year {
            return self.years[row].description
        }
        return nil
    }
    
}

//MARK: - UITextFieldDelegate
extension BorderedTextFieldView: UITextFieldDelegate {
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        if string.isEmpty && range.isDeleting {
            return true
        }
        guard let textfieldText = textField.text, !textfieldText.isEmpty else {
            if string == " " {
                return false
            }
            return true
        }
        if textfieldText.last == " " && string == " " {
            return false
        }
        if let mask = self.inputMask {
            let maskValue = mask.rawValue
            let position = textfieldText.count
            if position < maskValue.count {
                let maskCharacter = maskValue.map({ $0 })[position]
                if maskCharacter == " " {
                    textField.text = textfieldText + " "
                }
            }
        }
        guard let maxLenght = self.maxCharactersCount else {
            return true
        }
        let filetered = textfieldText.replacingOccurrences(of: " ", with: "")
        return filetered.count < maxLenght
    }
    
}
