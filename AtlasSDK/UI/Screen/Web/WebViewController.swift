//
//  WebViewController.swift
//  AtlasSDK
//
//  Created by Yelyzaveta Kartseva on 19.05.2021.
//

import UIKit
import WebKit

class WebViewController: AtlasBaseViewController {
    
    //MARK: - Defaults
    
    //MARK: - Properties
    
    @IBOutlet weak private var vWeb: WKWebView!
    
    var url: URL?
    
    var paymentID: String?
    
    var externalTransactionID: String?
    
    var service: SDKServices?
        
    //MARK: - Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.configureWebView()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        self.clearData()
        self.clearWebView()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.prepareNavigationBar()
        self.updateWebViewLink()
    }
    
    private func prepareNavigationBar() {
        self.setNavigationBar(isHidden: false)
    }
    
    private func configureWebView() {
        self.vWeb.allowsBackForwardNavigationGestures = true
        self.vWeb.allowsLinkPreview = true
        self.vWeb.uiDelegate = self
        self.vWeb.navigationDelegate = self
    }
    
    private func clearData() {
        self.url = nil
        self.paymentID = nil
        self.externalTransactionID = nil
    }
    
    private func clearWebView() {
        guard let clearURL = URL(string: "about:blank") else {
            return
        }
        let request = URLRequest(url: clearURL)
        self.vWeb.load(request)
    }
    
    private func updateWebViewLink() {
        guard let link = self.url else {
            return
        }
        let request = URLRequest(url: link)
        self.vWeb.load(request)
    }
    
}

//MARK: - WKUIDelegate
extension WebViewController: WKUIDelegate {
    
}

//MARK: - WKNavigationDelegate
extension WebViewController: WKNavigationDelegate {
    
    func webView(_ webView: WKWebView, decidePolicyFor navigationAction: WKNavigationAction, decisionHandler: @escaping (WKNavigationActionPolicy) -> Void) {
        decisionHandler(.allow)
    }
    
}

//MARK: - StoryboardInstantiable
extension WebViewController: StoryboardInstantiable {
    
    static var storyboardName: String {
        return Storyboard.web
    }
}
