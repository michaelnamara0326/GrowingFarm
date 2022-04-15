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
import SCLAlertView
import Lottie

class CustomerVC:UIViewController{
    //MARK:Parameter
    var lat:CLLocationDegrees=0
    @objc var long:CLLocationDegrees=0
    var locationManager=CLLocationManager()
    let db=Firestore.firestore()
    var timer=Timer()
    var userTimestamp:Date?
    var timesUp:Bool=false
    var userCity:String=""
    let fetchData=FetchData()
    let warning=AnimationView(name: "8750-alert")
    @IBOutlet weak var linearProgressBar: LinearProgressBar!
    @IBOutlet weak var warningAnimation: UIView!
    @IBOutlet weak var wateringExpLabel: UILabel!
    @IBOutlet weak var timeLeftLabel: UILabel!
    @IBOutlet weak var stageLabel: UILabel!
    @IBOutlet weak var expLabel: UILabel!
    @IBOutlet weak var autoExpLabel: UILabel!
    @IBOutlet weak var cityLabel: UILabel!
    @IBOutlet weak var degreeLabel: UILabel!
    @IBOutlet weak var wateringBtn: UIButton!
    @IBOutlet weak var breedBtn: UIButton!
    @IBOutlet weak var moneyBtn: UIButton!
    @IBOutlet weak var weatherBtn: UIButton!
    @IBOutlet weak var weatherImageView: UIImageView!
    @IBOutlet weak var paddyImageView: UIImageView!
    
