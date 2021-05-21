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
    var peopleLabelText:String!
    var peopleIdentifier:String!
    var userInfo:[String:Any]=[:]
    var userDocumentID:String=""
    public override func viewDidLoad() {
        people.text=peopleLabelText
        self.hideKeyboardWhenTappedAround()
    }
    // MARK: button tapped
    @IBAction func segueToRegister(_ sender: UIButton) {
        switch peopleIdentifier {
        case "customer":
            performSegue(withIdentifier: "loginToCustomerRegister", sender: sender)
        case "farmer":
            performSegue(withIdentifier: "loginToFarmerRegister", sender: sender)
        default:
            break
        }
        
    }
    @IBAction func backtoMain(_ sender: UIButton) {
        dismiss(animated: true, completion: nil)
    }
    @IBAction func loginPressed(_ sender: UIButton) {
        guard let email=emailTextField.text, !email.isEmpty ,let password=passwordTextField.text, !password.isEmpty else{
            errorLabel.text="請輸入Email或密碼"
            return
        }
        loginView(email,password)
    }
    func loginView(_ email:String, _ password:String){
        getUserInfo(userEmail: email)
        Auth.auth().signIn(withEmail: email, password: password) { user, error in
            if let e=error{
                self.errorLabel.text="Invalid to login\(e)"
            }
            else{
//                if !Auth.auth().currentUser!.isEmailVerified{
//                    self.errorLabel.text="尚未驗證信箱"
//                }
//                else{
                    let identify=self.userInfo["identifier"] as? String
                    if identify == "customer"  && self.peopleLabelText == "民眾登入" {
                        self.performSegue(withIdentifier: "segueCustomer", sender: self)
                    }
                    else if identify == "farmer" && self.peopleLabelText=="農家登入"{
                        self.performSegue(withIdentifier: "segueFarmer", sender: self)
                    }
                    else{
                        self.errorLabel.text="身份錯誤"
                    }
//                }
            }
        }
    }
    func getUserInfo(userEmail email:String){
        db.collection(peopleIdentifier).whereField("email", isEqualTo: email).getDocuments { querySanpshot, error in
            if let err=error{
                self.errorLabel.text="查無用戶資料"
                print(err)
            }
            else{
                for document in querySanpshot!.documents{
                    self.userInfo=document.data()
                    self.userDocumentID=document.documentID
                }
            }
        }
        
    }
    func updateUserInfo(_ documentID:String){
        let dbRef=db.collection(peopleIdentifier).document(documentID)
        if userInfo["loginTimes"] as! Int == 0{
            dbRef.updateData(["isVerified":true])
        }
        dbRef.updateData(["loginTimes":userInfo["loginTimes"] as! Int + 1])
        print("update user info successfullly")
    }
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier=="segueCustomer" || segue.identifier=="segueFarmer"{
//            let vc=segue.destination as! FarmerVC
//            vc.farmerEmail=emailTextField.text!
            updateUserInfo(userDocumentID)
        }
    }
}

