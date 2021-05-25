//
//  IPAdressHelper.swift
//  AtlasSDK
//
//  Created by Yelyzaveta Kartseva on 17.05.2021.
//

import Foundation

class IPAdressHelper: NSObject {
    
    //MARK: - Defaults
    
    private enum Defaults {
        static let wifiInterfaceName = "en0"
        static let cellurarInterfaceName = "pdp_ip0"
    }
    
    //MARK: - Shared
    
    static var shared = IPAdressHelper()
    
    //MARK: - Lifecycle
    
    func getWiFiAddress() -> String? {
        var address : String?

        var ifaddr : UnsafeMutablePointer<ifaddrs>?
        guard getifaddrs(&ifaddr) == 0 else { return nil }
        guard let firstAddr = ifaddr else { return nil }

        for ifptr in sequence(first: firstAddr, next: { $0.pointee.ifa_next }) {
            let interface = ifptr.pointee

            let addrFamily = interface.ifa_addr.pointee.sa_family
            if addrFamily == UInt8(AF_INET) || addrFamily == UInt8(AF_INET6) {

                let name = String(cString: interface.ifa_name)
                if  name == Defaults.wifiInterfaceName || name == Defaults.cellurarInterfaceName {

                    // Convert interface address to a human readable string:
                    var hostname = [CChar](repeating: 0, count: Int(NI_MAXHOST))
                    getnameinfo(interface.ifa_addr, socklen_t(interface.ifa_addr.pointee.sa_len),
                                &hostname, socklen_t(hostname.count),
                                nil, socklen_t(0), NI_NUMERICHOST)
                    address = String(cString: hostname)
                }
            }
        }
        freeifaddrs(ifaddr)

        return address
    }
}

