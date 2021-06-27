//
//  CityArea.swift
//  growingFarm
//
//  Created by Michael Namara on 2021/6/6.
//  Copyright © 2021 Michael. All rights reserved.
//

import Foundation
import Firebase
struct cityArea{
    let db=Firestore.firestore()
    let url="https://data.coa.gov.tw/Service/OpenData/TransService.aspx?UnitId=i5AdyGE26hcq&year=2018"
    let url1="https://data.coa.gov.tw/Service/OpenData/TransService.aspx?UnitId=i5AdyGE26hcq&crop_item=%E8%93%AC%E8%90%8A&year=2018"
    func fetchArea(){
//        for city in K.GameData.cityArr{
//            let cityURL="\(url)&local=\(city)&crop_item=蓬萊".urlEncoded()
//            performRequest(urlString: cityURL)
//        }
        performRequest(urlString: url1)
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
                }
            }
            task.resume()
        }
    }
    func parseJSON(farmerData:Data){
        let decoder=JSONDecoder()
        decoder.dateDecodingStrategy = .iso8601
        do{
            let decodeData=try decoder.decode([CityAreaData].self, from: farmerData)
            //            print(decodeData.count)
//            switch Double(decodeData.first!.output){
//                case 0...3942:
//                    K.GameData.city.cityArea[decodeData.first!.local]=15
//                case 3943...32264:
//                    K.GameData.city.cityArea[decodeData.first!.local]=18
//                case 32265...74441:
//                    K.GameData.city.cityArea[decodeData.first!.local]=21
//                case 74442...191239:
//                    K.GameData.city.cityArea[decodeData.first!.local]=24
//                default:
//                    break
//            }
            for data in decodeData{
                switch Int(Double(data.output)!) {
                case 0...3942:
                    db.document("appGlobal/CityData").setData(["area":[data.local:15]], merge: true)
                case 3943...32264:
                    db.document("appGlobal/CityData").setData(["area":[data.local:18]], merge: true)
                case 32265...74441:
                    db.document("appGlobal/CityData").setData(["area":[data.local:21]], merge: true)
                case 74442...191239:
                    db.document("appGlobal/CityData").setData(["area":[data.local:24]], merge: true)
                default:
                    break
                }
            }
        }catch{
            print(error)
        }
    }
}
