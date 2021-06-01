//
//  EventCell.swift
//  growingFarm
//
//  Created by Michael Namara on 2021/5/31.
//  Copyright © 2021 Michael. All rights reserved.
//

import UIKit

class EventCell: UITableViewCell {
    @IBOutlet weak var EventLabel: UILabel!
    func setLabel(index:Int){
            EventLabel.text="\(farmer.farmerGameDatas.Event["Event\(index)"]!["name"]!)-\(farmer.farmerGameDatas.Event["Event\(index)"]!["exp"]!)點"
    }
}
