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
public class LoginVC: UIViewController{
    @IBOutlet weak var people: UILabel!
    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    let db=Firestore.firestore()
    var People:String?
    public override func viewDidLoad() {
        people.text=People!
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
                    if self.isCustomer(email){
                        //                    self.performSegue(withIdentifier: "segueCustomer", sender: self)
                    }
                    else{
                        //                    self.performSegue(withIdentifier: "segueFarmer", sender: self)
                    }
                    
                }

                
                

                
            }
        }
        }
    func isCustomer(_ email: String) -> Bool{
        db.collection("customer").getDocuments { snapshot, error in
            if let err = error {
                print("Error getting documents: \(err)")
            }
            else {
                for document in snapshot!.documents {
                    let customerNum=document.get("customerNum") as! Int
                    print(customerNum)
                }
            }
        }
        return true
    }
}

