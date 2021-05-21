//
//  FarmerController.swift
//  growingFarm
//
//  Created by Michael on 2021/5/11.
//  Copyright © 2021 Michael. All rights reserved.
//
//get farmer name, address
import Foundation
import UIKit
import Firebase
class FarmerVC:UIViewController{
    var farmerEmail:String=""
    var farmerInfo:[String:String] = [:]
    let db=Firestore.firestore()
    override func viewDidLoad() {
        getFarmerInfo()
//        print(farmerEmail)
    }
    override func viewDidAppear(_ animated: Bool) {
        print(farmerInfo)
        
    }
    @IBAction func signoutButton(_ sender: UIButton) {
        let firebaseAuth = Auth.auth()
        do {
            try firebaseAuth.signOut()
        } catch let signOutError as NSError {
            print ("Error signing out: %@", signOutError)
        }
//        let map=MapVC()
//        map.farmerAddressAnnoation(farmerInfo["Address"]!,farmerInfo["Name"]!)
//        performSegue(withIdentifier: "farmerToMain", sender: self)
    }
    func getFarmerInfo(){
        db.collection("farmer").whereField("email", isEqualTo: farmerEmail).getDocuments { querySnapshot, err in
            if let err=err{
                print(err)
            }
            else{
                for document in querySnapshot!.documents{
                    self.farmerInfo["Name"]=document.get("name") as! String
                    self.farmerInfo["Address"]=document.get("address") as! String
                }
            }
        }
   
    }
    
    
}
