//
//  leisure.swift
//  growingFarm
//
//  Created by Michael Namara on 2021/6/1.
//  Copyright © 2021 Michael. All rights reserved.
//

import Foundation
import Firebase

struct LeisureFarm{
    let url="https://data.coa.gov.tw/Service/OpenData/ODwsv/ODwsvAttractions.aspx?$filter=City+like+"
    
    let db=Firestore.firestore()
    func fetchFarm(){
        let cityURL="\(url)新北市".urlEncoded()
        performRequest(urlString: cityURL)
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
        var count=appGlobal.appglobals.leisurtfarmNum
        let decoder=JSONDecoder()
        decoder.dateDecodingStrategy = .iso8601
        do{
            let decodeData=try decoder.decode([LeisureFarmData].self, from: farmerData)
//            print(decodeData.count)
            for i in 0..<decodeData.count{
                db.document("leisurefarm/leisurefarm\(count)").setData(["No":count,"name":decodeData[i].name,"address":decodeData[i].address,"phone":decodeData[i].tel,"photo":decodeData[i].photo,"intro":decodeData[i].introduction,"isVerified":true])
                count += 1
            }
            db.document("appGlobal/appGlobal1").updateData(["leisurefarmNum":count])
        }catch{
            print(error)
        }
    }
}

