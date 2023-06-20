//
//  ViewController.swift
//  WiFiQRCodeGenerator
//
//  Created by 강동영 on 2023/06/20.
//

import UIKit

class ViewController: UIViewController {

    @IBOutlet weak var wifiNameTextfield: UITextField!
    @IBOutlet weak var wifiEncryptTypeTextfield: UITextField!
    @IBOutlet weak var wifiPWTextfield: UITextField!
    @IBOutlet weak var qrGenerateButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        wifiNameTextfield.text = "SK_WiFiGIGAE908_2.4G"
        wifiEncryptTypeTextfield.text = "WPA"
        wifiPWTextfield.text = "AYX29@0651"
        qrGenerateButton.addTarget(self, action: #selector(tappedGeneratedButton), for: .touchUpInside)
    }


}

extension ViewController {
    
    @objc
    private func tappedGeneratedButton() {
        
        guard wifiNameTextfield.text?.count != 0 else {
            // TODO: Toast
            print("wifiNameTextfield.text?.count == 0")
            return
        }
        
        guard wifiEncryptTypeTextfield.text?.count != 0 else {
            // TODO: Toast
            print("wifiEncryptTypeTextfield.text?.count == 0")
            return
        }
        
        guard wifiPWTextfield.text?.count != 0 else {
            // TODO: Toast
            print("wifiPWTextfield.text?.count == 0")
            return
        }
        
        let ssid = wifiNameTextfield.text!
        let type = wifiEncryptTypeTextfield.text!
        let password = wifiPWTextfield.text!
        
        let barcodeString = "WIFI:S:\(ssid);T:\(type);P:\(password)"
        guard let vc = self.storyboard?.instantiateViewController(withIdentifier: "BarcodeViewController") as? BarcodeViewController else { return }
        
        vc.barcodeString = barcodeString
        vc.modalPresentationStyle = .fullScreen
        self.present(vc, animated: true)
    }
    /*
     
     SK_WiFiGIGAE908_2.4G
     WPA
     AYX29@0651
     */
    
    
}
