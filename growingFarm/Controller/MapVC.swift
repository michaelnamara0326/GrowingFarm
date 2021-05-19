//
//  MapScreen.swift
//  User-Location
//
//  Created by Sean Allen on 8/24/18.
//  Copyright © 2018 Sean Allen. All rights reserved.
//

import UIKit
import MapKit
import CoreLocation
import Firebase
class MapVC: UIViewController {
    
    @IBOutlet weak var mapView: MKMapView!
    
    let locationManager = CLLocationManager()
    let regionInMeters: Double = 10000
    var farmerAddress:[String]=[]
    let db=Firestore.firestore()
    override func viewDidLoad() {
        super.viewDidLoad()
        getFarmerAddress()
        checkLocationServices()
        
        }
    @IBAction func press(_ sender: UIButton) {
        print(farmerAddress)
        farmerAddressAnnoation(farmerAddress)
    }
    func farmerAddressAnnoation(_ farmerAddress:[String]){
        for address in farmerAddress{
            coordinates(forAddress: address) { location in
                guard let location = location else {
                        // Handle error here.
                        return
                    }
                self.openMapForPlace(lat: location.latitude, long: location.longitude)
                }
        }
        
    }
    func getFarmerAddress() {
        db.collection("farmer").getDocuments() {  (querySnapshot, err) in
            if let err = err {
                print("Error getting customer email: \(err)")
            } else {
                for document in querySnapshot!.documents {
                    self.farmerAddress.append(document.get("address") as! String)
                }
            }
        }
       
    }
    func openMapForPlace(lat:CLLocationDegrees,long:CLLocationDegrees){
        let annotation=MKPointAnnotation()
        annotation.coordinate=CLLocationCoordinate2D(latitude: lat, longitude: long)
        mapView.addAnnotation(annotation)
    }
    
    func coordinates(forAddress address: String, completion: @escaping (CLLocationCoordinate2D?) -> Void) {
        let geocoder = CLGeocoder()
        geocoder.geocodeAddressString(address) {
            (placemarks, error) in
            guard error == nil else {
                print("Geocoding error: \(error!)")
                completion(nil)
                return
            }
            completion(placemarks?.first?.location?.coordinate)
        }
    }

    func setupLocationManager() {
        locationManager.delegate = self
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
        locationManager.startUpdatingLocation()
    }
    
    
    func centerViewOnUserLocation() {
        if let location = locationManager.location?.coordinate {
            let region = MKCoordinateRegion.init(center: location, latitudinalMeters: regionInMeters, longitudinalMeters: regionInMeters)
            mapView.setRegion(region, animated: true)
        }
    }
    
    
    func checkLocationServices() {
        if CLLocationManager.locationServicesEnabled() {
            setupLocationManager()
            checkLocationAuthorization()
        } else {
            // Show alert letting the user know they have to turn this on.
        }
    }
    
    
    func checkLocationAuthorization() {
        switch CLLocationManager.authorizationStatus() {
        case .authorizedWhenInUse:
            mapView.showsUserLocation = true
           // centerViewOnUserLocation()
            locationManager.startUpdatingLocation()
            break
        case .denied:
            // Show alert instructing them how to turn on permissions
            break
        case .notDetermined:
            locationManager.requestWhenInUseAuthorization()
        case .restricted:
            // Show an alert letting them know what's up
            break
        case .authorizedAlways:
            break
        }
    }
}


extension MapVC: CLLocationManagerDelegate {
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        guard let location = locations.last else { return }
        let region = MKCoordinateRegion.init(center: location.coordinate, latitudinalMeters: regionInMeters, longitudinalMeters: regionInMeters)
        mapView.setRegion(region, animated: true)
    }
    
    
    func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
        checkLocationAuthorization()
    }
}
