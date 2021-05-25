//
//  BaseService.swift
//  AtlasSDK
//
//  Created by Yelyzaveta Kartseva on 19.05.2021.
//

import Foundation
import Alamofire
import Marshal
import Promise

class BaseService: NSObject {
    
    //MARK: - Lifecycle
    
    func proceedWith(payURL: URL?, paymentID: String, callback: ((_ payURL: URL, _ paymentID: String) ->())?) {
        guard let payURL = payURL else {
            return
        }
        callback?(payURL, paymentID)
    }
    
    func proceedWith(link: URL?, parameters: JSONObject?) -> Promise<[AnyHashable : Any]> {
        return Promise { fulfill, reject in
            guard let link = link else {
                return
            }
            AF.request(link, method: .post,  parameters: parameters, encoding: URLEncoding.httpBody).responseString { (response) in
                switch response.result {
                
                case .success(let jsonString):
                    print("[BaseService] proceedWith response JSONString: \(jsonString)")
                    let json = SerializerUtils.toDictionary(jsonString: jsonString)
                    if let error = self.extractError(from: json) {
                        return reject(error)
                    }
                    fulfill(json ?? [:])
                case .failure(let error):
                    reject(error)
                }
            }
        }
    }
    
    private func extractError(from json: [AnyHashable : Any]?) -> APIError? {
        guard let json = json else {
            return nil
        }
        guard let code = json[APIParameterName.code.rawValue] as? Int else {
            return nil
        }
        if code == APIErrorCode.success.rawValue {
            return nil
        }
        do {
            let description = try APIErrorDescription(object: json)
            let apiError = APIError.from(code: code, description: description.text ?? description.title)
            return apiError
        } catch {
            return nil
        }
    }
    
}
