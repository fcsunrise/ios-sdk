//
//  AtlasSDK.swift
//  AtlasSDK
//
//  Created by Yelyzaveta Kartseva on 19.05.2021.
//

import Foundation
import Alamofire
import Marshal
import Promise

public protocol AtlasSDKDelegate: class {
    
    ///sdk did fail for some reason
    func atlasSDKDidFail(with error: APIError, request: RequestType?)
    
    ///sdk did create transaction
    func atlasSDKDidCreateTransaction(with data: CreateTransactionResponseData)
    
    ///sdk did find transaction
    func atlasSDKDidFindTransaction(with data: FindTransactionResponseData)
    
    ///sdk did receive 3ds linl for host-2-host operation
    func atlasSDKDidReceive3DsOnHost2Host(paymentID: String, link: URL)
    
    ///sdk did receive 3ds linl for moto operation
    func atlasSDKDidReceive3DsOnMoto(paymentID: String, link: URL)
    
    ///sdk did complete transaction
    func atlasSDKDidCompleteTransaction(paymentID: String, externalTransactionID: Int?, oltpID: Int?)
    
    ///sdk did receive pay_url for service processing
    func atlasSDKDidReceive(payUrl: URL, paymentID: String, for service: SDKServices)
    
}

extension AtlasSDKDelegate {
    
    func atlasSDKDidReceive3DsOnHost2Host(paymentID: String, link: URL) {}
    
    func atlasSDKDidReceive3DsOnMoto(paymentID: String, link: URL) {}
    
    func atlasSDKDidReceive(payUrl: URL, paymentID: String, for service: SDKServices) {}
    
}

public class AtlasSDK: NSObject, NetworkStateProtocol, TransactionUsecase {
    
    //MARK: - Defaults
    
    //MARK: - TransactionUsecase
    
    lazy var transactionNetworkComponent: TransactionNetworkHandlerComponent = {
        let component = TransactionNetworkHandlerComponent()
        component.delegate = self
        return component
    }()
    
    //MARK: - NetworkStateProtocol
    
    var state: State = .none {
        willSet {
            update(newState: newValue)
        }
    }
    
    func update(newState: State) {
        switch (state, newState) {
        case ( _, .loading):
            break
        case (_, .success):
            break
        case (_, .finish(_)):
            break
        case (_, .failure(let error, let request)):
            self.dismissPaymentNavigationIfNeeded {
                self.delegate?.atlasSDKDidFail(with: error, request: request)
            }
            break
        default:
            break
        }
    }
    
    //MARK: - Shared
    
    public static var shared = AtlasSDK()
    
    //MARK: - Properties
    
    /// localization, availible options ua en ru
    public var locale: Locale = .ua
    
    /// provided by Atlas
    public var pointToken: String? {
        didSet {
            Core.shared.authManager.pointToken = self.pointToken
        }
    }
    
    /// provided by Atlas
    public var pointID: String? {
        didSet {
            Core.shared.authManager.pointID = self.pointID
        }
    }
    
    /// url used for callbacks user after transaction authentication completes
    public var callBackUrl: URL?
    
    /// url used for redirecting user on successful operation
    public var successUrl: URL?
    
    /// url used for redirecting user if operation failed
    public var failureUrl: URL?
    
    /// used for defining should sdk automaticaly show verification controller for card tokenization
    public var shouldShowWebControllerOnCardTokenization: Bool = false
    
    /// used for defining should sdk automaticaly show verification controller for web acquiring
    public var shouldShowWebControllerOnWebAcquiringPayment: Bool = false
    
    /// used for defining should sdk automaticaly show verification controller for host-2host 3ds link
    public var shouldShowWebControllerOnHost2HostPayment: Bool = false
    
    /// navigation used for default controller pushing
    public weak var navigation: UINavigationController?
    
    /// logo image used in host-2-host controller
    public var paymentLogo: UIImage?
    
    /// navigation used for host-2-host controller
    private lazy var paymentControllerNavigation: UINavigationController = {
        let payNavigation = PayViewController.navigationController()!
        payNavigation.showBackButton()
        return payNavigation
    }()
    
