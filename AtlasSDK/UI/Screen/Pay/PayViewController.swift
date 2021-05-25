//
//  PayViewController.swift
//  AtlasSDK
//
//  Created by Yelyzaveta Kartseva on 24.05.2021.
//

import Foundation
import UIKit

public class PayViewController: AtlasBaseViewController {
    
    //MARK: - Defaults
    
    //MARK: - Properties
    
    @IBOutlet weak private var tvPay: UITableView!
    
    @IBOutlet weak private var vActivityIndicator: UIActivityIndicatorView!
    
    public var controllerTitle: String = "Оплата"

    var fullAmount: Double? {
        didSet {
            self.uiViewModel.set(fullAmount: self.fullAmount)
        }
    }
    
    var amount: Int?
    
    var account: String?
    
    var serviceID: Int?
    
    private var isPayButtonEnabled: Bool = false
    
    private var isScnnerWillBePresented: Bool = false
        
    var fields: HostToHostFields? {
        return self.uiViewModel.getCardFields()
    }
    
    lazy var uiViewModel: AtlasPayViewModel = {
        let model = AtlasPayViewModel()
        return model
    }()
    
    //MARK: - Lifecycle
    
    public override func viewDidLoad() {
        super.viewDidLoad()
        self.addShadowView()
        self.registerCells()
        self.prepareSDK()
        self.updateUI()
    }
    
    public override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.isScnnerWillBePresented = false
        self.prepareNavigationBar()
        self.reloadTableView()
    }
    
    public override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        self.tvPay.isUserInteractionEnabled = true
        if !self.isScnnerWillBePresented {
            self.prepareForDismiss()
        }
        self.stopLoading()
    }
    
    private func updateUI() {
        self.vActivityIndicator.clipsToBounds = true
        self.vActivityIndicator.layer.cornerRadius = 8
    }
    
    private func prepareForDismiss() {
        self.uiViewModel.set(cvv: nil)
        self.uiViewModel.set(number: nil)
        self.uiViewModel.set(expirationMonth: nil)
        self.uiViewModel.set(expirationYear: nil)
    }
    
    private func prepareSDK() {
        AtlasSDK.shared.shouldShowWebControllerOnHost2HostPayment = true
    }
    
    private func prepareNavigationBar() {
        self.setNavigationBar(isHidden: false)
        self.navigationController?.navigationBar.barTintColor = UIColor.white
        self.navigationController?.navigationBar.titleTextAttributes = [
            .foregroundColor    : UIColor.black,
            .font               : UIFont.systemFont(ofSize: 20, weight: .medium)
        ]
        self.add(title: self.controllerTitle)
    }
    
    func addShadowView() {
        guard let frame = self.navigationController?.navigationBar.frame  else {
            return
        }
        let shadowView = UIView(frame: frame)
        shadowView.backgroundColor = .white
        shadowView.layer.masksToBounds = false
        shadowView.layer.shadowOpacity = 0.25
        shadowView.layer.shadowOffset = CGSize(width: 0, height: 4)
        shadowView.layer.shadowRadius =  20
        self.view.addSubview(shadowView)
    }
    
    func startLoading() {
        self.vActivityIndicator.startAnimating()
    }
    
    func stopLoading() {
        self.vActivityIndicator.stopAnimating()
    }
    
    func pay() {
        if self.vActivityIndicator.isAnimating {
            return
        }
        guard let fields = self.fields,
              let amount = self.amount,
              let account = self.account,
              let serviceID = self.serviceID,
              let month = self.uiViewModel.getCardExpirationMonth(),
              let year = self.uiViewModel.getCardExpirationYear()
              else {
            return
        }
        self.startLoading()
        self.tvPay.isUserInteractionEnabled = false
        AtlasSDK.shared.host2hostPayment(amount: amount, serviceID: serviceID, account: account, cardNumber: fields.cardNumber, expirationMonth: month, expirationYear: year, cvv: fields.cvv)
    }
    
    func setPayButton(enabled: Bool) {
        self.isPayButtonEnabled = enabled
    }
    
    func reloadPayButtonIfNeeded() {
        let shouldEnablePayButton = self.uiViewModel.getCardFields() != nil
        if shouldEnablePayButton != self.isPayButtonEnabled {
            self.reloadActionButtonSection()
        }
    }
    
    //MARK: - UITableView
    
    private func registerCells() {
        self.tvPay.register(cells: [
            AtlasPayCompaniesTableViewCell.self,
            AtlasPayCardDatesTableViewCell.self,
            AtlasPayGeneralTitleTableViewCell.self,
            AtlasPayCardNumberTableViewCell.self,
            AtlasPayCardCVVTableViewCell.self,
            AtlasPayGeneralSumTableViewCell.self,
            AtlasPayActionButtonTableViewCell.self,
            AtlasPayLogoTableViewCell.self
        ])
    }
    
    private func reloadActionButtonSection() {
        let section = AtlasPayViewModel.Section.actionButtons.rawValue
        DispatchQueue.main.async {
            self.tvPay.reloadSections(IndexSet([section]), with: .automatic)
            self.tvPay.layoutIfNeeded()
        }
    }
    
    func reloadTableView() {
        DispatchQueue.main.async {
            self.tvPay.reloadData()
            self.tvPay.layoutIfNeeded()
        }
    }
    
    //MARK: - Screens
    
    func pushScannerScreen() {
        self.isScnnerWillBePresented = true
        let controller = AtlasCardScannerViewController.storyboardInstance()!
        controller.delegate = self
        self.navigationController?.pushViewController(controller, animated: true)
    }
    
    //MARK: - Handlers
    
}

//MARK: - StoryboardInstantiable
extension PayViewController: StoryboardInstantiable {
    
    static var storyboardName: String {
        return Storyboard.pay
    }
    
}

//MARK: - AtlasCardScannerViewControllerDelegate
extension PayViewController: AtlasCardScannerViewControllerDelegate {
    
    func didFindCardNumber(cardNumber: String) {
        self.uiViewModel.set(number: cardNumber)
        self.reloadTableView()
    }
    
}
