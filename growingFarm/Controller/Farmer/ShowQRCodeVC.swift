//
//  ShowQRCodeVC.swift
//  growingFarm
//
//  Created by Michael Namara on 2021/5/30.
//  Copyright © 2021 Michael. All rights reserved.
//

import UIKit
import EFQRCode
class ShowQRCodeVC: UIViewController {
    @IBOutlet weak var qrcodeImageView: UIImageView!
    @IBOutlet weak var eventNameLabel: UILabel!
    @IBOutlet weak var eventExpLabel: UILabel!
    var indexPathRow:Int=0
    override func viewDidLoad() {
        super.viewDidLoad()
        let name=farmer.farmerGameDatas.Event["Event\(indexPathRow)"]!["name"]!
        let exp=farmer.farmerGameDatas.Event["Event\(indexPathRow)"]!["exp"]!
        if let image=EFQRCode.generate(for:"growingfarm://\(farmer.farmerInfos.Name)/\(farmer.farmerGameDatas.Event["Event\(indexPathRow)"]!["name"]!)/\(farmer.farmerGameDatas.Event["Event\(indexPathRow)"]!["exp"]!)",size: EFIntSize(width: 300, height: 300),foregroundColor: #colorLiteral(red: 0, green: 0.7770907283, blue: 0.4363682866, alpha: 1), icon: UIImage(named: "logo1")?.cgImage){
            print("create success\(image)")
            let qrCode = UIImage(cgImage: image)
            let qrCodeView = UIImageView(image: qrCode)
            qrcodeImageView.addSubview(qrCodeView)
        }
        
        else{
            print("failed")
        }
        eventNameLabel.text = name as? String
        eventExpLabel.text = String(exp as! Int)
    }
  
   
}
