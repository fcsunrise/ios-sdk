//
//  APIResponseSerializing.swift
//  AtlasSDK
//
//  Created by Yelyzaveta Kartseva on 17.05.2021.
//

import Foundation
import Alamofire
import Marshal

private let emptyDataStatusCodes: Set<Int> = [202, 204, 205]

func APIObjectJSONResponseSerializer<T: Unmarshaling>(type: T.Type, preprocessor: DataPreprocessor) -> DataResponseSerializer {
    return APIObjectResponseSerializer(preprocessor: preprocessor, type: type)
}

func APIObjectResponseSerializer<T: Unmarshaling>(preprocessor: DataPreprocessor, type: T.Type) -> DataResponseSerializer {
    return DataResponseSerializer(dataPreprocessor: preprocessor, emptyResponseCodes: emptyDataStatusCodes)
}
