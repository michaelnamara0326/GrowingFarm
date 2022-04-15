//
//  CreditVC.swift
//  growingFarm
//
//  Created by Michael Namara on 2021/6/20.
//  Copyright © 2021 Michael. All rights reserved.
//

import UIKit
import SCLAlertView
class CreditVC: UIViewController {

    @IBOutlet weak var BananaView: UIView!
    @IBOutlet weak var MilkView: UIView!
    @IBOutlet weak var ChiliView: UIView!
    @IBOutlet weak var quantitiyTextField: UITextField!
    @IBOutlet weak var priceLabel: UILabel!
    @IBOutlet weak var totalLabel: UILabel!
    @IBOutlet weak var returnLabel: UILabel!
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    @IBAction func backBtn(_ sender: UIButton) {
    dismiss(animated: true, completion: nil)
    }
    @IBAction func quantityBtn(_ sender: UIButton){
    
    
    }
    
    @IBAction func buyBtn(_ sender: UIButton) {
        _ = SCLAlertView().showInfo("確定購買？", subTitle: "")
    }

}
