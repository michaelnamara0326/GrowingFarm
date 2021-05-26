//
//  CustomerController.swift
//  growingFarm
//
//  Created by Michael on 2021/5/11.
//  Copyright © 2021 Michael. All rights reserved.
//

import Foundation
import UIKit
import CoreLocation
import Firebase
import LinearProgressBar
class CustomerVC:UIViewController, CLLocationManagerDelegate{
    var lat:CLLocationDegrees=0
    var long:CLLocationDegrees=0
    var locationManager=CLLocationManager()
    var customerInfo:[String:Any]=[:]
    var customerGameData:[String:Any]=[:]
    let db=Firestore.firestore()
    var timer=Timer()
    var userTimestamp:Date?
    var timesUp:Bool=false
    let fetchData=FetchData()
    
    @IBOutlet weak var linearProgressBar: LinearProgressBar!
    @IBOutlet weak var wateringExpLabel: UILabel!
    @IBOutlet weak var timeLeftLabel: UILabel!
    @IBOutlet weak var stageLabel: UILabel!
    @IBOutlet weak var expLabel: UILabel!
    @IBOutlet weak var autoExpLabel: UILabel!
    @IBOutlet weak var cityLabel: UILabel!
    @IBOutlet weak var wateringBtn: UIButton!
    override func viewDidLoad() {
        DispatchQueue.main.async {
            self.fetchData.getCustomerInfo()
            self.fetchData.getCustomerGameData()
        }
        //        linearProgressBar.progressValue=customerGameData["exp"] as! CGFloat
        locationManager.requestAlwaysAuthorization()
        locationManager.requestWhenInUseAuthorization()
        if CLLocationManager.locationServicesEnabled() {
            locationManager.delegate = self
            locationManager.desiredAccuracy=kCLLocationAccuracyNearestTenMeters
            locationManager.startUpdatingLocation()
        }
        
    }
    override func viewDidAppear(_ animated: Bool) {
        DispatchQueue.main.asyncAfter(deadline: .now()+2.0) {
            self.updateExpProgressBarLabel()
            self.startTime()
            self.reverseGeocodeUserLocation()
            self.autoExp()
        }
        
    }
    func alertController(_ identify:Int,_ alertTitle:String, _ alertMessage:String){
        let controller = UIAlertController(title: alertTitle, message: alertMessage, preferredStyle: .alert)
        let expFullAction = UIAlertAction(title: "OK", style: .default){ action in
            self.updateExpProgressBarLabel()
        }
        let overTimeAction=UIAlertAction(title:"知道了",style: .default)
        let totalAutoExpAction=UIAlertAction(title: "OK", style: .default)
        switch identify{
        case 1:
            controller.addAction(expFullAction)
        case 2:
            controller.addAction(overTimeAction)
        case 3:
            controller.addAction(totalAutoExpAction)
        default:
            break
        }
        self.present(controller, animated: true, completion: nil)
    }
    
    func autoExp(){
        let time=updateTime(customer.customerGameDatas.LastTimestamp)
        if(-(time.0) > 12){
            alertController(2,"超過12小時未查看農場", "系統未自動增加您的經驗值")
        }
        else{
            let exp = -(time.0) * K.GameData.autoExp[customer.customerGameDatas.Stage]!
            pushExpProgessBar(exp)
            alertController(3, "歡迎回來!", "自動獲得\(exp)經驗值")
        }
    }
    
    
    func updateExpProgressBarLabel(){
        let userDataPath="customer/\(customer.customerInfos.DocumentId)/customerGameData/\(customer.customerInfos.DocumentId)GameData"
        let userStage=customer.customerGameDatas.Stage
        stageLabel.text="Stage:\(userStage)"
        expLabel.text="\(customer.customerGameDatas.Exp)/\(K.GameData.stageExp[userStage]!)"
        autoExpLabel.text="+\(K.GameData.autoExp[userStage]!)/hr"
        linearProgressBar.progressValue = CGFloat(customer.customerGameDatas.Exp) / CGFloat(K.GameData.stageExp[userStage]!) * 100
        if(linearProgressBar.progressValue >= 100){
            alertController(1,"恭喜完成第\(userStage)階", "前往下一階段")
        }
    }
    func pushExpProgessBar(_ exp:Int){
        let userDataPath="customer/\(customer.customerInfos.DocumentId)/customerGameData/\(customer.customerInfos.DocumentId)GameData"
        let userStage=customer.customerGameDatas.Stage
        db.document(userDataPath).updateData(["exp":customer.customerGameDatas.Exp + exp])
        DispatchQueue.main.asyncAfter(deadline: .now()+0.5) {
            if customer.customerGameDatas.Exp >= K.GameData.stageExp[userStage]! {
                self.db.document(userDataPath).updateData(["exp":customer.customerGameDatas.Exp - K.GameData.stageExp[userStage]!])
                if Int(userStage)! != 3 {
                self.db.document(userDataPath).updateData(["stage":String(Int(userStage)! + 1)])
                }
                else{
                    self.db.document(userDataPath).updateData(["stage":"1"])
                }
            }
            self.updateExpProgressBarLabel()
        }
//        updateExpProgressBarLabel()
    }