    public weak var delegate: AtlasSDKDelegate?
    
    private var isPaymentNavigationPresented: Bool = false
    
    private lazy var webViewController: WebViewController = {
        let controller = WebViewController.storyboardInstance()!
        return controller
    }()
    
    //MARK: - Services
    
    private var tokenizationService: CardTokenizationService!
    
    private var webAcquiringPaymentService: WebAcquiringPaymentService!
    
    private var hostTohostPaymentService: HostToHostService!
    
    //MARK: - Initialization
    
    public override init() {
        super.init()
        self.configureServices()
    }
    
    //MARK: - Card Tokenization
    
    ///provide accound field in fields object
    public func tokenizeCard(serviceID: Int, fields: JSONObject?) {
        let references = self.getReferences()
        self.tokenizationService.tokenizeCard(serviceID: serviceID, fields: fields, references: references, locale: self.locale.rawValue)
    }
    
    //MARK: - Web Acquiring payment
    
    public func webAcquiringPayment(amount: Int, serviceID: Int, account: String) {
        let references = self.getReferences()
        self.webAcquiringPaymentService.pay(amount: amount, serviceID: serviceID, account: account, references: references, locale: self.locale.rawValue)
    }
    
    public func webAcquiringPaymentByTokenizedCard(amount: Int, serviceID: Int, account: String, cardToken: String, cvv: String) {
        let references = self.getReferences()
        self.webAcquiringPaymentService.payByTokenizedCard(amount: amount, serviceID: serviceID, account: account, references: references, locale: self.locale.rawValue, cardToken: cardToken, cvv: cvv)
    }
    
    //MARK: - MOTO payment
    
    /// month format "mm", year format "year"
    public func motoPayment(amount: Int, serviceID: Int, account: String, cardNumber: String, expirationMonth: String, expirationYear: String, cvv: String) {
        let references = self.getReferences()
        self.webAcquiringPaymentService.motoPay(amount: amount, serviceID: serviceID, account: account, references: references, locale: self.locale.rawValue, cardNumber: cardNumber, expirationMonth: expirationMonth, expirationYear: expirationYear, cvv: cvv)
    }
        
    //MARK: - Host-2-Host
    
    /// month format "mm", year format "year"
    public func host2hostPayment(amount: Int, serviceID: Int, account: String, cardNumber: String, expirationMonth: String, expirationYear: String, cvv: String) {
        let references = self.getReferences()
        self.hostTohostPaymentService.pay(amount: amount, account: account, serviceID: serviceID, references: references, locale: self.locale.rawValue, cardNumber: cardNumber, expirationMonth: expirationMonth, expirationYear: expirationYear, cvv: cvv)
    }
    
    public func host2hostTokenizedPayment(amount: Int, serviceID: Int, account: String, cardToken: String, cvv: String) {
        let references = self.getReferences()
        self.hostTohostPaymentService.payByCardToken(amount: amount, serviceID: serviceID, account: account, references: references, locale: self.locale.rawValue, token: cardToken, cvv: cvv)
    }
    
    //MARK: - Payment without 3Ds
    
    /// month format "mm", year format "year"
    public func payWithout3DsVerification(amount: Int, serviceID: Int, account: String, cardNumber: String, expirationMonth: String, expirationYear: String, cvv: String) {
        let references = self.getReferences()
        self.webAcquiringPaymentService.payWithout3Ds(amount: amount, serviceID: serviceID, account: account, references: references, locale: self.locale.rawValue)
        
    }
    
    public func payWithout3DsVerificationByTokenizedCard(amount: Int, serviceID: Int, account: String, cardToken: String, cvv: String) {
        let references = self.getReferences()
        self.webAcquiringPaymentService.payWithout3DsByTokenizedCard(amount: amount, serviceID: serviceID, account: account, references: references, locale: self.locale.rawValue, cardToken: cardToken, cvv: cvv)
    }
    
    //MARK: - Additional
    
