//
//  TestVC.swift
//  growingFarm
//
//  Created by Michael Namara on 2021/5/27.
//  Copyright © 2021 Michael. All rights reserved.
//

import Foundation
import UIKit
import EFQRCode
class TestVC:UIViewController{
    let typhoonManager=TyphoonManager()
    let fetchData=FetchData()
    @IBOutlet weak var testview: UIImageView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        fetchData.getFarmerInfo()
        fetchData.getFarmerGameData()
    }
    override func viewDidAppear(_ animated: Bool) {
        //GF://farmerName/EventName/EventExp
//        if let image=EFQRCode.generate(for:"GF://\(farmer.farmerInfos.Name)/\(farmer.farmerGameDatas.Event["Event1"]!["name"]!)/\(farmer.farmerGameDatas.Event["Event1"]!["exp"]!)",size: EFIntSize(width: 300, height: 300)){
//            print("create success\(image)")
//             let qrCode = UIImage(cgImage: image)
//             let qrCodeView = UIImageView(image: qrCode)
//            testview.addSubview(qrCodeView)
//        }
//        else{
//            print("failed")
//        }
        
    }
    @IBAction func pressed(_ sender: UIButton) {
//        typhoonManager.fetchThphoon()
//        print("GF://\(farmer.farmerInfos.Name)/\(farmer.farmerGameDatas.Event["Event1"]!["name"]!)/\(farmer.farmerGameDatas.Event["Event1"]!["exp"]!)")
        if let image=EFQRCode.generate(for:"GF://\(farmer.farmerInfos.Name)/\(farmer.farmerGameDatas.Event["Event1"]!["name"]!)/\(farmer.farmerGameDatas.Event["Event1"]!["exp"]!)",size: EFIntSize(width: 300, height: 300)){
            print("create success\(image)")
             let qrCode = UIImage(cgImage: image)
             let qrCodeView = UIImageView(image: qrCode)
            testview.addSubview(qrCodeView)
        }
        else{
            print("failed")
        }
    }
    @IBAction func showButtonPressed(_ sender: UIButton) {
//        let subview=ChooseBreedView(frame: CGRect(x: 0, y: 0, width: 337, height: 229))
//        view.addSubview(subview)
        let popOverVC=UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "chooseBreed") as! ChooseBreedVC
        self.addChild(popOverVC)
        popOverVC.view.frame=self.view.frame
        self.view.addSubview(popOverVC.view)
        popOverVC.didMove(toParent: self)
    }
    
}
