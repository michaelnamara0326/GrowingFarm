//
//  CreateEventVC.swift
//  growingFarm
//
//  Created by Michael Namara on 2021/6/16.
//  Copyright © 2021 Michael. All rights reserved.
//

import UIKit
import Firebase
import SCLAlertView
class CreateEventVC: UIViewController {
    @IBOutlet weak var nameTextfield: UITextField!
    @IBOutlet weak var typeTextfield:UITextField!
    @IBOutlet weak var hardTextfield: UITextField!
    @IBOutlet weak var expTextfield: UITextField!
    let db=Firestore.firestore()
    let type=["買賣","勞力","智力"]
    let hard=["簡單","中等","困難"]
    let exp:[String:[String:Int]]=["買賣":["簡單":20,"中等":30,"困難":40],"勞力":["簡單":40,"中等":50,"困難":60],"智力":["簡單":10,"中等":20,"困難":30]]
    var pickerView1=UIPickerView()
    var pickerView2=UIPickerView()
    override func viewDidLoad() {
        super.viewDidLoad()
        self.hideKeyboardWhenTappedAround()
        pickerView1.delegate=self
        pickerView1.dataSource=self
        pickerView2.delegate=self
        pickerView2.dataSource=self
        
        typeTextfield.inputView=pickerView1
        typeTextfield.textAlignment = .center
        typeTextfield.placeholder="請選擇活動類型"
        hardTextfield.inputView=pickerView2
        hardTextfield.textAlignment = .center
        hardTextfield.placeholder="請選擇困難度"
        nameTextfield.textAlignment = .center
        nameTextfield.placeholder="請輸入活動名稱"
        expTextfield.placeholder="請先選取類型及困難度"
        expTextfield.textAlignment = .center
        // Do any additional setup after loading the view.
    }
    @IBAction func backBtn(_ sender: UIButton) {
        dismiss(animated: true, completion: nil)
    }
    
    @IBAction func createBtn(_ sender: UIButton) {
        //create event to firebase
        
        guard nameTextfield.text != "" else{
            _ = SCLAlertView().showError("新增失敗", subTitle: "活動名稱未輸入！")
            return
        }
        guard typeTextfield.text != "" else{
            _ = SCLAlertView().showError("新增失敗", subTitle: "活動類型未選擇！")
            return
        }
        guard hardTextfield.text != "" else{
            _ = SCLAlertView().showError("新增失敗", subTitle: "活動困難度未選擇！")
            return
        }
        db.document("farmer/farmer1/farmerGameData/farmer1GameData").setData(["Event":["Event\(farmer.farmerGameDatas.Event.count + 1)":["name":nameTextfield.text!,"exp":Int(expTextfield.text!)]]],merge: true) { error in
            if let err=error{
                _ = SCLAlertView().showError("新增失敗", subTitle: "資料庫異常")
            }
            else{
                _ = SCLAlertView().showSuccess("新增成功", subTitle: "請返回重新載入")
            }
        }
    }
}
extension CreateEventVC:UIPickerViewDataSource{
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return 3
    }
    
}
extension CreateEventVC:UIPickerViewDelegate{
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        if pickerView == pickerView1{
            return type[row]
        }
        else{
            return hard[row]
        }
    }
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        if pickerView == pickerView1{
            typeTextfield.text=type[row]
            typeTextfield.resignFirstResponder()
        }
        else{
            hardTextfield.text=hard[row]
            hardTextfield.resignFirstResponder()
            expTextfield.text=String(exp[typeTextfield.text!]![hardTextfield.text!]!)
            expTextfield.resignFirstResponder()
        }
        if (typeTextfield.text != nil) && (hardTextfield.text != nil){print("in")}
    }
}
