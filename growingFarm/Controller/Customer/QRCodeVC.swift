import UIKit
import MercariQRScanner
import SCLAlertView
import Photos
class QRCodeVC: UIViewController {
    @IBOutlet weak var qrView: UIView!
    let fetchData=FetchData()
    override func viewDidLoad() {
        super.viewDidLoad()
        if AVCaptureDevice.authorizationStatus(for: .video) !=  .authorized {
            // 如果一開始就允許使用相機權限，那麼就建置 QR code 掃瞄器
            AVCaptureDevice.requestAccess(for: AVMediaType.video) { status in
                if status{
                    return
                }
                else{
                    let alertController = UIAlertController(title: "尚未開啟相機權限", message: "請前往設定設置", preferredStyle: .alert)
                    let cancelAction = UIAlertAction(title: "取消", style: .cancel, handler: { _ in self.dismiss(animated: true, completion: nil)})
                    let okAction = UIAlertAction(title: "設定", style: .default, handler: { _ in
                        let url = URL(string: UIApplication.openSettingsURLString)
                        if let url = url, UIApplication.shared.canOpenURL(url) {
                            if #available(iOS 10, *) {
                                UIApplication.shared.open(url, options: [:],completionHandler: {(success) in})
                            } else {
                                UIApplication.shared.openURL(url)
                            }
                        }
                    })
                    alertController.addAction(cancelAction)
                    alertController.addAction(okAction)
                    self.present(alertController, animated: true, completion: nil)
                }
            }
        } else {
            let qrScannerView = QRScannerView(frame: view.bounds)
            qrView.addSubview(qrScannerView)
            qrScannerView.configure(delegate: self)
            qrScannerView.startRunning()
        }
    }
 
    @IBAction func backButtonPressed(_ sender: UIButton) {
        dismiss(animated: true, completion: nil)
    }
}
extension QRCodeVC: QRScannerViewDelegate {
    func qrScannerView(_ qrScannerView: QRScannerView, didFailure error: QRScannerError) {
        print(error)
        qrScannerView.rescan()
    }
    func qrScannerView(_ qrScannerView: QRScannerView, didSuccess code: String) {
        if let url=URL(string: code.urlEncoded()), url.scheme=="growingfarm"{
            print(url.host!)
            print(url.pathComponents)
            fetchData.updateCustomerGameData("exp", customer.customerGameDatas.Exp + Int(url.pathComponents.last!)!)
            dismiss(animated: true) {
                _ = SCLAlertView().showSuccess("\(url.host!)", subTitle: "\(url.pathComponents[1].urlDecoded())，獲得\(url.pathComponents.last!)經驗點數")
            }
        }
        else{
            let appearance = SCLAlertView.SCLAppearance(showCloseButton:false)
            let alert = SCLAlertView(appearance: appearance)
            _ = alert.addButton("重新掃描", action: {
                qrScannerView.rescan()
            })
            _ = alert.showError("非APP專屬QR Code", subTitle: "")
        }
    }
}
extension String {
     
    //將原始的url編碼轉為合法的url
    func urlEncoded() -> String {
        let encodeUrlString = self.addingPercentEncoding(withAllowedCharacters:
            .urlQueryAllowed)
        return encodeUrlString ?? ""
    }
     
    //將編碼後的url轉換回原始的url
    func urlDecoded() -> String {
        return self.removingPercentEncoding ?? ""
    }
}
