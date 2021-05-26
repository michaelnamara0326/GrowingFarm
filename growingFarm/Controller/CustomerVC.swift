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
    @IBOutlet weak var wateringBtn: UIButton!
    @IBOutlet weak var stageLabel: UILabel!
    @IBOutlet weak var expLabel: UILabel!
    @IBOutlet weak var autoExpLabel: UILabel!
    @IBOutlet weak var cityLabel: UILabel!
    
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
        DispatchQueue.main.asyncAfter(deadline: .now()+5.0) {
            self.expProgressBar()
            self.startTime()
            self.reverseGeocodeUserLocation()
        }
    }
    func expProgressBar(){
        let userStage=customer.customerGameDatas.Stage
        stageLabel.text="Stage:\(userStage)"
        expLabel.text="\(customer.customerGameDatas.Exp)/\(K.GameData.stageExp[userStage]!)"
        autoExpLabel.text="+\(K.GameData.autoExp[userStage]!)/hr"
    }
    

    @IBAction func wateringButton(_ sender: UIButton) {
        sender.isUserInteractionEnabled=false
        sender.alpha=0.5
        let nextTime=Date().addingTimeInterval(10)
//        linearProgressBar.progressValue+=10
//        setExpProgressBar(10)
        let userDataPath="customer/\(customer.customerInfos.DocumentId)/customerGameData/\(customer.customerInfos.DocumentId)GameData"
        db.document(userDataPath).updateData(["timestamp":Timestamp(date: nextTime)])
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
    }
    @IBAction func warehouseButton(_ sender: UIButton) {
        print("pressed")
    }
    @IBAction func shopButton(_ sender: UIButton) {
        print("pressed")
    }
    @IBAction func mapButton(_ sender: UIButton) {
        print("pressed")
        print(lat)
        print(long)
        performSegue(withIdentifier: "customerToMap", sender: self)
    }

    func updateTime() {
        let currentDate = Date()
        let calendar = Calendar.current
        let diffDateComponents = calendar.dateComponents([.day, .hour, .minute, .second], from: currentDate, to: customer.customerGameDatas.TimeStamp.dateValue())
//        let countdown = "\(diffDateComponents.hour ?? 0):\(diffDateComponents.minute ?? 0):\(diffDateComponents.second ?? 0)"
//        print(countdown)
//        print(String(format: "%02d:%02d:%02d", diffDateComponents.hour!,diffDateComponents.minute!,diffDateComponents.second!))
        
        if(diffDateComponents.hour! <= 0 && diffDateComponents.minute! <= 0 && diffDateComponents.second! <= 0){
            timeLeftLabel.text="已可點擊!"
            wateringBtn.isUserInteractionEnabled=true
            wateringBtn.alpha=1
            timesUp=true
        }else{
            wateringBtn.isUserInteractionEnabled=false
            wateringBtn.alpha=0.5
            let countdown=String(format: "%02d:%02d:%02d", diffDateComponents.hour!,diffDateComponents.minute!,diffDateComponents.second!)
            timeLeftLabel.text="剩餘\(countdown)"
        }
       
    }
    @objc func startTime(){
        Timer.scheduledTimer(withTimeInterval: 1.0, repeats: true) { Timer in
            if self.timesUp == false{
                self.updateTime()
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
