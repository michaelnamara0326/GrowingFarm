//
//  ShopCommodityVC.swift
//  growingFarm
//
//  Created by Michael Namara on 2021/6/20.
//  Copyright © 2021 Michael. All rights reserved.
//

import UIKit
import Kingfisher
class ShopCommodityVC: UIViewController {
    var Commodity=""
    @IBOutlet weak var sellerLabel: UILabel!
    @IBOutlet weak var commodityLabel: UILabel!
    @IBOutlet weak var placeLabel: UILabel!
    @IBOutlet weak var deliverLabel: UILabel!
    @IBOutlet weak var costLabel: UILabel!
    @IBOutlet weak var commodityImage: UIImageView!
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    override func viewWillAppear(_ animated: Bool) {
        switch Commodity {
        case "banana":
            commodityImage.image=UIImage(named: "香蕉")
            sellerLabel.text="販賣賣家：測試農場1"
            commodityLabel.text="交易品項：香蕉"
            placeLabel.text="產        地：旗山"
            costLabel.text="售        價：30"
        case "milk":
            commodityImage.image=UIImage(named: "鮮奶")
            sellerLabel.text="販賣賣家：測試農場2"
            commodityLabel.text="交易品項：鮮奶"
            placeLabel.text="產        地：南投"
            costLabel.text="售        價：140"
        case "chili":
            commodityImage.image=UIImage(named: "辣椒")
            sellerLabel.text="販賣賣家：測試農場3"
            commodityLabel.text="交易品項：自製辣椒醬"
            placeLabel.text="產        地：臺北"
            costLabel.text="售        價：300"
        default:
            break
        }
    }
}
