//
//  RegisterVC.swift
//  growingFarm
//
//  Created by Michael on 2021/5/10.
//  Copyright © 2021 Michael. All rights reserved.
//

import Foundation
import UIKit
import Firebase

class RegisterVC:UIViewController{
    @IBOutlet weak var nameTextField: UITextField!
    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var phoneTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    @IBOutlet weak var confirmPasswordTextField: UITextField!
    var customerCnt :Int = 0
    let db=Firestore.firestore()
    override func viewDidLoad() {
        super.viewDidLoad()
        self.hideKeyboardWhenTappedAround()
        db.collection("appGlobal").getDocuments { snapshot, error in
            if let err = error {
                       print("Error getting documents: \(err)")
                   }
            else {
                for document in snapshot!.documents {
                    self.customerCnt=document.get("customerNum") as! Int
//                          let latMax = document.get("latMax") as! String
//                          let latMin = document.get("latMin") as! String
//                          let lonMax = document.get("lonMax") as! String
//                          let lonMin = document.get("lonMin") as! String
                    print(self.customerCnt)
                }
            }
       }
    }
    @IBAction func dismiss(_ sender: UIButton) {
        dismiss(animated: true, completion: nil)
    }
   @IBAction func registerPressed(_ sender: UIButton) {
    let customerCountString="customer\(String(customerCnt))"
//    let customerGamedataString="customerGamedata\(String(customerCnt))"
    db.document("customer/\(customerCountString)").setData(["name":nameTextField.text!,"email":emailTextField.text!,"phone":phoneTextField.text!,"password":passwordTextField.text!]) { Error in
        if let err=Error{
            print("there must have problem to save data \(err)")
        }
        else{
            print("data saved successfully")
        }
        self.customerCnt+=1
        self.nameTextField.text=""
        self.emailTextField.text=""
        self.phoneTextField.text=""
        self.passwordTextField.text=""
        self.confirmPasswordTextField.text=""
    }
//        if let email=emailTextField.text,let password=passwordTextField.text{
//        Auth.auth().createUser(withEmail: email, password: password) { authResult, error in
//        }
//        }
        self.performSegue(withIdentifier:"registertologin" , sender: self)
    }
    
}
extension UIViewController {
    func hideKeyboardWhenTappedAround() {
        let tap = UITapGestureRecognizer(target: self, action: #selector(UIViewController.dismissKeyboard))
        tap.cancelsTouchesInView = false
        view.addGestureRecognizer(tap)
    }
    
    @objc func dismissKeyboard() {
        view.endEditing(true)
    }
}
