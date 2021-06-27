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
    
    @IBOutlet weak var animationView1: AnimationView!
    @IBOutlet weak var animationView3: AnimationView!
    override func viewDidLoad() {
        super.viewDidLoad()
        //        fetchData.getFarmerInfo()
        //        fetchData.getFarmerGameData()
        //        fetchData.getAppGlobal()
//        CityWeather().fetchWeather()
        cityPrice().fetchPrice()
        let sunny=Animation.named("4804-weather-sunny")
        animationView1.animation=sunny
        animationView1.play()
        animationView1.loopMode = .loop
    }
    override func viewWillAppear(_ animated: Bool) {
//        updateAnimationView()
    }
    @IBAction func pressed(_ sender: UIButton) {
        //        LeisureFarm().fetchFarm()
        //        cityArea().fetchArea()
        cityPrice().fetchPrice()
//        cityArea().fetchArea()
    }
    func updateAnimationView(){
        var animationView2=AnimationView(name: "4804-weather-sunny")
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
        animationView2.loopMode = .loop
//        animationView2.contentMode = .scaleAspectFit
//        animationView2.play()
//        animationView2.loopMode = .loop
        animationView3.addSubview(animationView2)
    }
}
