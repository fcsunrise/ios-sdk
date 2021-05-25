//
//  APIError.swift
//  AtlasSDK
//
//  Created by Yelyzaveta Kartseva on 17.05.2021.
//

import Foundation
import Alamofire

public enum APIError: Error {
    case noInternet
    case invalidResponse
    case cancelledRequest
    case objectNotFound(errorDescription: APIErrorDescription?)
    
    //atlas
    case server(errorDescription: APIErrorDescription?)
    
    case success
    case unknown(description: String?)
    case inner(description: String?)
    case badRequest(description: String?)
    case systemAPI(description: String?)
    case invalidAuth(description: String?)
    case serverError(description: String?)
    case transaction(description: String?)
    case transactionValidation(description: String?)
    case leakOfFields(description: String?)
    case uncorrectTransactionStatus(description: String?)
    case transactionHasToWaitForPaymentStatus(description: String?)
    case transactionIsProcessing(description: String?)
    case invalidCardData(description: String?)
    case acquiringServiceForbiddenForTransaction(description: String?)
    case acquiringByCardUnsuccessful(description: String?)
    case innerServerError(description: String?)
    case systemErrorServiceDisabled(description: String?)
}

enum APIErrorCode: Int {
    case success = 0
    case unknown = 100
    case inner = 101
    case badRequest = 102
    case systemAPI = 103
    case invalidAuth = 104
    case server = 105
    case transaction = 150
    case transactionValidation = 151
    case leakOfFields = 900
    case uncorrectTransactionStatus = 901
    case transactionHasToWaitForPaymentStatus = 902
    case transactionIsProcessing = 903
    case invalidCardData = 904
    case acquiringServiceForbiddenForTransaction = 905
    case acquiringByCardUnsuccessful = 950
    case innerServerError = 998
    case systemErrorServiceDisabled = 999
}

func ErrorValidator(error: Error) -> APIError {
    if error is APIError {
        return error as! APIError
    }
    if error.errorCode == NSURLErrorNotConnectedToInternet {
        return APIError.noInternet
    }
    if error.errorCode == NSURLErrorCancelled {
        return APIError.cancelledRequest
    }
    if let afError = error as? AFError,
       let apiError = afError.underlyingError as? APIError {
        return apiError
    }
    return APIError.server(errorDescription: nil)
}

extension APIError: LocalizedError {
    
    public var errorDescription: String? {
        switch self {
        case .cancelledRequest:
            return "Cancelled request"
        case .noInternet:
            return "No internet connection"
        case .objectNotFound(let errorDescription):
            return errorDescription?.text ?? "Object has been deleted"
        case .server(let errorDescription):
            return errorDescription?.text ?? "Server error"
        case .unknown(let description):
            return description ?? "Неизвестная ошибка"
        case .inner(let description):
            return description ?? "Внутренняя ошибка"
        case .badRequest(let description):
            return description ?? "Неверный запрос (переданы не все обязательные поля)"
        case .systemAPI(let description):
            return description ?? "Ошибка системного API (валидация не прошла, нет доступа к сервисам и т.д.)"
        case .invalidAuth(let description):
            return description ?? "Авторизация не прошла (auth.hash не совпал)"
        case .serverError(let description):
            return description ?? "Ошибка сервера (системная ошибка)"
        case .transaction(let description):
            return description ?? "Ошибка создания транзакции (Напр. транзакция с таким внешним идентификатором уже существует)"
        case .transactionValidation(let description):
            return description ?? "Ошибка валидации транзакции (Передан неверный аккаунт)"
        case .leakOfFields(let description):
            return description ?? "Переданы не все обязательные поля"
        case .uncorrectTransactionStatus(let description):
            return description ?? "Некорректный статус транзакции"
        case .transactionHasToWaitForPaymentStatus(let description):
            return description ?? "Транзакция должна находиться в статусе ожидания оплаты"
        case .transactionIsProcessing(let description):
            return description ?? "Транзакция находится в обработке"
        case .invalidCardData(let description):
            return description ?? "Некорректные данные карты. Подробности в описании"
        case .acquiringServiceForbiddenForTransaction(let description):
            return description ?? "Для данной транзакции метод API эквайринга запрещен"
        case .acquiringByCardUnsuccessful(let description):
            return description ?? "Эквайринг по карте неуспешен. Подробности в описании ошибки (retry)"
        case .innerServerError(let description):
            return description ?? "Внутренняя ошибка сервера (подробности в описании)"
        case .systemErrorServiceDisabled(let description):
            return description ?? "Системная ошибка. Сервис не доступен"
        default:
            return "Server error"
        }
    }
    
