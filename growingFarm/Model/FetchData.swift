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
    func getAppGlobal(){
        db.collection("appGlobal").document("appGlobal1").getDocument { snapShot, error in
            if let err=error{
                print(err)
            }
            else{
                appGlobal.appglobal=(snapShot?.data())!
            }
        }
        db.collection("appGlobal").document("CityData").getDocument { snapShot, error in
            if let err=error{
                print(err)
            }
            else{
                appGlobal.cityData=(snapShot?.data())!
            }
        }
    }
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
        db.document("customer/\(customer.customerInfos.DocumentId)/customerGameData/\(customer.customerInfos.DocumentId)GameData").updateData([string:type])
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
            }
        }
    }
    func getFarmInfo(category:String, name:String){
        db.collection(category).whereField("name", isEqualTo: name).getDocuments { querySnapShot, err in
            guard let document = querySnapShot?.documents else{
                print("fetching data error\(err)")
                return
            }
            Farm.FarmInfo=(document.first?.data())!
            Farm.FarmInfo["DocumentID"]=document.first?.documentID
            print(Farm.FarmInfo)
        }
        DispatchQueue.main.asyncAfter(deadline: .now()+1) {
            db.document("\(category)/\(Farm.FarmerInfos.DocumentId)/\(category)GameData/\(Farm.FarmerInfos.DocumentId)GameData").getDocument { snapShot, error in
                if let err=error{
                    print(err)
                }
                else{
                    Farm.FarmGameData=(snapShot?.data())!
                    print(Farm.FarmGameData)
                }
            }
        }
    }
    
}