    public func findTransaction(paymentID: String?, externalTransactionID: Int?, oltpID: Int?, completion: @escaping(FindTransactionResponseData) -> Void) {
        guard let point = Core.shared.authManager.pointID else {
            return
        }
        self.transactionNetworkComponent.findTransaction(point: point, paymentID: paymentID, externalTransactionID: externalTransactionID?.description, oltpID: oltpID?.description, locale: self.locale.rawValue, completion: completion) 
    }
    
    func verifyTransaction(serviceID: Int, amount: Int, operationType: Int, fields: JSONObject, completion: @escaping(ValidationTransactionResponseData) -> Void) {
        guard let point = self.pointID else {
            return
        }
        let references = self.getReferences()
        self.transactionNetworkComponent.validateTransaction(point: point, serviceID: serviceID, amount: amount, operationType: operationType, fields: fields, references: references, locale: self.locale.rawValue, completion: completion)
    }
    
    //MARK: - Host-2-Host controller
    
    public func presentPaymentController(pointID: String, pointToken: String, account: String, serviceID: Int, amount: Int, controllerTitle: String?, style: UIModalPresentationStyle, completion: @escaping() -> ()) {
        self.pointID = pointID
        self.pointToken = pointToken
        self.paymentControllerNavigation.modalPresentationStyle = style
        self.paymentControllerNavigation.presentationController?.delegate = self
        self.shouldShowWebControllerOnHost2HostPayment = true
        let controller = self.paymentControllerNavigation.rootViewController as! PayViewController
        controller.account = account
        controller.serviceID = serviceID
        controller.amount = amount
        if let title = controllerTitle {
            controller.controllerTitle = title
        }
        self.calculateHost2HostTransactionAmount(account: account, serviceID: serviceID, amount: amount, opertaionType: Services.host2host.rawValue).then { (fullAmount) in
            DispatchQueue.main.async {
                controller.fullAmount = fullAmount
                self.navigation?.present(self.paymentControllerNavigation, animated: true) { [weak self] in
                    self?.isPaymentNavigationPresented = true
                    completion()
                }
            }
        }
        
    }
    
    //MARK: - Private
    
    private func configureServices() {
        self.configureTokenizationService()
        self.configureWebAcquiringPaymentService()
        self.configureHost2HostService()
    }
    
    private func configureTokenizationService() {
        let service = CardTokenizationService(with: self.transactionNetworkComponent)
        service.payURLCallback = { [weak self] (payURL, paymentID) in
            if self?.shouldShowWebControllerOnCardTokenization == true {
                self?.proceedRedirect(url: payURL, paymentID: paymentID, service: .tokenization)
            }
            self?.delegate?.atlasSDKDidReceive(payUrl: payURL, paymentID: paymentID, for: .tokenization)
        }
        service.createTransactionCallback = { [weak self] (response) in
            self?.delegate?.atlasSDKDidCreateTransaction(with: response)
        }
        self.tokenizationService = service
    }
    
    private func configureWebAcquiringPaymentService() {
        let service = WebAcquiringPaymentService(with: self.transactionNetworkComponent)
        service.payURLCallback = { [weak self] (payURL, paymentID) in
            if self?.shouldShowWebControllerOnWebAcquiringPayment == true {
                self?.proceedRedirect(url: payURL, paymentID: paymentID, service: .webAcquiringPayment)
            }
            self?.delegate?.atlasSDKDidReceive(payUrl: payURL, paymentID: paymentID, for: .webAcquiringPayment)
        }
        service.findTransactionCallback = { [weak self] (paymentID, externalTransactionID, oltpID) in
            self?.findTransactionBy(paymentID: paymentID, externalTransactionID: externalTransactionID, oltpID: oltpID)
            self?.delegate?.atlasSDKDidCompleteTransaction(paymentID: paymentID, externalTransactionID: externalTransactionID, oltpID: oltpID)
        }
        service.threeDsCallBack = { [weak self] (link, paymentID) in
            if self?.shouldShowWebControllerOnWebAcquiringPayment == true {
                self?.proceedRedirect(url: link, paymentID: paymentID, service: .webAcquiringPayment)
            }
            self?.delegate?.atlasSDKDidReceive3DsOnMoto(paymentID: paymentID, link: link)
        }
        service.createTransactionCallback = { [weak self] (response) in
            self?.delegate?.atlasSDKDidCreateTransaction(with: response)
        }
        self.webAcquiringPaymentService = service
    }
    
