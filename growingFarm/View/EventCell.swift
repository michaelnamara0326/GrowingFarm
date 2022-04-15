//
//  EventCell.swift
//  growingFarm
//
//  Created by Michael Namara on 2021/5/31.
//  Copyright © 2021 Michael. All rights reserved.
//

import UIKit
import Firebase
class EventCell: UITableViewCell {
    @IBOutlet weak var EventLabel: UILabel!
    @IBOutlet weak var remainTimeLabel: UILabel!
    func setLabel(index:Int){
        let currentDate = Date()
        let calendar = Calendar.current
        let eventdate=farmer.farmerGameDatas.Event["Event\(index)"]!["timestamp"]! as! Timestamp
        let diffDateComponents = calendar.dateComponents([.day, .hour, .minute, .second], from: currentDate, to: eventdate.dateValue())
        EventLabel.text="\(farmer.farmerGameDatas.Event["Event\(index)"]!["name"]!)-\(farmer.farmerGameDatas.Event["Event\(index)"]!["exp"]!)點"
        remainTimeLabel.text="剩餘時間-\(diffDateComponents.day!)天"
    }
}
