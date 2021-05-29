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
    let typhoonURL="https://b-alertsline.cdn.hinet.net/Capstorage/CWB/2020/Typhoon_warnings/fifows_typhoon-warning_202011070716.cap"
    func fetchThphoon(){
        performRequest(urlString: typhoonURL)
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
                    self.parseXML(typhoonData: dataString!)
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
//            parseXML(urlString: decodeData.entry.last!.link.href)
        }catch{
            print(error)
        }
    }
    func parseXML(typhoonData:String){
        let xml=SWXMLHash.parse(typhoonData)
        var typhoonArea:[String]=[]
        do{
            let typhoonScale = try xml["alert"]["info"]["description"]["typhoon-info"]["section"][3]["analysis"]["scale"].withAttribute("lang", "zh-TW").element!.text
            let typhoonAlert = try xml["alert"]["info"]["description"]["section"].withAttribute("title", "警戒區域及事項").element!.text
            for elem in xml["alert"]["info"]["area"].all{
                typhoonArea.append(elem["areaDesc"].element!.text)
            }
            print(typhoonScale)
            let typhoonAlertArr = typhoonAlert.components(separatedBy: "。")
            print(typhoonAlertArr[0])
            print(typhoonArea)
        }catch{
            print(error)
        }
    }
}
