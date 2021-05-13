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
    @IBOutlet weak var errorLabel: UILabel!
    @IBOutlet weak var people: UILabel!
    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    let db=Firestore.firestore()
    var People:String?
    var customerEmail:[String] = []
    var farmerEmail:[String]=[]
    //    static var identify:Bool = false
    public override func viewDidLoad() {
        people.text=People
        getCustomerEmail()
        getFarmerEmail()
        self.hideKeyboardWhenTappedAround()
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
                    self.errorLabel.text="Invalid to login\(e)"
                }else{
                    if self.customerEmail.contains(email) && self.People == "民眾登入" {
                        self.performSegue(withIdentifier: "segueCustomer", sender: self)
                    }
                    else if self.farmerEmail.contains(email) && self.People=="農家登入"{
                        self.performSegue(withIdentifier: "segueFarmer", sender: self)
                    }
                    else{
                        self.errorLabel.text="身份錯誤"
                    }
                    
                }
            }
        }
    }
    func getCustomerEmail() {
        db.collection("customer").getDocuments() {  (querySnapshot, err) in
            if let err = err {
                print("Error getting customer email: \(err)")
            } else {
                for document in querySnapshot!.documents {
                    self.customerEmail.append(document.get("email") as! String)
                }
            }
        }
    }
    func getFarmerEmail() {
        db.collection("farmer").getDocuments() {  (querySnapshot, err) in
            if let err = err {
                print("Error getting farmer email: \(err)")
            } else {
                for document in querySnapshot!.documents {
                    self.farmerEmail.append(document.get("email") as! String)
                }
            }
        }
    }
}

