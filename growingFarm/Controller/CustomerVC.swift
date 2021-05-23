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

class CustomerVC:UIViewController, CLLocationManagerDelegate{
    var lat:CLLocationDegrees=0
    var long:CLLocationDegrees=0
    var locationManager=CLLocationManager()
    var customerInfo:[String:Any]=[:]
    var customerGameData:[String:Any]=[:]
    let db=Firestore.firestore()
    
    override func viewDidLoad() {
        locationManager.requestAlwaysAuthorization()
        locationManager.requestWhenInUseAuthorization()
        if CLLocationManager.locationServicesEnabled() {
            locationManager.delegate = self
            locationManager.desiredAccuracy=kCLLocationAccuracyHundredMeters
            locationManager.startUpdatingLocation()
        }
    }
    override func viewDidAppear(_ animated: Bool) {
        reverseGeocodeUserLocation()
//        locationAddress()
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
        print(customerGameData)
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
            }
        }
        locationManager.stopUpdatingLocation()
    }
}
