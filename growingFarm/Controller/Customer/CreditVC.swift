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

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    @IBAction func backBtn(_ sender: UIButton) {
    dismiss(animated: true, completion: nil)
    }
    
    @IBAction func buyBtn(_ sender: UIButton) {
        _ = SCLAlertView().showInfo("確定購買？", subTitle: "")
    }
    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
