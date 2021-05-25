//
//  APIConstants.swift
//  AtlasSDK
//
//  Created by Yelyzaveta Kartseva on 17.05.2021.
//

import Foundation

enum APIConstants {
    
    static let reachabilityManagerHost = "google.com"
    
    static let apiURL = "https://json-m.fcsunrise.com/"
    static let defaultUserAgent = "app/ios"
}

enum APIContentType: String {
    case applicationJSON = "application/json"
    case applicationPDF = "application/pdf"
    case applicationFormURLEncoded = "application/x-www-form-urlencoded"
}

enum APISecurityScheme: String {
    case bearer = "Bearer"
    case basic  = "Basic"
}

enum APIHeaders: String {
    case userAgent      = "User-Agent"
    case contentType    = "Content-Type"
    case authorization  = "Authorization"
}

enum APIParameterName: String {
    case code = "error_code"
    case title
    case message = "message_error"
    case success
    case error
    
    case auth
    case locale
    case serviceID = "service_id"
    case hash
    case point
    case amount
    case fields
    case account
    case externalCommission = "external_commission"
    case externalTransactionID = "external_transaction_id"
    case receipEmail = "receipt_email"
    case payed
    case acquirerService = "acquirer_service"
    case acquirerCommission = "acquirer_commission"
    case source
    case device
    case os
    case userAgent = "ua"
    case operationType = "operation_type"
    case ref
    case successUrl = "success_url"
    case failUrl = "fail_url"
    case callbackUrl = "callback_url"
    case acquiring
    case service
    case commission
    case bankTerminal = "bank_terminal"
    case serviceName = "service_name"
    case serviceComment = "service_comment"
    case paymentDirection = "payment_direction"
    case freeProps = "free_props"
    case name
    case slug
    case value
    case isInvoice = "is_invoice"
    case acquiringLogs = "acquiring_logs"
    case status
    case result
    case paymentId = "payment_id"
    case oltpID = "oltp_id"
    case pointID = "point_id"
    case receiptNumber = "receipt_number"
    case isTest = "is_test"
    case statusDescription = "status_description"
    case created = "created_at"
    case confirmed = "confirmed_at"
    case receiptURL = "receipt_url"
    case registrationID = "registration_id"
    case additional
    case acquiringErrors = "acquiring_errors"
    case payURL = "pay_url"
    case cardNumber = "card_number"
    case cardToken = "card_token"
    case expirationDate = "expiry_date"
    case cvv
    case threeDs = "3dsUrl"
    case additionalFix = "additional_fix_value"
    case maxSum = "max_sum"
    case minSum = "min_sum"
    case sum
    case maxAmount = "max_amount"
    case messageText = "message"
    case validationInfo = "validation_info"
    
}

enum APIPath {
    static let transactionValidate = "/transaction/validate"
    static let transactionCreate = "/transaction/create"
    static let transactionFind = "/transaction/find"
}

public enum RequestType {
    // ALL
    case allRequests
    
    case validateTransaction
    case createTransaction
    case findTransaction
}
