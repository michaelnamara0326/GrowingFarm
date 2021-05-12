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
    var customerNum :Int = 0
    let db=Firestore.firestore()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.hideKeyboardWhenTappedAround()
        getCustomerCnt()
    }
    @IBAction func dismiss(_ sender: UIButton) {
        dismiss(animated: true, completion: nil)
    }
    @IBAction func registerPressed(_ sender: UIButton) {
            emailAuth()
            setCustomerDataToDatabase()
            updateCustomerCnt()
            clearUserInput()
        self.performSegue(withIdentifier:"registertologin" , sender: self)
    }
    
    
    func emailAuth(){
        if let email=emailTextField.text,let password=passwordTextField.text{
            Auth.auth().createUser(withEmail: email, password: password) { authResult, error in
                if let err=error{
                    print("email auth error \(err)")
                }
                else{
                    print("email auth add success")
                }
            }
        }
    }
    func setCustomerDataToDatabase(){
        let customerCountString="customer\(String(customerNum))"
        //    let customerGamedataString="customerGamedata\(String(customerCnt))"
        db.document("customer/\(customerCountString)").setData(["name":nameTextField.text!,"email":emailTextField.text!,"phone":phoneTextField.text!,"password":passwordTextField.text!,"identity":"customer"]) { Error in
            if let err=Error{
                print("there must have problem to save data \(err)")
            }
            else{
                print("data saved successfully")
            }
        }
    }
    func getCustomerCnt(){
        db.collection("appGlobal").getDocuments { snapshot, error in
            if let err = error {
                print("Error getting documents: \(err)")
            }
            else {
                for document in snapshot!.documents {
                    self.customerNum=document.get("customerNum") as! Int
                    print(self.customerNum)
                }
            }
        }
    }
    func updateCustomerCnt(){
        let dbRef=self.db.collection("appGlobal").document("appGlobal1")
        dbRef.updateData(["customerNum":self.customerNum+1]){err in
            if let err=err{
                print(err)
            }
            else{
                print("update success")
            }
        }
    }
    func clearUserInput(){
        self.nameTextField.text=""
        self.emailTextField.text=""
        self.phoneTextField.text=""
        self.passwordTextField.text=""
        self.confirmPasswordTextField.text=""
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
