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
struct customer {
    static var customerInfo:[String:Any]=[:]
    static var customerGameData:[String:Any]=[:]
    struct customerInfos{
        static var DocumentId:String{
            get{return customerInfo["DocumentID"] as! String}
        }
        static var No:String{
            get{ return customerInfo["No"] as! String}
        }
        static var Email:String{
            get{return customerInfo["email"] as! String}
        }
        static var Identifier:String{
            get{return customerInfo["identifier"] as! String}
        }
        static var IsVerified:Bool{
            get{return customerInfo["isVerified"] as! Bool}
        }
        static var LoginTime:String{
            get{return customerInfo["logintime"] as! String}
        }
        static var Name:String{
            get{return customerInfo["name"] as! String}
        }
        static var Password:String{
            get{return customerInfo["password"] as! String}
        }
        static var Phone:String{
            get{return customerInfo["phone"] as! String}
        }
    }
    struct customerGameDatas{
        static var Coin:Int{
            get{return customerGameData["coin"] as! Int}
        }
        static var Exp:Int{
            get{return customerGameData["exp"] as! Int}
        }
        static var Stage:String{
            get{return customerGameData["stage"] as! String}
        }
        static var Location:GeoPoint{
            get{return customerGameData["location"] as! GeoPoint}
        }
        static var TimeStamp:Timestamp{
            get{return customerGameData["timestamp"] as! Timestamp}
        }
    }
}
struct farmer{
    static var farmerInfo:[String:Any]=[:]
    static var farmerGameData:[String:Any]=[:]
    struct farmerInfos{
        
    }
    struct farmerGameDatas{
        
    }
}

