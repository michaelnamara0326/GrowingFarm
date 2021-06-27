//
//  CityAreaData.swift
//  growingFarm
//
//  Created by Michael Namara on 2021/6/6.
//  Copyright © 2021 Michael. All rights reserved.
//

import Foundation
struct CityAreaData: Codable {
    let year: Int
    let local, cropType, cropItem,gain: String
    let output: String
    
    enum CodingKeys: String, CodingKey {
        case year, local
        case cropType = "crop_type"
        case cropItem = "crop_item"
        case gain, output
    }
    
}
