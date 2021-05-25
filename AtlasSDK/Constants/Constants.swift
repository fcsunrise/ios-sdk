//
//  Constants.swift
//  AtlasSDK
//
//  Created by Yelyzaveta Kartseva on 17.05.2021.
//

import UIKit

//MARK: - Other

enum Sides {
    case left
    case right
}

enum Place {
    case front
    case back
}

enum Separator {
    static let zero = "0"
    static let spacer = " "
    static let clear = ""
    static let point = "."
    static let dash = "-"
    static let comma = ","
    static let slash = " / "
    static let star = "*"
}

enum Month: Int, CaseIterable {
    case january
    case february
    case march
    case april
    case may
    case june
    case july
    case august
    case september
    case oktober
    case november
    case december
    
    var monthNumber: String {
        switch self {
        case .january:
            return "01"
        case .february:
            return "02"
        case .march:
            return "03"
        case .april:
            return "04"
        case .may:
            return "05"
        case .june:
            return "06"
        case .july:
            return "07"
        case .august:
            return "08"
        case .september:
            return "09"
        case .oktober:
            return "10"
        case .november:
            return "11"
        case .december:
            return "12"
        }
    }
    
}

// MARK: - Animation

enum AnimationDuration {
    static let `default`: TimeInterval = 0.3
    static let signUpLogoViewElement: TimeInterval = 1.0
    static let signUpAuthElements: TimeInterval = 1.5
}

//MARK: - Images

enum SDKImage {
    static let camera: UIImage? = UIImage(named: "sdk_icon_camera", in: BundleHelper.bundle, with: nil)
    static let dropDown: UIImage? = UIImage(named: "sdk_icon_drop_down", in: BundleHelper.bundle, with: nil)
    static let info: UIImage? = UIImage(named: "sdk_icon_info", in: BundleHelper.bundle, with: nil)
}

//MARK: - Buttons

enum SDKButton {
    case camera
    case dropDown
    case info
    
    var title: String {
        switch self {
        case .camera:
            return SDKButtonDescriptions.camera
        case .dropDown:
            return SDKButtonDescriptions.dropdown
        case .info:
            return SDKButtonDescriptions.info
        }
    }
    
    static func from(string: String) -> SDKButton? {
        switch string {
        case SDKButtonDescriptions.camera       : return .camera
        case SDKButtonDescriptions.dropdown     : return .dropDown
        case SDKButtonDescriptions.info         : return .info
        default:
            return nil
        }
    }
    
}

enum SDKButtonDescriptions {
    static let camera = "camera"
    static let dropdown = "dropDown"
    static let info = "info"
}

//MARK: - Masks

enum Mask: String {
    case card = "xxxx xxxx xxxx xxxx"
}

//MARK: - Locale

public enum Locale: String {
    case ua = "ua"
    case en = "en"
    case ru = "ru"
}

//MARK: - PaymentService

public enum VerificationCode {
    case lookUpCode
    case otp
    
    var title: String {
        switch self {
        case .lookUpCode:
            return "Look up code"
        case .otp:
            return "OTP code"
        }
    }
}

//MARK: - Services

public enum SDKServices {
    case tokenization
    case webAcquiringPayment
    case host2host
}

public enum Services: Int {
    case webAcquiring = 1
    case host2host = 2
    case motoPayment = 4
    case host2hostToken = 8
    case leak3Ds = 9
}
