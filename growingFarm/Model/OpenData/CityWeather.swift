//
//  CityWeather.swift
//  growingFarm
//
//  Created by Michael Namara on 2021/6/22.
//  Copyright © 2021 Michael. All rights reserved.
//

import Foundation
struct CityWeather{
    let url="https://opendata.cwb.gov.tw/api/v1/rest/datastore/O-A0003-001?Authorization=CWB-840B31C2-151F-4CC1-94E3-AB46A3AF1EB1&locationName=%E8%87%BA%E5%8C%97&elementName=TEMP,Weather&parameterName=CITY"
    func fetchWeather(){
        performRequest(urlString: url)
    }
    func performRequest(urlString:String){
        if let url=URL(string: urlString){
            let session = URLSession(configuration: .default)
            let task=session.dataTask(with: url) { data, URLResponse, error in
                if error != nil{
                    print(error)
                }
                if let safeData=data{
//                    let dataString=String(data: safeData, encoding: .utf8)
                    self.parseJSON(farmerData: safeData)
//                    print(dataString)
                }
            }
            task.resume()
        }
    }
    func parseJSON(farmerData:Data){
        let decoder=JSONDecoder()
        decoder.dateDecodingStrategy = .iso8601
        do{
            let decodeData=try decoder.decode(CityWeatherData.self, from: farmerData)
            K.GameData.weather.temp = decodeData.records.location.first?.weatherElement[0].elementValue ?? "none"
            K.GameData.weather.weather = decodeData.records.location.first?.weatherElement[1].elementValue ?? "none"
//            print(Int(Double(K.GameData.weather.temp)!))
//            print(K.GameData.weather.weather)
            
        }catch{
            print(error)
        }
    }
}