    public var code: Int? {
        switch self {
        case .success:
            return APIErrorCode.success.rawValue
        case .unknown:
            return APIErrorCode.unknown.rawValue
        case .inner:
            return APIErrorCode.inner.rawValue
        case .badRequest:
            return APIErrorCode.badRequest.rawValue
        case .systemAPI:
            return APIErrorCode.systemAPI.rawValue
        case .invalidAuth:
            return APIErrorCode.invalidAuth.rawValue
        case .serverError:
            return APIErrorCode.server.rawValue
        case .transaction:
            return APIErrorCode.transaction.rawValue
        case .transactionValidation:
            return APIErrorCode.transactionValidation.rawValue
        case .leakOfFields:
            return APIErrorCode.leakOfFields.rawValue
        case .uncorrectTransactionStatus:
            return APIErrorCode.uncorrectTransactionStatus.rawValue
        case .transactionHasToWaitForPaymentStatus:
            return APIErrorCode.transactionHasToWaitForPaymentStatus.rawValue
        case .transactionIsProcessing:
            return APIErrorCode.transactionIsProcessing.rawValue
        case .invalidCardData:
            return APIErrorCode.invalidCardData.rawValue
        case .acquiringServiceForbiddenForTransaction:
            return APIErrorCode.acquiringServiceForbiddenForTransaction.rawValue
        case .acquiringByCardUnsuccessful:
            return APIErrorCode.acquiringByCardUnsuccessful.rawValue
        case .innerServerError:
            return APIErrorCode.innerServerError.rawValue
        case .systemErrorServiceDisabled:
            return APIErrorCode.systemErrorServiceDisabled.rawValue
        default:
            return nil
        }
    }
    
    static func from(code: Int, description: String?) -> APIError? {
        guard let errorCode = APIErrorCode(rawValue: code) else {
            return .server(errorDescription: nil)
        }
        switch errorCode {
        case .success:
            return .success
        case .unknown:
            return .unknown(description: description)
        case .inner:
            return .inner(description: description)
        case .badRequest:
            return .badRequest(description: description)
        case .systemAPI:
            return .systemAPI(description: description)
        case .invalidAuth:
            return .invalidAuth(description: description)
        case .server:
            return .serverError(description: description)
        case .transaction:
            return .transaction(description: description)
        case .transactionValidation:
            return .transactionValidation(description: description)
        case .leakOfFields:
            return .leakOfFields(description: description)
        case .uncorrectTransactionStatus:
            return .uncorrectTransactionStatus(description: description)
        case .transactionHasToWaitForPaymentStatus:
            return .transactionHasToWaitForPaymentStatus(description: description)
        case .transactionIsProcessing:
            return .transactionIsProcessing(description: description)
        case .invalidCardData:
            return .invalidCardData(description: description)
        case .acquiringServiceForbiddenForTransaction:
            return .acquiringServiceForbiddenForTransaction(description: description)
        case .acquiringByCardUnsuccessful:
            return .acquiringByCardUnsuccessful(description: description)
        case .innerServerError:
            return .innerServerError(description: description)
        case .systemErrorServiceDisabled:
            return .systemErrorServiceDisabled(description: description)
        }
    }
}
