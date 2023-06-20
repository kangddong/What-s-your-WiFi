//
//  BarcodeViewController.swift
//  WiFiQRCodeGenerator
//
//  Created by 강동영 on 2023/06/20.
//

import UIKit
import CoreImage
import CoreImage.CIFilterBuiltins

class BarcodeViewController: UIViewController {

    @IBOutlet weak var closeButton: UIButton!
    @IBOutlet weak var barcodeImageView: UIImageView!
    public var barcodeString: String = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()

        closeButton.addTarget(self, action: #selector(tappedCloseButton), for: .touchUpInside)
        barcodeImageView.image = generateQRCode(barcode: barcodeString)
        
    }
}

extension BarcodeViewController {
    
    @objc
    private func tappedCloseButton() {
        
        self.dismiss(animated: true)
    }
    
    private func generateQRCode(barcode: String) -> UIImage? {
        let data = barcode.data(using: String.Encoding.ascii)
        
        // CICode128BarcodeGenerator
        //CIQRCodeGenerator
        if let filter = CIFilter(name: "CIQRCodeGenerator") {
            filter.setValue(data, forKey: "inputMessage")
            let transform = CGAffineTransform(scaleX: 3, y: 3)
            
            if let output = filter.outputImage?.transformed(by: transform) {
                return UIImage(ciImage: output)
            }
        }
        return nil
    }
}
