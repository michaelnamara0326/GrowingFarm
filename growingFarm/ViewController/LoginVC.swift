//
//  LoginVC.swift
//  growingFarm
//
//  Created by Michael on 2021/5/10.
//  Copyright © 2021 Michael. All rights reserved.
//

import Foundation
import UIKit
import Firebase

class LoginVC: UIViewController{
    @IBOutlet weak var people: UILabel!
    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    let db=Firestore.firestore()
    var People:String?
    var customerEmail:[String] = []
//    static var identify:Bool = false
    public override func viewDidLoad() {
        if let People=People{
            people.text=People
        }
        getCustomerEmail()
        
    }

    @IBAction func segueToRegister(_ sender: UIButton) {
        performSegue(withIdentifier: "segueRegister", sender: sender)
    }
    @IBAction func backtoMain(_ sender: UIButton) {
        self.performSegue(withIdentifier: "logintomain", sender: self)
    }
    @IBAction func loginPressed(_ sender: UIButton) {
        if let email=emailTextField.text, let password=passwordTextField.text{
            Auth.auth().signIn(withEmail: email, password: password) { authResult, error in
                if let e=error{
                    print(e)
                }else{

                    if self.customerEmail.contains(email){
                        self.performSegue(withIdentifier: "segueCustomer", sender: self)
                    }
                    else{
                        self.performSegue(withIdentifier: "segueFarmer", sender: self)
                    }
                }
            }
        }
    }
    func getCustomerEmail() {
        db.collection("customer").getDocuments() {  (querySnapshot, err) in
            if let err = err {
                print("Error getting documents: \(err)")
            } else {
                for document in querySnapshot!.documents {
                    self.customerEmail.append(document.get("email") as! String)
                }
            }
        }
//    db.collection("customer").whereField("email", isEqualTo: "test@1.com")
//            .addSnapshotListener { querySnapshot, error in
//                guard let documents = querySnapshot?.documents else {
//                    print("Error fetching documents: \(error!)")
//                    return
//                }
//                variable.identify=true
//            }
//            print(variable.identify)
        }
            
    
//    func isFarmer(_ email:String) -> Bool{
//        db.collection("farmer").whereField("email", isEqualTo: email).getDocuments() { (querySnapshot, err) in
//            if let err = err {
//                print("Error getting documents: \(err)")
//            } else {
//                for document in querySnapshot!.documents {
//                    print("=> \(document.data()["identity"]!)")
//                }
//            }
//        }
//        return true
//    }
}

