//
//  farmerRegisterVC.swift
//  growingFarm
//
//  Created by Michael on 2021/5/18.
//  Copyright © 2021 Michael. All rights reserved.
//

import Foundation
import UIKit
import Firebase
class farmerRegisterVC:UIViewController{
    
    @IBOutlet weak var nameTextField: UITextField!
    @IBOutlet weak var phoneTextField: UITextField!
    @IBOutlet weak var addressTextField: UITextField!
    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    @IBOutlet weak var confirmPasswordTextField: UITextField!
    var farmerNum :Int = 0
    let db=Firestore.firestore()
    override func viewDidLoad() {
        super.viewDidLoad()
        self.hideKeyboardWhenTappedAround()
        getFarmerCnt()
    }
    @IBAction func dismiss(_ sender: UIButton) {
        dismiss(animated: true, completion: nil)
    }
    @IBAction func registerPressed(_ sender: UIButton) {
            emailAuth()
            setCustomerDataToDatabase()
            updateFarmerCnt()
            clearUserInput()
//        self.performSegue(withIdentifier:"farmerRegisterToLogin" , sender: self)
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
        let farmerCountString="farmer\(String(farmerNum))"
        //    let customerGamedataString="customerGamedata\(String(customerCnt))"
        db.document("farmer/\(farmerCountString)").setData(["name":nameTextField.text!,"email":emailTextField.text!,"phone":phoneTextField.text!,"password":passwordTextField.text!,"address":addressTextField.text!]) { Error in
            if let err=Error{
                print("there must have problem to save data \(err)")
            }
            else{
                print("data saved successfully")
            }
        }
    }
    func getFarmerCnt(){
        db.collection("appGlobal").getDocuments { snapshot, error in
            if let err = error {
                print("Error getting documents: \(err)")
            }
            else {
                for document in snapshot!.documents {
                    self.farmerNum=document.get("farmerNum") as! Int
                    print(self.farmerNum)
                }
            }
        }
    }
    func updateFarmerCnt(){
        let dbRef=self.db.collection("appGlobal").document("appGlobal1")
        dbRef.updateData(["farmerNum":self.farmerNum+1]){err in
            if let err=err{
                print(err)
            }
            else{
                print("update success")
            }
        }
    }
    func clearUserInput(){
        nameTextField.text=""
        addressTextField.text=""
        emailTextField.text=""
        phoneTextField.text=""
        passwordTextField.text=""
        confirmPasswordTextField.text=""
    }
}
