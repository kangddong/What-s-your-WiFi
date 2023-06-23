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

    @IBOutlet weak var shareButton: UIButton!
    @IBOutlet weak var closeButton: UIButton!
    @IBOutlet weak var barcodeImageView: UIImageView!
    
    public var barcodeString: String = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()

        shareButton.addTarget(self, action: #selector(tappedShareButton), for: .touchUpInside)
        closeButton.addTarget(self, action: #selector(tappedCloseButton), for: .touchUpInside)
        barcodeImageView.image = generateQRCode(barcode: barcodeString)
        
    }
}

extension BarcodeViewController {
    
    @objc
    private func tappedShareButton() {
        
        let textToShare = "QR 코드를 공유해서 WiFi 접속을 해보세요 !"
        let imageToShare = barcodeImageView.image

        shareViaAirDrop(text: textToShare, image: imageToShare, url: nil)
    }
    
    @objc
    private func tappedCloseButton() {
        
        self.dismiss(animated: true)
    }
    
    private func generateQRCode(barcode: String) -> UIImage? {
        let data = barcode.data(using: String.Encoding.ascii)
        
        // CICode128BarcodeGenerator
        // CIQRCodeGenerator
        if let filter = CIFilter(name: "CIQRCodeGenerator") {
            filter.setValue(data, forKey: "inputMessage")
            let transform = CGAffineTransform(scaleX: 3, y: 3)
            
            if let output = filter.outputImage?.transformed(by: transform) {
                return UIImage(ciImage: output)
            }
        }
        return nil
    }

    private func shareViaAirDrop(text: String?, image: UIImage?, url: URL?) {
        var itemsToShare: [Any] = []
        
        if let text = text {
            itemsToShare.append(text)
        }
        
        if let image = image {
            itemsToShare.append(image)
        }
        
        if let url = url {
            itemsToShare.append(url)
        }
        
        let activityViewController = UIActivityViewController(activityItems: itemsToShare, applicationActivities: nil)
        
        if UIDevice.current.userInterfaceIdiom == .pad {
            activityViewController.popoverPresentationController?.sourceView = UIApplication.shared.keyWindow?.rootViewController?.view
        } else {
            self.present(activityViewController, animated: true, completion: nil)
        }
    }

}
