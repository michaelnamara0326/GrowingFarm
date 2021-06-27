//
//  FarmerIntroVC.swift
//  growingFarm
//
//  Created by Michael Namara on 2021/5/23.
//  Copyright © 2021 Michael. All rights reserved.
//

import Foundation
import UIKit
import MapKit
import Kingfisher
class FarmerIntroVC:UIViewController{
    @IBOutlet weak var farmerImageView: UIImageView!
    @IBOutlet weak var farmerName: UILabel!
    @IBOutlet weak var farmerOpenTime: UILabel!
    @IBOutlet weak var farmerAddress: UILabel!
    @IBOutlet weak var farmerIntro: UILabel!
    @IBOutlet weak var farmerEvent1: UILabel!
    @IBOutlet weak var farmerEvent2: UILabel!
    @IBOutlet weak var farmerEvent3: UILabel!
    var route:[MKMapItem]?
    override func viewWillAppear(_ animated: Bool) {
        farmerName.text="名稱：\(Farm.FarmerInfos.name)"
        farmerAddress.text="地址：\(Farm.FarmerInfos.address)"
        if let url = Farm.FarmerInfos.photo {
            farmerImageView.kf.setImage(with: URL(string: url.urlEncoded()))
        }
        if Farm.FarmerInfos.intro != "" {
            farmerIntro.text=Farm.FarmerInfos.intro
        }
        if Farm.FarmerInfos.openTime != "" {
            farmerOpenTime.text=Farm.FarmerInfos.openTime!.contains("營業")
            ?"\(Farm.FarmerInfos.openTime!)":"營業時間：\(Farm.FarmerInfos.openTime!)"
        }
        DispatchQueue.main.asyncAfter(deadline: .now()+0.5) {
            self.farmerEvent1.text="-\(Farm.FarmerGameDatas.Event["Event1"]!["name"]!)，\(Farm.FarmerGameDatas.Event["Event1"]!["exp"]!)點"
            self.farmerEvent2.text="-\(Farm.FarmerGameDatas.Event["Event2"]!["name"]!)，\(Farm.FarmerGameDatas.Event["Event2"]!["exp"]!)點"
            self.farmerEvent3.text="-\(Farm.FarmerGameDatas.Event["Event3"]!["name"]!)，\(Farm.FarmerGameDatas.Event["Event3"]!["exp"]!)點"
        }

    }
    @IBAction func goPressed(_ sender: UIButton) {
        navigateToMap()
    }
    
    func navigateToMap(){
        MKMapItem.openMaps(with: route!, launchOptions: [MKLaunchOptionsDirectionsModeKey:MKLaunchOptionsDirectionsModeDriving])
    }
}
