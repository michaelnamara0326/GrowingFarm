//
//  ViewController.swift
//  growingFarm
//
//  Created by Michael on 2021/4/16.
//  Copyright © 2021 Michael. All rights reserved.
//

import UIKit
import CoreLocation
import Photos
class MainVC: UIViewController,CLLocationManagerDelegate {
    var peopleText:String!
    var peopleIdentity:String!
    var peopleColor:UIColor!
    let locationManager=CLLocationManager()
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    override func viewDidAppear(_ animated: Bool) {
        locationManager.requestAlwaysAuthorization()
        locationManager.requestWhenInUseAuthorization()
//        if (CLLocationManager.locationServicesEnabled()) {
//            locationManager.delegate = self
//            locationManager.desiredAccuracy=kCLLocationAccuracyNearestTenMeters
//            locationManager.startUpdatingLocation()
//        }
    }
    @IBAction func segueToLogin(_ sender: UIButton) {
        if(sender.accessibilityLabel=="customerBtn"){
            peopleText="民眾登入"
            peopleIdentity="customer"
            peopleColor=#colorLiteral(red: 0.8703275323, green: 0.9357070327, blue: 0.9039972425, alpha: 1)
        }
        if(sender.accessibilityLabel=="farmerBtn"){
            peopleText="農家登入"
            peopleIdentity="farmer"
            peopleColor=#colorLiteral(red: 0.8185235262, green: 0.9557378888, blue: 1, alpha: 1)
        }
        self.performSegue(withIdentifier: "segueLogin", sender: self)
    }
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let loginVC = segue.destination as! LoginVC
        loginVC.peopleLabelText = peopleText // someValue.text
        loginVC.peopleIdentifier=peopleIdentity
        loginVC.view.backgroundColor=peopleColor
    }
    
}

extension UIViewController {
    func hideKeyboardWhenTappedAround() {
        let tap = UITapGestureRecognizer(target: self, action: #selector(UIViewController.dismissKeyboard))
        tap.cancelsTouchesInView = false
        view.addGestureRecognizer(tap)
    }
    
    @objc func dismissKeyboard() {
        view.endEditing(true)
    }
}