    @IBAction func wateringButton(_ sender: UIButton) {
        let userDataPath="customer/\(customer.customerInfos.DocumentId)/customerGameData/\(customer.customerInfos.DocumentId)GameData"
        sender.isUserInteractionEnabled=false
        sender.alpha=0.5
        let nextTime=Date().addingTimeInterval(10)
//        linearProgressBar.progressValue+=10
        pushExpProgessBar(10)
        db.document(userDataPath).updateData(["wateringTimestamp":Timestamp(date: nextTime)])
        startTime()
    }
   
            
    @IBAction func signoutButton(_ sender: UIButton) {
        let firebaseAuth = Auth.auth()
        do {
            try firebaseAuth.signOut()
        } catch let signOutError as NSError {
            print ("Error signing out: %@", signOutError)
        }
        //       performSegue(withIdentifier: "customerToMain", sender: self)
    }
    
    @IBAction func weatherButton(_ sender: UIButton) {
        print("pressed")
    }
    @IBAction func qrcodeButton(_ sender: UIButton) {
        print("pressed")
        print(updateTime(customer.customerGameDatas.LastTimestamp))
    }
    @IBAction func warehouseButton(_ sender: UIButton) {
        print("pressed")
    }
    @IBAction func shopButton(_ sender: UIButton) {
        print("pressed")
    }
    @IBAction func mapButton(_ sender: UIButton) {
        print(lat)
        print(long)

    }

    func updateTime(_ timeStamp:Timestamp) ->(Int,Int,Int) {
        let currentDate = Date()
        let calendar = Calendar.current
        let diffDateComponents = calendar.dateComponents([.day, .hour, .minute, .second], from: currentDate, to: timeStamp.dateValue())
        let hour = diffDateComponents.day! * 24 + diffDateComponents.hour!
        let minute = diffDateComponents.minute!
        let second = diffDateComponents.second!
//        let countdown = "\(diffDateComponents.hour ?? 0):\(diffDateComponents.minute ?? 0):\(diffDateComponents.second ?? 0)"
//        print(countdown)
//        print(String(format: "%02d:%02d:%02d", diffDateComponents.hour!,diffDateComponents.minute!,diffDateComponents.second!))
        return (hour,minute,second)
    }
    @objc func startTime(){
        Timer.scheduledTimer(withTimeInterval: 1.0, repeats: true) { Timer in
            if self.timesUp == false{
                let time = self.updateTime(customer.customerGameDatas.WateringTimestamp)
                if(time.0 <= 0 && time.1 <= 0 && time.2 <= 0){
                    self.timeLeftLabel.text="已可點擊!"
                    self.wateringBtn.isUserInteractionEnabled=true
                    self.wateringBtn.alpha=1
                    self.timesUp=true
                }else{
                    self.wateringBtn.isUserInteractionEnabled=false
                    self.wateringBtn.alpha=0.5
                    let countdown=String(format: "%02d:%02d:%02d", time.0,time.1,time.2)
                    self.timeLeftLabel.text="剩餘\(countdown)"
                }
            }
            else{
                Timer.invalidate()
                self.timesUp=false
            }
        }

    }
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        guard let locValue: CLLocationCoordinate2D = manager.location?.coordinate else { return }
        self.lat=locValue.latitude
        self.long=locValue.longitude
//        print(locValue.latitude)
//        print(locValue.longitude)
    }
 
    func reverseGeocodeUserLocation(){
        let geocoder=CLGeocoder()
        let location=CLLocation(latitude: lat, longitude: long)
        geocoder.reverseGeocodeLocation(location,preferredLocale: Locale.init(identifier: "zh-tw")) { placemark, Error in
            if let err=Error{
                print("reverse geodcode fail: \(err.localizedDescription)")
            }
            else{
                var placeMark: CLPlacemark!
                placeMark = placemark?[0]
                print(placemark?.first ?? "")
                print(placeMark.subAdministrativeArea ?? "")
                self.cityLabel.text=placeMark.subAdministrativeArea ?? ""
            }
        }
        locationManager.stopUpdatingLocation()
    }
    
}


