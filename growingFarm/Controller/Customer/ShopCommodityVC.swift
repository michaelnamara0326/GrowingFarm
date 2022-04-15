//
//  ShopCommodityVC.swift
//  growingFarm
//
//  Created by Michael Namara on 2021/6/20.
//  Copyright © 2021 Michael. All rights reserved.
//

import UIKit
import Kingfisher
import SCLAlertView
class ShopCommodityVC: UIViewController {
    var Commodity=""
    @IBOutlet weak var quantitiyTextField: UITextField!
    @IBOutlet weak var sellerLabel: UILabel!
    @IBOutlet weak var commodityLabel: UILabel!
    @IBOutlet weak var placeLabel: UILabel!
    @IBOutlet weak var deliverLabel: UILabel!
    @IBOutlet weak var priceLabel: UILabel!
    @IBOutlet weak var measureLabel: UILabel!
    @IBOutlet weak var commodityImage: UIImageView!
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    override func viewWillAppear(_ animated: Bool) {
        switch Commodity {
        case "banana":
            commodityImage.image=UIImage(named: "香蕉")
            measureLabel.text="300g/串"
            sellerLabel.text="XX農場1"
            commodityLabel.text="香蕉"
            placeLabel.text="高雄市"
            priceLabel.text="$25"
        case "milk":
            commodityImage.image=UIImage(named: "鮮奶")
            measureLabel.text="936ml/瓶"
            sellerLabel.text="XX農場2"
            commodityLabel.text="鮮奶"
            placeLabel.text="南投縣"
            priceLabel.text="$140"
        case "chili":
            commodityImage.image=UIImage(named: "辣椒")
            measureLabel.text="650g/罐"
            sellerLabel.text="XX農場3"
            commodityLabel.text="自製辣椒醬"
            placeLabel.text="臺北市"
            priceLabel.text="$300"
        default:
            break
        }
    }
    @IBAction func quantityBtn(_ sender: UIButton) {
        if sender.accessibilityIdentifier == "increase"{
            quantitiyTextField.text=String(Int(quantitiyTextField.text!)! + 1)
        }
        else{
            quantitiyTextField.text=String(Int(quantitiyTextField.text!)! - 1)
        }
    }
   
    @IBAction func addToCartBtn(_ sender: UIButton) {
        _ = SCLAlertView().showSuccess("成功加入購物車！", subTitle: "")
    }
}
