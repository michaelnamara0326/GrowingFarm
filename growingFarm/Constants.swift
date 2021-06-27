//
//  Constants.swift
//  growingFarm
//
//  Created by Michael on 2021/5/12.
//  Copyright © 2021 Michael. All rights reserved.
//

import Foundation

struct K{
    struct GameData{
        static let cityArr=["新北市","台北市","桃園市","台中市","台南市","高雄市","宜蘭縣","新竹縣","苗栗縣","彰化縣","南投縣","雲林縣","嘉義縣","屏東縣","台東縣","花蓮縣","基隆市","新竹市","嘉義市"]
        static let BreedArr=["蓬萊","在來"]
        struct city {
            static var cityPrice:[String:[String:Double]]=[:]
            static var cityArea:[String:Int]=[:]
        }
        struct breed1{
            static let stageExp:[String:Int]=["1":100,"2":300,"3":500]
            static let autoExp:[String:Int]=["1":2,"2":5,"3":7]
            static let wateringExp:[String:Int]=["1":5,"2":10,"3":15]
        }
        struct breed2 {
            static let stageExp:[String:Int]=["1":150,"2":350,"3":550]
            static let autoExp:[String:Int]=["1":2,"2":5,"3":7]
            static let wateringExp:[String:Int]=["1":5,"2":10,"3":15]
        }
        struct weather {
            static var temp=String()
            static var weather=String()
        }
    }
}