    //MARK: view
    override func viewDidLoad() {
        let longGesture = UILongPressGestureRecognizer(target: self, action: #selector(longTap))
        let longGesture1 = UILongPressGestureRecognizer(target: self, action: #selector(longTap1))
        wateringBtn.addGestureRecognizer(longGesture1)
        weatherBtn.addGestureRecognizer(longGesture)
        warning.frame = CGRect(x: 0, y: 0, width: 50, height: 50)
        warning.center = CGPoint(x: self.warningAnimation.bounds.width/2, y: self.warningAnimation.bounds.height/2)
        warning.contentMode = .scaleAspectFit
        //        warning.play()
        //        warning.loopMode = .loop
        self.warningAnimation.addSubview(warning)
        //        DispatchQueue.main.async {
        //            self.fetchData.getCustomerInfo()
        //            self.fetchData.getCustomerGameData()
        //        }
//        locationManager.requestAlwaysAuthorization()
//        locationManager.requestWhenInUseAuthorization()
        if (CLLocationManager.locationServicesEnabled()) {
            locationManager.delegate = self
            locationManager.desiredAccuracy=kCLLocationAccuracyNearestTenMeters
            locationManager.startUpdatingLocation()
        }
        
        DispatchQueue.main.asyncAfter(deadline: .now()+1.0) {
            if(customer.customerGameDatas.Breed != ""){
                self.autoExp()
            }
            DispatchQueue.main.asyncAfter(deadline: .now()+2){
                self.fetchData.updateCustomerGameData("loginTimes", customer.customerGameDatas.LoginTime+1)
            }
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
            DispatchQueue.main.asyncAfter(deadline: .now()+1.0) {
                K.GameData.city.cityArea=appGlobal.citydata.cityArea
                K.GameData.city.cityPrice=appGlobal.citydata.cityPrice
                self.reverseGeocodeUserLocation()
                if(customer.customerGameDatas.LoginTime == 0){
                    let appearance = SCLAlertView.SCLAppearance(showCloseButton: false, dynamicAnimatorActive: true)
                    let alert = SCLAlertView(appearance: appearance)
                    _ = alert.addButton("開始遊戲吧！"){
                        _ = SCLAlertView().showNotice("如何進行", subTitle: "請先點選左下方秧苗圖示選取種植品種")
                    }
                    _ = alert.showSuccess("嗨~\(customer.customerInfos.Name)\n歡迎加入成長農場",subTitle: "這是一款能讓你虛擬體驗農夫的APP")
                    self.fetchData.updateCustomerGameData("lastTimestamp", Timestamp(date: Date()))
                }
                else{
                    if(customer.customerGameDatas.Breed != ""){
                        self.breedBtn.isEnabled=false
                        self.updateExpProgressBarLabel()
                        self.updateWeather()
                        self.startTime()
                        self.cityLabel.text=customer.customerGameDatas.City ?? "新北市"
                        self.degreeLabel.text="\(Int(Double(K.GameData.weather.temp) ?? 28.0)  )°C"
                    }
                    else{
                        self.breedBtn.isEnabled=true
//                        _ = SCLAlertView().showWarning("您尚未選擇秧苗", subTitle: "請至秧苗圖示選取")
                    }
                    if(typhoon.alertType != nil){
                        self.warningAnimation.isHidden=false
                        self.warning.play()
                        self.warning.loopMode = .loop
                    }
                }
            }
        
    }
    @objc func longTap(_ sender: UIGestureRecognizer){
        print("Long tap")
        if sender.state == .ended {
            print("UIGestureRecognizerStateEnded")
            //Do Whatever You want on End of Gesture
        }
        else if sender.state == .began {
            print("UIGestureRecognizerStateBegan.")
            _ = SCLAlertView().showWarning("颱風侵襲", subTitle: "被扣除50點經驗值！")
            //Do Whatever You want on Began of Gesture
        }
    }
    @objc func longTap1(_ sender: UIGestureRecognizer){
        print("Long tap")
        if sender.state == .ended {
            print("UIGestureRecognizerStateEnded")
            //Do Whatever You want on End of Gesture
        }
        else if sender.state == .began {
            print("UIGestureRecognizerStateBegan.")
           autoExp()
            //Do Whatever You want on Began of Gesture
        }
    }
    //MARK: button-pressed
    @IBAction func chooseBreed(_ sender: UIButton) {
        let chooseBreedVC = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "chooseBreed") as! ChooseBreedVC
        self.addChild(chooseBreedVC)
        chooseBreedVC.view.frame=self.view.frame
        self.view.addSubview(chooseBreedVC.view)
        chooseBreedVC.didMove(toParent: self)
        
        chooseBreedVC.city=userCity
    }
    @IBAction func wateringButton(_ sender: UIButton) {
        sender.isUserInteractionEnabled=false
        sender.alpha=0.5
        let nextTime=Date().addingTimeInterval(6*60*60)
        pushExpProgessBar(10)
        fetchData.updateCustomerGameData("wateringTimestamp", Timestamp(date: nextTime))
        startTime()
    }
    @IBAction func signoutButton(_ sender: UIButton) {
//        let firebaseAuth = Auth.auth()
//        do {
//            try firebaseAuth.signOut()
//        } catch let signOutError as NSError {
//            print ("Error signing out: %@", signOutError)
//        }
        updateUI()
    }
    
    @IBAction func moneyButton(_ sender: UIButton) {
        let customerBreed=customer.customerGameDatas.Breed!
        let customerCity=customer.customerGameDatas.City!
        let customerBreedPrice=Int(K.GameData.city.cityPrice[customerCity]![customerBreed]!)
        let customerAreaOutput=K.GameData.city.cityArea[customerCity]!
        let appearance = SCLAlertView.SCLAppearance(showCloseButton:false)
        let alert = SCLAlertView(appearance: appearance)
        _ = alert.addButton("等待高價"){
            return
        }
        _ = alert.addButton("確定收割"){
            self.moneyBtn.isHidden=true
            self.breedBtn.isEnabled=true
            self.fetchData.updateCustomerGameData("coin", customer.customerGameDatas.Coin + (customerAreaOutput*customerBreedPrice))
            self.fetchData.updateCustomerGameData("exp", 0)
            self.fetchData.updateCustomerGameData("stage", "1")
            self.fetchData.updateCustomerGameData("breed", "")
            self.fetchData.updateCustomerGameData("city", "")
            DispatchQueue.main.asyncAfter(deadline: .now()+1) {
                self.updateExpProgressBarLabel()
            }
            _ = SCLAlertView().showSuccess("恭喜豐收！", subTitle: "獲得\(customerAreaOutput*customerBreedPrice)稻穗幣")
        }
        _ = alert.showNotice("確定收割交付嗎？", subTitle: "\(customerCity)\n產量:\(customerAreaOutput)\n今日\(customerBreed)米價格:\(customerBreedPrice)\n總計\(customerAreaOutput*customerBreedPrice)")
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
        print(lat)
        print(long)
    }
    func updateWeather(){
        var animationView=AnimationView()
        animationView=createAnimationView(weather: "晴")
        if(K.GameData.weather.weather.contains("晴")){
            animationView=createAnimationView(weather: "晴")
        }
        else if(K.GameData.weather.weather.contains("多雲")){
            animationView=createAnimationView(weather: "多雲")
        }
        else if(K.GameData.weather.weather.contains("陰")){
            animationView=createAnimationView(weather: "陰")
        }
        
        if(K.GameData.weather.weather.contains("雨")){
            if(K.GameData.weather.weather.contains("雷")){
                animationView=createAnimationView(weather: "雷")
            }
            animationView=createAnimationView(weather: "雨")
        }
        weatherImageView.addSubview(animationView)
    }
    func createAnimationView(weather:String)->AnimationView{
        let animationview=AnimationView()
        switch weather {
        case "晴":
            let sun=Animation.named("4804-weather-sunny")
            animationview.animation=sun
        case "陰":
            let windy=Animation.named("4806-weather-windy")
            animationview.animation=windy
        case "多雲":
            let cloudy=Animation.named("4800-weather-partly-cloudy")
            animationview.animation=cloudy
        case "雨":
            let rain=Animation.named("4801-weather-partly-shower")
            animationview.animation=rain
        case "雷":
            let lightining=Animation.named("4803-weather-storm")
            animationview.animation=lightining
        case "警報":
            let alert=Animation.named("8750-alert")
            animationview.animation=alert
        default:
            break
        }
        animationview.frame=CGRect(x: 0, y: 0, width: 245, height: 245)
        animationview.center = CGPoint(x: weatherImageView.bounds.width/2, y: weatherImageView.bounds.height/2-10)
        animationview.contentMode = .scaleAspectFit
        animationview.play()
        animationview.loopMode = .loop
        return animationview
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
    func autoExp(){
        let time=updateTime(customer.customerGameDatas.LastTimestamp)
        if(-(time.0) > 24){
            _ = SCLAlertView().showWarning("超過24小時未查看農場", subTitle: "系統未自動增加您的經驗值")
        }
        else{
            let exp = -(time.0) * K.GameData.breed1.autoExp[customer.customerGameDatas.Stage]!
            pushExpProgessBar(exp)
            _ = SCLAlertView().showInfo("歡迎回來!", subTitle: "離開總計:\(-(time.0))小時\n自動獲得\(exp)經驗值")
        }
        fetchData.updateCustomerGameData("lastTimestamp", Timestamp(date: Date()))
    }
    
    func updateUI(){
        DispatchQueue.main.asyncAfter(deadline: .now()+1.0) {
            K.GameData.city.cityArea=appGlobal.citydata.cityArea
            K.GameData.city.cityPrice=appGlobal.citydata.cityPrice
            self.reverseGeocodeUserLocation()
            if(customer.customerGameDatas.LoginTime == 0){
                let appearance = SCLAlertView.SCLAppearance(showCloseButton: false, dynamicAnimatorActive: true)
                let alert = SCLAlertView(appearance: appearance)
                _ = alert.addButton("開始遊戲吧！"){
                    _ = SCLAlertView().showNotice("如何進行", subTitle: "請先點選左下方秧苗圖示選取種植品種")
                }
                _ = alert.showSuccess("嗨~\(customer.customerInfos.Name),歡迎加入成長農場",subTitle: "這是一款能讓你虛擬體驗農夫的APP")
                self.fetchData.updateCustomerGameData("lastTimestamp", Timestamp(date: Date()))
            }
            else{
                if(customer.customerGameDatas.Breed != ""){
                    self.breedBtn.isEnabled=false
                    self.updateExpProgressBarLabel()
                    self.updateWeather()
                    self.startTime()
                    self.cityLabel.text=customer.customerGameDatas.City ?? "新北市"
                    self.degreeLabel.text="\(Int(Double(K.GameData.weather.temp) ?? 28.0)  )°C"
                }
                else{
                    self.breedBtn.isEnabled=true
                    _ = SCLAlertView().showWarning("您尚未選擇秧苗", subTitle: "請至秧苗圖示選取")
                }
                if(typhoon.alertType != nil){
                    self.warningAnimation.isHidden=false
                    self.warning.play()
                    self.warning.loopMode = .loop
                }
            }
        }
    }
    func updateExpProgressBarLabel(){
        let userStage=customer.customerGameDatas.Stage
        let userBreed=customer.customerGameDatas.Breed == "1" ? K.GameData.breed1.stageExp[userStage]! : K.GameData.breed2.stageExp[userStage]!
        switch userStage {
        case "1":
            paddyImageView.image=UIImage(named: "水稻1")
        case "2":
            paddyImageView.image=UIImage(named: "水稻2")
        case "3":
            paddyImageView.image=UIImage(named: "水稻3")
        default:
            return
        }
        
        stageLabel.text="Stage:\(userStage)"
        expLabel.text="\(customer.customerGameDatas.Exp)/\(userBreed)"
        autoExpLabel.text="+\(K.GameData.breed1.autoExp[userStage]!)/hr"
        linearProgressBar.progressValue = CGFloat(customer.customerGameDatas.Exp) / CGFloat(userBreed) * 100
        if(linearProgressBar.progressValue >= 100){
            let appearance = SCLAlertView.SCLAppearance(showCloseButton:false)
            let alert = SCLAlertView(appearance: appearance)
            _ = alert.addButton("Go"){
                self.updateExpProgressBarLabel()
            }
            if Int(userStage)! != 3{
                self.fetchData.updateCustomerGameData("exp", customer.customerGameDatas.Exp - userBreed)
                self.fetchData.updateCustomerGameData("stage", String(Int(userStage)! + 1))
                _ = alert.showSuccess("恭喜完成第\(userStage)階", subTitle: "前往下一階段")
            }
            else{
                self.moneyBtn.isHidden=false
                _ = SCLAlertView().showSuccess("恭喜完成最後階段", subTitle: "前往收割稻米")
                paddyImageView.image=UIImage(named: "水稻4")
            }
        }
    }
    func pushExpProgessBar(_ exp:Int){
        fetchData.updateCustomerGameData("exp", customer.customerGameDatas.Exp + exp)
        DispatchQueue.main.asyncAfter(deadline: .now()+0.5) {
            self.updateExpProgressBarLabel()
        }
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
                print(placeMark.subAdministrativeArea ?? "")
                self.userCity=placeMark.subAdministrativeArea!
            }
        }
        locationManager.stopUpdatingLocation()
        print("get loc done")
    }
    
}
extension CustomerVC:CLLocationManagerDelegate{
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        guard let locValue: CLLocationCoordinate2D = manager.location?.coordinate else { return }
        lat=locValue.latitude
        long=locValue.longitude
        //        print(locValue.latitude)
        //        print(locValue.longitude)
    }
}
