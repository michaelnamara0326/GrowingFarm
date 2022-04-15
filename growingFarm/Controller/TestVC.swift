//
//  TestVC.swift
//  growingFarm
//
//  Created by Michael Namara on 2021/5/27.
//  Copyright © 2021 Michael. All rights reserved.
//

import Foundation
import UIKit
import EFQRCode
import Lottie
class TestVC:UIViewController{
    let fetchData=FetchData()
    
    @IBOutlet weak var view123: UIImageView!
    @IBOutlet weak var animationView1: AnimationView!
    @IBOutlet weak var animationView3: AnimationView!
    var isAdd=false
    override func viewDidLoad() {
        super.viewDidLoad()
        //        fetchData.getFarmerInfo()
        //        fetchData.getFarmerGameData()
        //        fetchData.getAppGlobal()
//        CityWeather().fetchWeather()
        cityPrice().fetchPrice()
//        let sunny=Animation.named("5628-favorites")
//        animationView1.animation=sunny
//        animationView1.play()
//        animationView1.loopMode = .loop
//        let favorite=Animation.named("5628-favorites")
//        animationView1.animation=favorite
        let favorite=AnimationView(name: "5628-favorites")
        favorite.frame = CGRect(x: 0, y: 0, width: 50, height: 50)
        favorite.center = CGPoint(x: animationView1.bounds.width/2, y: animationView1.bounds.height/2)
        favorite.play(toProgress: 0)
        animationView1.addSubview(favorite)
//        animationView1.play(toProgress: 0)
    }
    override func viewWillAppear(_ animated: Bool) {
//        updateAnimationView()
    }
    @IBAction func tapgreen(_ sender: UITapGestureRecognizer) {
        print("tap green view")
        if isAdd == true{
            animationView1.animationSpeed=2
            animationView1.play(fromProgress:1,toProgress:0)
            isAdd=false
        }
        else{
            animationView1.animationSpeed=1.3
            animationView1.play(fromProgress:0,toProgress:1)
            isAdd=true
        }
    }
    
    @IBAction func pressed(_ sender: UIButton) {
        //        LeisureFarm().fetchFarm()
        //        cityArea().fetchArea()
//        cityPrice().fetchPrice()
//        cityArea().fetchArea()
    }
    func updateAnimationView(){
        var animationView2=AnimationView(name: "5628-favorites")
//        if K.GameData.weather.weather.contains("晴"){
//            animationView2=AnimationView(name: "4804-weather-sunny")
//        }
//        else{
//            animationView2=AnimationView(name: "4801-weather-partly-shower")
//        }
        animationView2.frame = CGRect(x: 0, y: 0, width: 100, height: 100)
        animationView2.center = CGPoint(x: animationView3.bounds.width/2, y: animationView3.bounds.height/2)
        animationView2.contentMode = .scaleAspectFit
        animationView2.play()
        animationView2.loopMode = .playOnce
//        animationView2.contentMode = .scaleAspectFit
//        animationView2.play()
//        animationView2.loopMode = .loop
        animationView3.addSubview(animationView2)
    }
}
