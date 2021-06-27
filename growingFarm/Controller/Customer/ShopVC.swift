//
//  ShopVC.swift
//  growingFarm
//
//  Created by Michael Namara on 2021/6/5.
//  Copyright © 2021 Michael. All rights reserved.
//

import UIKit

class ShopVC: UIViewController {
    var sendCommodity=""
    override func viewDidLoad() {
        super.viewDidLoad()
    }

    @IBAction func backBtn(_ sender: UIButton) {
        dismiss(animated: true, completion: nil)
    }
    @IBAction func IntroBtn(_ sender: UIButton) {
        if sender.accessibilityIdentifier == "banana"{
            sendCommodity="banana"
        }
        else if sender.accessibilityIdentifier == "milk"{
            sendCommodity="milk"
        }
        else{
            sendCommodity="chili"
        }
        performSegue(withIdentifier: "shopToCommodity", sender: self)
    }
    
    @IBAction func creditBtn(_ sender: UIButton) {
        sender.isEnabled=false
    }
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier=="shopToCommodity"{
            let vc=segue.destination as! ShopCommodityVC
            vc.Commodity=sendCommodity
        }
    }
}
