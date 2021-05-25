//
//  Alamofire+NetworkClient.swift
//  AtlasSDK
//
//  Created by Yelyzaveta Kartseva on 17.05.2021.
//

import Foundation
import Alamofire
import Marshal

extension Session {
    
    func request<Endpoint: APIEndpoint>(_ baseURL: URL, endpoint: Endpoint) -> DataRequest {
        guard let url = URL(string: endpoint.path, relativeTo: baseURL) else {
            fatalError("Invalid Path Specification")
        }
        let request = self.request(
            url,
            method: endpoint.method,
            parameters: endpoint.parameters,
            encoding: endpoint.encoding,
            headers: endpoint.headers
        )
        return request
    }
    
    @discardableResult
    func requestJSON<Endpoint: APIEndpoint>(_ baseURL: URL, endpoint: Endpoint, completion: @escaping (Endpoint.ResponseType?, Error?) -> Void) -> DataRequest
        where Endpoint.ResponseType: Unmarshaling {
        let handler = APIObjectJSONResponseSerializer(type: Endpoint.ResponseType.self, preprocessor: self)
            return self.request(baseURL, endpoint: endpoint, handler: handler, completion: completion)
    }
    
    func request<Endpoint: APIEndpoint>(_ baseURL: URL,
                                        endpoint: Endpoint,
                                        handler: DataResponseSerializer,
                                        completion: @escaping (Endpoint.ResponseType?, Error?) -> Void) -> DataRequest
        where Endpoint.ResponseType: Unmarshaling {
            let request = self.request(baseURL, endpoint: endpoint)
            request.validate(APIResponseValidator)
            request.response(responseSerializer: handler) { response in
                print("response.request : \(response.request)")
                print("RESPONSE REQUEST AUTH: \(response.request?.headers)")
                var validatedError: APIError?
                if let error = response.error {
                    print("response=\(String(describing: response.response))")
                    validatedError = ErrorValidator(error: error)
                    completion(nil, error)
                } else {
                    SerializerUtils.serialize(type: Endpoint.ResponseType.self, data: response.value, isResponse: true)
                    .then { (result) in
                        completion(result, validatedError)
                    }.catch { (error) in
                        validatedError = ErrorValidator(error: error)
                        completion(nil, validatedError)
                    }
                }
            }
            return request
    }
    
    
    func downloadFileRequest<Endpoint: APIEndpoint>(_ baseURL: URL,
                                                    endpoint: Endpoint,
                                                    completion: @escaping (Data?, Error?) -> Void)  -> DataRequest {
        let request = self.request(baseURL, endpoint: endpoint)
        request.validate(APIResponseValidator)
        request.responseData { response in
            var validatedError: APIError?
            if let error = response.error {
                validatedError = ErrorValidator(error: error)
            }
            if let data = response.value {
                return completion(data, validatedError)
            }
            completion(response.value, validatedError)
        }
        return request
    }
    
}

//MARK: - DataPreprocessor
extension Session: DataPreprocessor {
    
    public func preprocess(_ data: Data) throws -> Data {
        return data
    }
    
}
