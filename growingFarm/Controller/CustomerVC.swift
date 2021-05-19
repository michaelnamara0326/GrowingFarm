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
//import MapKit
import Firebase
class CustomerVC:UIViewController, CLLocationManagerDelegate{
    var lat:CLLocationDegrees=0
    var long:CLLocationDegrees=0
    var locationManager=CLLocationManager()
    override func viewDidLoad() {
        self.locationManager.requestAlwaysAuthorization()
        
        // For use in foreground
        self.locationManager.requestWhenInUseAuthorization()
        
        if CLLocationManager.locationServicesEnabled() {
            locationManager.delegate = self
            locationManager.desiredAccuracy = kCLLocationAccuracyNearestTenMeters
            locationManager.startUpdatingLocation()
        }
        reverseGeocodeUserLocation()
        
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        guard let locValue: CLLocationCoordinate2D = manager.location?.coordinate else { return }
        self.lat=locValue.latitude
        self.long=locValue.longitude
        print(locValue.latitude)
        print(locValue.longitude)
    }
    
    
    @IBAction func signoutButton(_ sender: UIButton) {
        let firebaseAuth = Auth.auth()
        do {
            try firebaseAuth.signOut()
        } catch let signOutError as NSError {
            print ("Error signing out: %@", signOutError)
        }
        locationManager.stopUpdatingLocation()
        performSegue(withIdentifier: "customerToMain", sender: self)
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
    }
    func reverseGeocodeUserLocation(){
        let geocoder=CLGeocoder()
        var location=CLLocation(latitude: 24.998966, longitude: 121.558004)
        geocoder.reverseGeocodeLocation(location,preferredLocale: Locale.init(identifier: "zh-tw")) { placemarks, Error in
            
            var placeMark: CLPlacemark!
            placeMark = placemarks?[0]
            print(placemarks?.first)
            print(placeMark.administrativeArea)
        }
    }
 
}
