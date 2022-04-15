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
import SCLAlertView

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
    var sendCustomerGameData:[String:Any]=[:]
    public override func viewDidLoad() {
        people.text=peopleLabelText
        self.hideKeyboardWhenTappedAround()
        
    }
    override func viewDidAppear(_ animated: Bool) {
       userLoggedIn()
        CityWeather().fetchWeather()
        TyphoonManager().fetchTyphoon()
    }
    func userLoggedIn(){
        if let user=Auth.auth().currentUser  {
            // segue to main view controller
            alertLoginView(title: "已登入")
//            errorLabel.text="已登入，請稍候..."
            print(user.email!)
//            getUserInfo(userEmail: user.email!)
            FetchData().getCustomerInfo()
            FetchData().getCustomerGameData()
            
//                self.getCustomerGameData()
            DispatchQueue.main.asyncAfter(deadline: .now()+2.0) {
                if self.peopleLabelText == "民眾登入"{
                    self.performSegue(withIdentifier: "segueCustomer", sender: self)
                }
                else{
                    self.performSegue(withIdentifier: "segueFarmer", sender: self)
                }
            }
        }
        else {
            // sign in
            errorLabel.text="尚未登入"
        }
    }
    func alertLoginView(title:String){
        let appearance = SCLAlertView.SCLAppearance(showCloseButton: false)
        let _ = SCLAlertView(appearance: appearance).showWait(title, subTitle: "請稍候...", closeButtonTitle: nil, timeout: nil, colorStyle: nil, colorTextButton: 0xFFFFFF, circleIconImage: nil, animationStyle: SCLAnimationStyle.topToBottom)
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
//        getUserInfo(userEmail: email)
        let appearance = SCLAlertView.SCLAppearance(showCloseButton: false)
        let alert = SCLAlertView(appearance: appearance).showWait("登入中", subTitle: "請稍候...", closeButtonTitle: nil, timeout: nil, colorStyle: nil, colorTextButton: 0xFFFFFF, circleIconImage: nil, animationStyle: SCLAnimationStyle.topToBottom)
        FetchData().getCustomerInfo()
        FetchData().getCustomerGameData()
        DispatchQueue.main.asyncAfter(deadline: .now()+0.5) {
//            self.errorLabel.text="登入中,請稍候..."
            Auth.auth().signIn(withEmail: email, password: password) { user, error in
                if let e=error{
                    self.errorLabel.text="登入失敗！"
                }
                else{
                    //                if !Auth.auth().currentUser!.isEmailVerified{
                    //                    self.errorLabel.text="尚未驗證信箱"
                    //                }
                    //                else{
                    
                    if customer.customerInfos.Identifier == "customer" && self.peopleLabelText == "民眾登入" {
                        self.errorLabel.text="登入成功！"
//                        self.getCustomerGameData()
                        self.performSegue(withIdentifier: "segueCustomer", sender: self)
                    }
                    else if farmer.farmerInfos.Identifier == "farmer" && self.peopleLabelText=="農家登入"{
                        self.errorLabel.text="登入成功！"
                        self.performSegue(withIdentifier: "segueFarmer", sender: self)
                    }
                    else{
                        self.errorLabel.text="身份錯誤"
                    }
                    //                 }
//                    print(self.userInfo)
                }
                alert.close()
            }
            
        }
    }
    func getCustomerGameData(){
        let userNo=userInfo["No"] as! String
        db.document("customer/customer\(userNo)/customerGameData/customerGameData\(userNo)").getDocument { snapShot, error in
            if let err=error{
                print("read data false\(err)")
            }
            else{
                self.sendCustomerGameData=snapShot!.data()!
                print("success send customer game data")
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
                    print("成功")
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
        if segue.identifier == "segueCustomer"{
            FetchData().getAppGlobal()
            FetchData().getCustomerInfo()
            FetchData().getCustomerGameData()
//            cityPrice().fetchPrice()
//            cityArea().fetchArea()
            CityWeather().fetchWeather()
            TyphoonManager().fetchTyphoon()
//            updateUserInfo(userDocumentID)
        }
        else {
            FetchData().getAppGlobal()
            FetchData().getFarmerInfo()
            FetchData().getFarmerGameData()
        }
    }
}

