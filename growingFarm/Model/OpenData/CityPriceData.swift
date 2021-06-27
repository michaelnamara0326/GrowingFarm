//
//  CityPriceData.swift
//  growingFarm
//
//  Created by Michael Namara on 2021/6/6.
//  Copyright © 2021 Michael. All rights reserved.
//


import Foundation

// MARK: - CityAreaDatum
struct CityPriceData: Codable {
    let name, ptDateDay: String
    let pt1Japt, pt1Tsait: Double
    enum CodingKeys: String, CodingKey {
        case name
        case ptDateDay = "pt_date_day"
        case pt1Japt = "pt_1japt"
        case pt1Tsait = "pt_1tsait"
    }
}

