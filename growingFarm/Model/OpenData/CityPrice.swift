//
//  CityPrice.swift
//  growingFarm
//
//  Created by Michael Namara on 2021/6/6.
//  Copyright © 2021 Michael. All rights reserved.
//

import Foundation
import Firebase
class cityPrice{
    let db=Firestore.firestore()
    let now = Date()
    var calendar = Calendar.current
    let url="https://data.coa.gov.tw/Service/OpenData/FromM/RicepriceData.aspx?$top=1000&$skip=0"
    var cnt=1
    func fetchPrice(){
        let date=calendar.dateComponents([.year,.month,.day], from: now)
        let currentDateString="\(date.year!-1911).\(date.month!).\(date.day!)"
        for city in K.GameData.cityArr{
            let cityURL="\(url)&CityName=\(city)&StartDate=\(currentDateString)".urlEncoded()
            performRequest(urlString: cityURL)
        }
        print(K.GameData.city.cityPrice)
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
                    self.parseJSON(farmerData: safeData,cityURL: urlString)
                }
            }
            task.resume()
        }
    }
    func parseJSON(farmerData:Data,cityURL:String){
        let decoder=JSONDecoder()
        decoder.dateDecodingStrategy = .iso8601
        let date=calendar.dateComponents([.year,.month,.day], from: now)
//        let currentDateString="\(date.year!-1911).\(date.month!).\(date.day!-1)"
        
        do{
            let decodeData=try decoder.decode([CityPriceData].self, from: farmerData)
            if decodeData.isEmpty==true || decodeData.last!.pt1Japt==0.0{
                performRequest(urlString: cityURL.replacingOccurrences(of: "\(cityURL.split(separator: "=").last!)", with: "\(date.year!-1911).\(date.month!).\(date.day!-cnt)"))
                cnt+=1
            }
            else{
//                print(decodeData.last!.name, decodeData.last!.pt1Japt, decodeData.last!.pt1Tsait)
//                K.GameData.city.cityPrice["\(decodeData.last!.name.trimmingCharacters(in: .whitespaces))"]=["蓬萊":decodeData.last!.pt1Japt,"在來":decodeData.last!.pt1Tsait]
                db.document("appGlobal/CityData").setData(["price":[decodeData.last!.name.trimmingCharacters(in: .whitespaces):["蓬萊":decodeData.last!.pt1Japt,"在來":decodeData.last!.pt1Tsait]]],merge: true)
            }

        }
        catch{
            print(error)
        }
    }
}