    private func configureHost2HostService() {
        let service = HostToHostService(with: self.transactionNetworkComponent)
        service.createTransactionCallback = { [weak self] (response) in
            self?.delegate?.atlasSDKDidCreateTransaction(with: response)
        }
        service.findTransactionCallback = { [weak self] (paymentID, externalTransactionID, oltpID) in
            self?.dismissPaymentNavigationIfNeeded {
                self?.findTransactionBy(paymentID: paymentID, externalTransactionID: externalTransactionID, oltpID: oltpID)
                self?.delegate?.atlasSDKDidCompleteTransaction(paymentID: paymentID, externalTransactionID: externalTransactionID, oltpID: oltpID)
            }
        }
        service.threeDsCallBack = { [weak self] (link, paymentID) in
            if self?.shouldShowWebControllerOnHost2HostPayment == true {
                self?.proceedRedirect(url: link, paymentID: paymentID, service: .host2host)
            }
            self?.delegate?.atlasSDKDidReceive3DsOnHost2Host(paymentID: paymentID, link: link)
        }
        service.errorCallback = { [weak self] (error) in
            self?.dismissPaymentNavigationIfNeeded {
                self?.delegate?.atlasSDKDidFail(with: error, request: nil)
            }
        }
        self.hostTohostPaymentService = service
    }
    
    private func getReferences() -> References? {
        return References(successURL: self.successUrl, failURL: self.failureUrl, callbackURL: self.callBackUrl)
    }
    
    private func proceedRedirect(url: URL, paymentID: String, service: SDKServices) {
        self.webViewController.url = url
        self.webViewController.paymentID = paymentID
        self.webViewController.service = service
        (self.isPaymentNavigationPresented ? self.paymentControllerNavigation : self.navigation)?.pushViewController(self.webViewController, animated: true)
    }
    
    private func findTransactionBy(paymentID: String?, externalTransactionID: Int?, oltpID: Int?) {
        guard let point = Core.shared.authManager.pointID else {
            return
        }
        self.transactionNetworkComponent.findTransaction(point: point, paymentID: paymentID, externalTransactionID: externalTransactionID?.description, oltpID: oltpID?.description, locale: self.locale.rawValue) { (response) in
            self.delegate?.atlasSDKDidFindTransaction(with: response)
        }
    }
    
    private func calculateHost2HostTransactionAmount(account: String, serviceID: Int, amount: Int, opertaionType: Int) -> Promise<Double?> {
        return Promise { fulfill, reject in
            let fields: JSONObject = [
                APIParameterName.account.rawValue : account
            ]
            self.verifyTransaction(serviceID: serviceID, amount: amount, operationType: opertaionType, fields: fields) { (response) in
                guard let max = response.commision?.max,
                      let min = response.commision?.min,
                      let percentage = response.commision?.percentage else {
                    return fulfill(Double(amount))
                }
                let fixed = response.commision?.fixed ?? 0
                let commision = CommisionHelper.shared.calculateCommision(amount: amount, max: max, min: min, percentage: percentage, fixed: fixed)
                let fullAmount = Double(amount) + commision
                fulfill(fullAmount)
            }
        }
    }
    
    private func dismissPaymentNavigationIfNeeded(completion: @escaping() -> Void) {
        if self.isPaymentNavigationPresented == true {
            self.isPaymentNavigationPresented = false
            DispatchQueue.main.async {
                self.paymentControllerNavigation.popToRootViewController(animated: false)
                self.paymentControllerNavigation.dismiss(animated: true) {
                    completion()
                }
            }
            return
        }
        completion()
    }
    
}

//MARK: - UIAdaptivePresentationControllerDelegate
extension AtlasSDK: UIAdaptivePresentationControllerDelegate {
    
    
    public func presentationControllerDidDismiss(_ presentationController: UIPresentationController) {
        self.isPaymentNavigationPresented = false
    }
}
