//
//  BaseNetworkHandler.swift
//  AtlasSDK
//
//  Created by Yelyzaveta Kartseva on 17.05.2021.
//

import Alamofire
import Foundation

class BaseNetworkHandler: NetworkHandlingProtocol {
    
    weak var delegate: NetworkStateProtocol?
    
    var poolRequests: [(type: RequestType, request: DataRequest)] = []
    
    var currentRequests: [RequestType: DataRequest?] = [:]
    
    lazy var rechabilityManager: RechabilityManager = {
        let rechabilityManager = RechabilityManager()
        rechabilityManager.connectionLost = { [weak self] in
            self?.suspendRequestsOnConnectionLost()
        }
        rechabilityManager.connectionRestore = { [weak self] in
            self?.resumeRequestsOnConnectionRestore()
        }
        return rechabilityManager
    }()
    
    func startRequest(with request: DataRequest, type: RequestType) {
        delegate?.state = .loading(true, type)
        DispatchQueue.global(qos: .background).sync {
            currentRequests[type]??.cancel()
            currentRequests[type] = request
            if rechabilityManager.isConnected() {
                request.resume()
            } else {
                delegate?.state = .failure(APIError.noInternet, type)
            }
        }
    }
    
    func finishRequest(type: RequestType) {
        DispatchQueue.global(qos: .background).sync {
            if let request = currentRequests[type] {
                if request?.task?.state == .running {
                    request?.cancel()
                }
                currentRequests.removeValue(forKey: type)
                self.startRequestFromPoolIfNeed(by: type)
            }
            delegate?.state = currentRequests.count > 0 ? .loading(true, type) : .finish(true, type)
        }
    }
    
    func startSingleRequest(with request: DataRequest, type: RequestType) {
        if self.currentRequests[type] != nil { return }
        print("startSingleRequest = \(type)")
        self.startRequest(with: request, type: type)
    }
    
    func startRequest(with request: DataRequest, type: RequestType, needPoolUse: Bool) {
        if !needPoolUse {
            self.startRequest(with: request, type: type)
            return
        }
        if self.currentRequests[type] != nil {
            self.poolRequests.append((type: type, request: request))
            return
        }
        self.startRequest(with: request, type: type)
    }
    
    func startRequest(with request: DataRequest, type: RequestType, needBlockUserInteraction: Bool) {
        if self.currentRequests[type] != nil {
            return
        }
        delegate?.state = .loading(needBlockUserInteraction, type)
        self.currentRequests[type] = request
        guard self.rechabilityManager.isConnected() else {
            delegate?.state = .failure(APIError.noInternet, type)
            return
        }
        request.resume()
    }
    
    func finishRequest(type: RequestType, isDataChanged: Bool) {
        if let request = currentRequests[type] {
            if request?.task?.state == .running {
                request?.cancel()
            }
            currentRequests.removeValue(forKey: type)
        }
        delegate?.state = .finish(isDataChanged, type)
    }
    
    func cancelAllRequests() {
        for request in currentRequests.values {
            request?.cancel()
        }
        currentRequests.removeAll()
        delegate?.state = .finish(true, .allRequests)
    }
    
    // MARK: - Rechability
    
    private func resumeRequestsOnConnectionRestore() {
        currentRequests.values.forEach { (request) in
            request?.resume()
        }
    }
    
    private func suspendRequestsOnConnectionLost() {
        currentRequests.values.forEach { (request) in
            request?.suspend()
        }
    }
    
    //MARK: - Helpers
    
    func startRequestFromPoolIfNeed(by type: RequestType) {
        guard let indexOfObject = self.poolRequests.firstIndex(where: { $0.type == type }) else { return }
        let dataRequest = self.poolRequests[indexOfObject]
        self.startRequest(with: dataRequest.request, type: dataRequest.type)
        self.poolRequests.remove(at: indexOfObject)
    }
    
}
