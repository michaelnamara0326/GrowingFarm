//
//  UserData.swift
//  growingFarm
//
//  Created by Michael on 2021/5/20.
//  Copyright © 2021 Michael. All rights reserved.
//

import Foundation
import Firebase
import CoreLocation

struct FetchData {
    let db=Firestore.firestore()
    func getCustomerInfo(){
        db.collection("customer").whereField("email", isEqualTo: "customertest@1.com").addSnapshotListener { querySnapShot, error in
            guard let document = querySnapShot?.documents else{
                print("fetching data error\(error)")
                return
            }
            customer.customerInfo=(document.first?.data())!
            customer.customerInfo["DocumentID"]=document.first!.documentID
        }
    }
    func getCustomerGameData(){
        db.document("customer/customer1/customerGameData/customer1GameData").addSnapshotListener { snapShot, error in
            if let err=error{
                print(err)
            }
            else{
                customer.customerGameData=(snapShot?.data())!
            }
        }
    }
    func updateCustomerGameData(_ string:String, _ type:Any){
        db.document("customer/customer1/customerGameData/customer1GameData").updateData([string:type])
    }
    func getFarmerInfo(){
        db.collection("farmer").whereField("email", isEqualTo: "farmertest@1.com").addSnapshotListener { querySnapShot, error in
            guard let document = querySnapShot?.documents else{
                print("fetching data error\(error)")
                return
            }
            farmer.farmerInfo=(document.first?.data())!
            farmer.farmerInfo["DocumentID"]=document.first!.documentID
            print(farmer.farmerInfo)
        }
    }
    func getFarmerGameData(){
        db.document("farmer/farmer1/farmerGameData/farmer1GameData").addSnapshotListener { snapShot, error in
            if let err=error{
                print(err)
            }
            else{
                farmer.farmerGameData=(snapShot?.data())!
//                print(farmer.farmerGameData)
//                print(farmer.farmerGameDatas.Event["Event1"]!["exp"]!)
            }
        }
    }
}



