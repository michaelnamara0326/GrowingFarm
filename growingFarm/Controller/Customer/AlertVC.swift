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
    @IBOutlet weak var priceView: UIView!
    let manager=TyphoonManager()
    override func viewDidLoad() {
        super.viewDidLoad()
        manager.fetchTyphoon()
    }
    override func viewDidAppear(_ animated: Bool) {
        DispatchQueue.main.asyncAfter(deadline: .now()+2) {
            self.updateAlertView()
        }
    }
    
    @IBAction func alertSegementedAction(_ sender: UISegmentedControl) {
        if sender.selectedSegmentIndex==0{
            alertView.isHidden=false
        }
        else{
            alertView.isHidden=true
        }
    }
    func updateAlertView(){
        alertTypeLabel.text="特報類型：\(typhoon.alertType!)"
        alertDescriptionLabel.text="特報敘述：\(typhoon.alertDescription!)"
        alertAreaLabel.text="影響區域：\(typhoon.alertArea)"
    }
    func updatePriceView(){
        return
    }
}
