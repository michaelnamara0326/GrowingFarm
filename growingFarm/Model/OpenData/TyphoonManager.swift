//
//  TyphoonManager.swift
//  growingFarm
//
//  Created by Michael Namara on 2021/5/27.
//  Copyright © 2021 Michael. All rights reserved.
//
import Foundation
import SWXMLHash
struct TyphoonManager{
    let alertURL="https://alerts.ncdr.nat.gov.tw/JSONAtomFeed.ashx?AlertType=5"
    let demoURL="https://b-alertsline.cdn.hinet.net/Capstorage/CWB/2020/Typhoon_warnings/fifows_typhoon-warning_202011061917.cap"
    func fetchTyphoon(){
        performRequest(urlString: demoURL)
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
                typhoon.alertType = try xml["alert"]["info"]["description"]["typhoon-info"]["section"][3]["analysis"]["scale"].withAttribute("lang", "zh-TW").element!.text
                typhoon.alertDescription = try xml["alert"]["info"]["description"]["section"].withAttribute("title", "豪雨特報").element!.text
                for elem in xml["alert"]["info"]["area"].all{
                    guard elem["areaDesc"].element!.text.count == 3 else { continue }
                    typhoonArea.append(elem["areaDesc"].element!.text)
                }
//                print(typhoonScale)
//                let typhoonAlertArr = typhoonAlert.components(separatedBy: "。")
//                print(typhoonAlertArr[0])
                typhoon.alertArea=typhoonArea
                print(typhoon.alertType!)
                print(typhoon.alertDescription!)
                print(typhoon.alertArea)
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
