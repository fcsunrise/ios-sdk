//
//  Constants+UI.swift
//  AtlasSDK
//
//  Created by Yelyzaveta Kartseva on 17.05.2021.
//

import Foundation

//MARK: - Screens

enum Storyboard {
    static let main         = "Main"
    static let pay          = "Pay"
    static let web          = "Web"
    static let test         = "Test"
    static let scanner      = "Scanner"
    
}

//MARK: - Input

enum InputType {
    case name
    case numbers
    case month
    case year
    case cvv
}
