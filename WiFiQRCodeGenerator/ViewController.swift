//
//  ViewController.swift
//  WiFiQRCodeGenerator
//
//  Created by 강동영 on 2023/06/20.
//
/*
 
 SK_WiFiGIGAE908_2.4G
 WPA
 AYX29@0651
 */

import UIKit
import SystemConfiguration.CaptiveNetwork
import NetworkExtension
import CoreLocation

class ViewController: UIViewController {

    @IBOutlet weak var wifiNameTextfield: UITextField!
    @IBOutlet weak var wifiEncryptTypeTextfield: UITextField!
    @IBOutlet weak var wifiPWTextfield: UITextField!
    @IBOutlet weak var qrGenerateButton: UIButton!
    
    var locationManager = CLLocationManager()
    
    var currentNetworkInfos: Array<NetworkInfo>? {
        get {
            return SSID.fetchNetworkInfo()
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        wifiNameTextfield.text = "Maru360_Guest"
        wifiEncryptTypeTextfield.text = "WPA"
        wifiPWTextfield.text = "moveforward"
        qrGenerateButton.addTarget(self, action: #selector(tappedGeneratedButton), for: .touchUpInside)
        
        
        let status = CLLocationManager.authorizationStatus()
        if status == .authorizedWhenInUse {
            if let wifiSSID = getWiFiSSID() {
                print("Wi - Fi SSID: \(wifiSSID)")
            } else {
                print("Not connected to Wi - Fi")
            }
        } else {
            locationManager.delegate = self
            locationManager.requestWhenInUseAuthorization()
        }
    }
}

extension ViewController {
    
    @objc
    private func tappedGeneratedButton() {
        
        guard validateTextField() else { return }
        let barcodeString = getWiFiURLString()
        
        guard let vc = self.storyboard?.instantiateViewController(withIdentifier: "BarcodeViewController") as? BarcodeViewController else { return }
        
        vc.barcodeString = barcodeString
        vc.modalPresentationStyle = .fullScreen
        self.present(vc, animated: true)
    }
    
    private func validateTextField() -> Bool {
        guard wifiNameTextfield.text?.count != 0 else {
            // TODO: Toast
            print("wifiNameTextfield.text?.count == 0")
            return false
        }
        
        guard wifiEncryptTypeTextfield.text?.count != 0 else {
            // TODO: Toast
            print("wifiEncryptTypeTextfield.text?.count == 0")
            return false
        }
        
        guard wifiPWTextfield.text?.count != 0 else {
            // TODO: Toast
            print("wifiPWTextfield.text?.count == 0")
            return false
        }
        
        return true
    }
    
    private func getWiFiURLString() -> String {
        
        let ssid = wifiNameTextfield.text!
        let type = wifiEncryptTypeTextfield.text!
        let password = wifiPWTextfield.text!
        let hidden = ""
        
        return "WIFI:S:\(ssid);T:\(type);P:\(password);H:\(hidden);;"
    }
    
    private func getWiFiSSID() -> String? {
        var ssidString: String?
        
        if #available(iOS 14.0, *) {
            NEHotspotNetwork.fetchCurrent { hotspotNetwork in
                guard let ssid = hotspotNetwork?.ssid else { return }
                
                ssidString = ssid
                print("SSID is: \(ssid)")
                print("isSecure: \(hotspotNetwork?.isSecure)")
//                print("securityType: \(hotspotNetwork?.securityType)")
            }
        } else {
            updateWiFi()
        }

        return ssidString
    }
    
    private func updateWiFi() {
        print("SSID: \(currentNetworkInfos?.first?.ssid ?? "")")
        if let ssid = currentNetworkInfos?.first?.ssid {
            print("SSID: \(ssid)")
        }
        
        if let bssid = currentNetworkInfos?.first?.bssid {
            print("BSSID: \(bssid)")
        }
    }
}

// MARK: CLLocationManagerDelegate Method
extension ViewController: CLLocationManagerDelegate {
    
    func locationManagerDidChangeAuthorization(_ manager: CLLocationManager) {
        let status = CLLocationManager.authorizationStatus()
        if status == .authorizedWhenInUse {
            updateWiFi()
        }
    }
}
