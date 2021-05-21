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

class customerRegisterVC:UIViewController{
    //MARK: View Controller Element
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
    // MARK: buttonPressed
    @IBAction func registerPressed(_ sender: UIButton) {
            emailAuth()
    }
    

    func alertController(_ alertTitle:String, _ alertMessage:String){
        let controller = UIAlertController(title: alertTitle, message: alertMessage, preferredStyle: .alert)
           let okAction = UIAlertAction(title: "OK", style: .default, handler: nil)
           controller.addAction(okAction)
        self.present(controller, animated: true, completion: nil)
    }
    func sendVerificationMail() {
        if Auth.auth().currentUser!.isEmailVerified{
            self.alertController("此信箱已驗證", "請返回登入")
        }
        else{
            Auth.auth().currentUser?.sendEmailVerification{ err in
                if let err=err{
                    print("send email verification faild \(err)")
                }
                else{
                    self.alertController("已發送驗證信", "請前往查看信件")
                }
                
            }
        }
    }
    // MARK: function
    func emailAuth(){
        if let email=emailTextField.text,let password=passwordTextField.text{
            Auth.auth().createUser(withEmail: email, password: password) { authResult, error in
                if error != nil{
                    if let errCode = AuthErrorCode(rawValue: error!._code){
                        switch errCode {
                        case .invalidEmail:
                            self.alertController("信箱格式錯誤", "請重新輸入")
                        case .emailAlreadyInUse:
                            self.alertController("信箱已存在", "請返回登入畫面")
                        default:
                            break
                        }
                    }
                }
                else{
                    self.sendVerificationMail()
                    self.setCustomerDataToDatabase()
                    self.updateCustomerCnt()
                    self.clearUserInput()
                    
                }
            }
        }
    }
    func setCustomerDataToDatabase(){
        let customerCountString="customer\(String(customerNum))"
        db.document("customer/\(customerCountString)").setData(["No.":customerNum,"name":nameTextField.text!,"email":emailTextField.text!,"phone":phoneTextField.text!,"password":passwordTextField.text!,"identifier":"customer","isVerfied":false,"loginTimes":0]) { Error in
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
        nameTextField.text=""
        emailTextField.text=""
        phoneTextField.text=""
        passwordTextField.text=""
        confirmPasswordTextField.text=""
    }
}
