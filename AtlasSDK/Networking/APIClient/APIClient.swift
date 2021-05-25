//
//  APIClient.swift
//  AtlasSDK
//
//  Created by Yelyzaveta Kartseva on 17.05.2021.
//

import Foundation
import Alamofire
import Marshal

class APIClient {
    
    //MARK: - Defaults
    
    private enum Defaults {
        static let token = "Atlas.APIClient.Defaults.token"
        static let refreshToken = "Atlas.APIClient.Defaults.refreshToken"
    }
    
    // MARK: - Instance
    
    static let shared = APIClient()
    
    // MARK: - Properties
    
    let baseURL: URL = URL(string: APIConstants.apiURL)!
    
    lazy var manager: Session = {
        let session = Session(configuration: sessionConfiguration, interceptor: self, serverTrustManager: ServerTrustManager(evaluators: serverTrustPolicies))
        return session
    }()
    
    // MARK: - Setters
    
    // MARK: - Initialization
    
    init() { }

}

//MARK: - RequestInterceptor
extension APIClient: RequestInterceptor {
    
    public func adapt(_ urlRequest: URLRequest, for session: Session, completion: @escaping (Result<URLRequest, Error>) -> Void) {
        var request = urlRequest
        request.setValue(APIConstants.defaultUserAgent, forHTTPHeaderField: APIHeaders.userAgent.rawValue)
        #warning("Add if auth Bearer needed")
//        if let token = APIClient.shared.token {
//            request.setValue(APISecurityScheme.bearer.rawValue + " \(token)", forHTTPHeaderField: APIHeaders.authorization.rawValue)
//        }
        completion(.success(request))
    }
    
}
