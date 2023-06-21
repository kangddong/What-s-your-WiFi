//
//  SSID.swift
//  WiFiQRCodeGenerator
//
//  Created by dongyeongkang on 2023/06/21.
//

import Foundation
import SystemConfiguration.CaptiveNetwork
import NetworkExtension

public class SSID {
    class func fetchNetworkInfo() -> [NetworkInfo]? {
        
        if #available(iOS 14.0, *) {
            var networkInfos = [NetworkInfo]()
            NEHotspotNetwork.fetchCurrent { hotspotNetwork in
                guard let ssid = hotspotNetwork?.ssid,
                      let bssid = hotspotNetwork?.bssid else { return }
                
                var networkInfo = NetworkInfo(success: false,
                                              ssid: nil,
                                              bssid: nil)
                networkInfo.success = true
                networkInfo.ssid = ssid
                networkInfo.bssid = bssid
                print("SSID is: \(ssid)")
                networkInfos.append(networkInfo)
            }
            
            return networkInfos
        } else {
            guard let interfaces: NSArray = CNCopySupportedInterfaces() else { return nil }
            var networkInfos = [NetworkInfo]()
            for interface in interfaces {
                let interfaceName = interface as! String
                var networkInfo = NetworkInfo(success: false,
                                              ssid: nil,
                                              bssid: nil)
                if let dict = CNCopyCurrentNetworkInfo(interfaceName as CFString) as NSDictionary? {
                    networkInfo.success = true
                    networkInfo.ssid = dict[kCNNetworkInfoKeySSID as String] as? String
                    networkInfo.bssid = dict[kCNNetworkInfoKeyBSSID as String] as? String
                }
                networkInfos.append(networkInfo)
            }
            return networkInfos
        }
    }
 }

struct NetworkInfo {
    var success: Bool = false
    var ssid: String?
    var bssid: String?
}
