//
//  CommodityCell.swift
//  growingFarm
//
//  Created by Michael Namara on 2021/6/5.
//  Copyright © 2021 Michael. All rights reserved.
//

import UIKit

class CommodityCell: UITableViewCell {

    @IBOutlet weak var commdityLabel: UILabel!
    @IBOutlet weak var costLabel: UILabel!
    @IBOutlet weak var farmerNameLabel: UILabel!
    @IBOutlet weak var commdityImage: UIImageView!
    
    func setLabel(index:Int){
        if(index==1){
            commdityLabel.text="農產品折扣金"
            farmerNameLabel.text="XXX農產市集"
            costLabel.text="消耗100"
            commdityImage.image=UIImage(named:"Image 31")
        }
        else if (index==2){
            commdityLabel.text="免費兌換有機蔬菜"
            farmerNameLabel.text="XXX小農"
            costLabel.text="消耗250"
            commdityImage.image=UIImage(named: "Image 32")
        }
        else{
            commdityLabel.text="休閒農場門票乙張"
            farmerNameLabel.text="XXX休閒農場"
            costLabel.text="消耗300"
            commdityImage.image=UIImage(named: "Image 33")
        }
        
    }

}
