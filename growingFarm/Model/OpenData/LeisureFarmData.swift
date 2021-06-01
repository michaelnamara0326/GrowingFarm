//
//  leisureData.swift
//  growingFarm
//
//  Created by Michael Namara on 2021/6/2.
//  Copyright © 2021 Michael. All rights reserved.
//

import Foundation


struct LeisureFarmData: Codable {
    let name, tel, introduction, trafficGuidelines: String
    let address, openHours, city, town: String
    let coordinate: String
    let photo: String
    
    enum CodingKeys: String, CodingKey {
        case name = "Name"
        case tel = "Tel"
        case introduction = "Introduction"
        case trafficGuidelines = "TrafficGuidelines"
        case address = "Address"
        case openHours = "OpenHours"
        case city = "City"
        case town = "Town"
        case coordinate = "Coordinate"
        case photo = "Photo"
    }
}

