//
//  UserInfo.swift
//  growingFarm
//
//  Created by Michael Namara on 2021/5/25.
//  Copyright © 2021 Michael. All rights reserved.
//

import Foundation
import CoreLocation
import Firebase
struct appGlobal{
    static var appglobal:[String:Any]=[:]
    struct appglobals {
        static var customerNum:Int{ return appglobal["customerNum"] as! Int}
        static var farmerNum:Int{ return appglobal["farmerNum"] as! Int}
        static var farmermarketNum:Int{ return appglobal["farmermarketNum"] as! Int}
        static var farmerresturantNum:Int{ return appglobal["farmerresturantNum"] as! Int}
        static var leisurtfarmNum:Int{ return appglobal["leisurefarmNum"] as! Int}
    }
}

struct customer {
    static var customerInfo:[String:Any]=[:]
    static var customerGameData:[String:Any]=[:]
    struct customerInfos{
        static var DocumentId:String{ return customerInfo["DocumentID"] as! String }
        static var No:String{ return customerInfo["No"] as! String }
        static var Email:String{ return customerInfo["email"] as! String}
        static var Identifier:String{ return customerInfo["identifier"] as! String }
        static var IsVerified:Bool{ return customerInfo["isVerified"] as! Bool }
        static var LoginTime:String{ return customerInfo["logintime"] as! String }
        static var Name:String{ return customerInfo["name"] as! String }
        static var Password:String{ return customerInfo["password"] as! String }
        static var Phone:String{ return customerInfo["phone"] as! String }
    }
    struct customerGameDatas{
        static var Coin:Int{ return customerGameData["coin"] as! Int }
        static var Exp:Int{ return customerGameData["exp"] as! Int }
        static var Breed:String{ return customerGameData["breed"] as! String }
        static var Stage:String{ return customerGameData["stage"] as! String }
        static var Location:GeoPoint{ return customerGameData["location"] as! GeoPoint }
        static var WateringTimestamp:Timestamp{ return customerGameData["wateringTimestamp"] as! Timestamp }
        static var LastTimestamp:Timestamp{ return customerGameData["lastTimestamp"] as! Timestamp }
    }
}
struct farmer{
    static var farmerInfo:[String:Any]=[:]
    static var farmerGameData:[String:Any]=[:]
    struct farmerInfos{
        static var DocumentId:String{ return farmerInfo["DocumentID"] as! String }
        static var No:String{ return farmerInfo["No"] as! String }
        static var Email:String{ return farmerInfo["email"] as! String}
        static var Identifier:String{ return farmerInfo["identifier"] as! String }
        static var IsVerified:Bool{ return farmerInfo["isVerified"] as! Bool }
        static var LoginTime:String{ return farmerInfo["logintime"] as! String }
        static var Name:String{ return farmerInfo["name"] as! String }
        static var Password:String{ return farmerInfo["password"] as! String }
        static var Phone:String{ return farmerInfo["phone"] as! String }
    }
    struct farmerGameDatas{
        static var Favoriate:Int{ return farmerGameData["favoriate"] as! Int }
        static var CustomerDone:Int{ return farmerGameData["customerDone"] as! Int}
        static var Event:[String:[String:Any]]{ return farmerGameData["Event"] as! [String:[String:Any]] }
    }
}

