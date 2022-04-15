//
//  AlertVC.swift
//  growingFarm
//
//  Created by Michael Namara on 2021/5/31.
//  Copyright © 2021 Michael. All rights reserved.
//

import UIKit

class AlertVC: UIViewController {
    @IBOutlet weak var alertTypeLabel: UILabel!
    @IBOutlet weak var alertDescriptionLabel:UILabel!
    @IBOutlet weak var alertAreaLabel:UILabel!
    @IBOutlet weak var alertNoneLabel:UILabel!
    @IBOutlet weak var alertView: UIView!
    override func viewDidLoad() {
        super.viewDidLoad()
        updateAlertView()
    }
    @IBAction func backBtn(_ sender: UIButton) {
        dismiss(animated: true, completion: nil)
    }
    func updateAlertView(){
        var cityStr=""
        alertTypeLabel.text="特報類型：\(typhoon.alertType!)"
        alertDescriptionLabel.text="特報敘述：\(typhoon.alertDescription!)"
        for city in typhoon.alertArea{
            if cityStr.contains(city){
                cityStr+=""
            }
            else{
                cityStr+="\(city)、"
            }
        }
        alertAreaLabel.text="影響區域：\(cityStr.trimmingCharacters(in: .punctuationCharacters))"
    }
    func updatePriceView(){
        return
    }
}

