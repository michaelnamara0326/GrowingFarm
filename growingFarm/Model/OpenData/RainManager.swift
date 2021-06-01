//
//  TyphoonManager.swift
//  growingFarm
//
//  Created by Michael Namara on 2021/5/27.
//  Copyright © 2021 Michael. All rights reserved.
//
import Foundation
import SWXMLHash
struct RainManager{
    let rainURL="https://alerts.ncdr.nat.gov.tw/JSONAtomFeed.ashx?AlertType=10"
    func fetchThphoon(){
        performRequest(urlString: rainURL)
    }
    func performRequest(urlString:String){
        if let url=URL(string: urlString){
            let session = URLSession(configuration: .default)
            let task=session.dataTask(with: url) { data, URLResponse, error in
                if error != nil{
                    print(error)
                }
                if let safeData=data{
                    let dataString=String(data: safeData, encoding: .utf8)
//                    print(dataString)
//                    self.parseJSON(typhoonData: safeData)
                    if(url.lastPathComponent.components(separatedBy: ".")[1] == "cap"){
                        self.parseXML(typhoonData: dataString!)
                    }
                    else{
                        self.parseJSON(typhoonData: safeData)
                    }
                }
            }
            task.resume()
        }
    }
    func parseJSON(typhoonData:Data){
        let decoder=JSONDecoder()
        decoder.dateDecodingStrategy = .iso8601
        do{
            let decodeData=try decoder.decode(TyphoonData.self, from: typhoonData)
//            print(decodeData.updated)
            performRequest(urlString: (decodeData.entry.last?.link.href)!)
        }catch{
            print(error)
        }
    }
    func parseXML(typhoonData:String){
        let xml=SWXMLHash.parse(typhoonData)
        var typhoonArea:[String]=[]
        do{
            switch xml["alert"]["info"]["headline"].element!.text {
            case "海上陸上颱風警報":
                let typhoonScale = try xml["alert"]["info"]["description"]["typhoon-info"]["section"][3]["analysis"]["scale"].withAttribute("lang", "zh-TW").element!.text
                let typhoonAlert = try xml["alert"]["info"]["description"]["section"].withAttribute("title", "警戒區域及事項").element!.text
                for elem in xml["alert"]["info"]["area"].all{
                    typhoonArea.append(elem["areaDesc"].element!.text)
                }
                print(typhoonScale)
                let typhoonAlertArr = typhoonAlert.components(separatedBy: "。")
                print(typhoonAlertArr[0])
                print(typhoonArea)
            case "海上颱風警報":
                print("海上颱風警報")
            case "解除颱風警報":
                print("解除颱風警報")
            default:
                return
            }
        }catch{
            print(error)
        }
    }
}
