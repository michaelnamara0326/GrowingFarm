//
//  ChooseBreedVC.swift
//  growingFarm
//
//  Created by Michael Namara on 2021/5/28.
//  Copyright © 2021 Michael. All rights reserved.
//

import UIKit
import SCLAlertView
class ChooseBreedVC: UIViewController {
    @IBOutlet weak var rice1Button: UIButton!
    @IBOutlet weak var rice2Button: UIButton!
    var pick:Int=1
    var city:String=""
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor=UIColor.black.withAlphaComponent(0.5)
        // Do any additional setup after loading the view.
    }
    @IBAction func breedPressed(_ sender: UIButton) {
        if sender==rice1Button{
            rice1Button.isEnabled=false
            rice2Button.isEnabled=true
            pick=1
        }
        else{
            rice1Button.isEnabled=true
            rice2Button.isEnabled=false
            pick=2
        }
    }
    
    @IBAction func confirmButtonPressed(_ sender: UIButton) {
        let appearance = SCLAlertView.SCLAppearance(showCloseButton: false)
        let alert = SCLAlertView(appearance: appearance)
        if pick==1{
            _ = alert.addButton("重選一次"){
                return
            }
            _ = alert.addButton("確定無誤"){
                FetchData().updateCustomerGameData("breed", "蓬萊")
                FetchData().updateCustomerGameData("city", self.city)
                self.view.removeFromSuperview()
            }
            _ = alert.showWarning("確定以\n目前縣市：\(city)\n品種：蓬萊米\n進行遊玩嗎？", subTitle: "確定後將無法在種植途中更改")
        }
        else{
            _ = alert.addButton("重選一次"){
                return
            }
            _ = alert.addButton("確定無誤"){
                FetchData().updateCustomerGameData("breed", "在來")
                FetchData().updateCustomerGameData("city", self.city)
                self.view.removeFromSuperview()
                
            }
            _ = alert.showWarning("確定以\n目前縣市：\(city)\n品種：在來米\n進行遊玩嗎？", subTitle: "確定後將無法在種植途中更改")
            
        }
    }
}
