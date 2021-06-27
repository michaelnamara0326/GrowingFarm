//
//  CityWeatherData.swift
//  growingFarm
//
//  Created by Michael Namara on 2021/6/22.
//  Copyright © 2021 Michael. All rights reserved.
//

import Foundation

// MARK: - CityAreaData
struct CityWeatherData: Codable {
    let success: String
    let result: Result
    let records: Records
}

// MARK: - Records
struct Records: Codable {
    let location: [Location]
}

// MARK: - Location
struct Location: Codable {
    let lat, lon, locationName, stationID: String
    let time: Time
    let weatherElement: [WeatherElement]
    let parameter: [Parameter]

    enum CodingKeys: String, CodingKey {
        case lat, lon, locationName
        case stationID = "stationId"
        case time, weatherElement, parameter
    }
}

// MARK: - Parameter
struct Parameter: Codable {
    let parameterName, parameterValue: String
}

// MARK: - Time
struct Time: Codable {
    let obsTime: String
}

// MARK: - WeatherElement
struct WeatherElement: Codable {
    let elementName, elementValue: String
}

// MARK: - Result
struct Result: Codable {
    let resourceID: String
    let fields: [Field]

    enum CodingKeys: String, CodingKey {
        case resourceID = "resource_id"
        case fields
    }
}

// MARK: - Field
struct Field: Codable {
    let id, type: String
}
