import UIKit
import MapKit
import CoreLocation
import Firebase
import Cluster
class MapVC: UIViewController {
    @IBOutlet weak var mapView: MKMapView!
    
    let locationManager = CLLocationManager()
    let regionInMeters: Double = 5000
    let db=Firestore.firestore()
    let clusterManager=ClusterManager()
    //    var newFarmer:[[String:String]]=[]
    override func viewDidLoad() {
        super.viewDidLoad()
        mapView.showsUserLocation=true
        mapView.delegate=self
        //        UserDefaults.standard.object(forKey: "pinStored")
        //        getFarmerAddress()
        //        checkLocationServices()
        //        addNewFarmerAnnotation()
        //        centerViewOnUserLocation()
        centerViewOnUserLocation()
        //        listenFarmer()
    }
    
    @IBAction func backBtnPressed(_ sender: UIButton) {
        dismiss(animated: true,completion: nil)
    }
 
    func farmerAddressAnnoation(_ farmerAddress:String, _ farmerName:String, _ farmerDocumentID:String){
        coordinates(forAddress: farmerAddress) { location in
            guard let location = location else {
                // Handle error here.
                return
            }
            self.openMapForPlace(farmerName: farmerName, farmerLat: location.latitude, farmerLong: location.longitude)
            self.updateFarmerIsAdded(farmerDocumentID)
        }
    }
    func openMapForPlace(farmerName name:String,farmerLat lat:CLLocationDegrees,farmerLong long:CLLocationDegrees){
        let annotation=MKPointAnnotation()
        annotation.coordinate=CLLocationCoordinate2D(latitude: lat, longitude: long)
        annotation.title=name
//        clusterManager.add(annotation)
//        clusterManager.reload(mapView: mapView)
        mapView.addAnnotation(annotation)
        print("add annotation success")
    }
    func updateFarmerIsAdded(_ documentID:String){
        let farmerRef=db.collection("farmer").document(documentID)
        farmerRef.updateData(["isAdded":true])
    }
    func listenFarmer(){
        db.collection("leisurefarm")
            .whereField("isVerified", isEqualTo: true)
            .addSnapshotListener { querySnapshot, error in
                guard let snapshot = querySnapshot else {
                    print("Error fetching snapshots: \(error!)")
                    return
                }
                snapshot.documentChanges.forEach { diff in
                    if (diff.type == .added) {
                        let add=diff.document.data()
                        let farmerAddress=add["address"] as! String
                        let farmerName=add["name"] as! String
                        let farmerDocumentID=diff.document.documentID
                        print("New farmer: \(add)")
                        self.farmerAddressAnnoation(farmerAddress, farmerName, farmerDocumentID)
                    }
                    if (diff.type == .modified) {
                        print("Modified famer: \(diff.document.data())")
                    }
                    if (diff.type == .removed) {
                        print("Removed city: \(diff.document.data())")
                    }
                }
            }
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
    
    func centerViewOnUserLocation() {
        if let location = locationManager.location?.coordinate {
            let region = MKCoordinateRegion.init(center: location, latitudinalMeters: regionInMeters, longitudinalMeters: regionInMeters)
            mapView.setRegion(region, animated: true)
        }
    }
    
}


extension MapVC: CLLocationManagerDelegate {
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        guard let location = locations.last else { return }
        let region = MKCoordinateRegion.init(center: location.coordinate, latitudinalMeters: regionInMeters, longitudinalMeters: regionInMeters)
        mapView.setRegion(region, animated: true)
    }

}
extension MapVC:MKMapViewDelegate{
    func mapView(_ mapView: MKMapView, didSelect view: MKAnnotationView) {
        print("select")
        let targetPlaceMark=MKPlacemark(coordinate: view.annotation!.coordinate)
        let targetItem=MKMapItem(placemark: targetPlaceMark)
        let userMapItem=MKMapItem.forCurrentLocation()
        let routes=[userMapItem,targetItem]
        MKMapItem.openMaps(with: routes, launchOptions: [MKLaunchOptionsDirectionsModeKey:MKLaunchOptionsDirectionsModeDriving])
        
    }
    func mapViewWillStartLoadingMap(_ mapView: MKMapView) {
        listenFarmer()
    }
}
