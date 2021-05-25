//
//  SerializerUtils.swift
//  AtlasSDK
//
//  Created by Yelyzaveta Kartseva on 17.05.2021.
//

import Foundation
import Marshal
import Promise

class SerializerUtils: NSObject {
    
    static func serialize<T: Unmarshaling>(type: T.Type, data: Data?, isResponse: Bool) -> Promise<T?> {
        return Promise { fulfill, reject in
            do {
                guard let validData = data, validData.count > 0 else {
                    return reject(APIError.invalidResponse)
                }
                guard let object = SerializerUtils.prepareData(data: validData, isResponse: true) else {
                    return reject(APIError.invalidResponse)
                }
                let serialized = try type.init(object: object)
                fulfill(serialized)
            } catch {
                print("[SerializerUtils]: serialize<T: Unmarshaling> error: \(error) ")
                return reject(error as NSError)
            }
        }
    }
    
    static private func prepareData(data: Data, isResponse: Bool) -> JSONObject? {
        do {
            let key: String = isResponse ? "response" : "error"
            let jsonObj = try JSONSerialization.jsonObject(with: data, options: [])
            if let jsonSingle = jsonObj as? JSONObject, let json = jsonSingle[key] as? JSONObject {
                return json
            } else if let jsonArray = jsonObj as? [JSONObject] {
                return ["data" : jsonArray]
            }
            return nil
        } catch {
            print("[SerializerUtils]: prepareData error: \(error) ")
            return nil
        }
    }
    
    static func getArrayOf<T: Unmarshaling>(type: T.Type, from object: MarshaledObject, by key: String) -> [T]? {
        var parsed = [T]()
        guard let objects = object.optionalAny(for: key) as? [MarshaledObject] else {
            return nil
        }
        for obj in objects {
            do {
                parsed.append(try type.init(object: obj))
            } catch {
                print("[SerializerUtils]: getArrayOf<T: Unmarshaling> error: \(error) ")
                return nil
            }
        }
        let prepared: [T]? = parsed.isEmpty ? nil : parsed
        return prepared
    }
    
    static func getObjectOf<T: Unmarshaling>(type: T.Type, from object: MarshaledObject, by key: String) -> T? {
        guard let parsedObject = object.optionalAny(for: key) as? MarshaledObject else {
            return nil
        }
        do {
            let parsed = try type.init(object: parsedObject)
            return parsed
        } catch {
            print("[SerializerUtils]: getObjectOf<T: Unmarshaling> error: \(error) ")
            return nil
        }
    }
    
    static func toDictionary(jsonString text: String?) -> [AnyHashable : Any]? {
        guard let input = text else {
            return nil
        }
        if let data = input.data(using: .utf8) {
            do {
                return try JSONSerialization.jsonObject(with: data, options: []) as? [AnyHashable : Any]
            } catch {
                print(error.localizedDescription)
            }
        }
        return nil
    }
    
}
