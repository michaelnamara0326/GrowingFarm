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
    var farmerArr:[String]=[]
    var marketArr:[String]=[]
    var resturantArr:[String]=[]
    var leisurefarmArr:[String]=[]
    var routes:[MKMapItem]=[]
    //    var newFarmer:[[String:String]]=[]
    override func viewDidLoad() {
        super.viewDidLoad()
        mapView.showsUserLocation=true
        mapView.delegate=self
        centerViewOnUserLocation()
        //        listenFarmer()
    }
    
    @IBAction func backBtnPressed(_ sender: UIButton) {
        dismiss(animated: true,completion: nil)
    }
    @IBAction func filterPressed(_ sender:UIButton){
       return
    }
    func farmerAddressAnnoation(_ farmerAddress:String, _ farmerName:String){
        coordinates(forAddress: farmerAddress) { location in
            guard let location = location else {
                // Handle error here.
                return
            }
            self.openMapForPlace(farmerName: farmerName, farmerLat: location.latitude, farmerLong: location.longitude)
        }
    }
    func openMapForPlace(farmerName name:String,farmerLat lat:CLLocationDegrees,farmerLong long:CLLocationDegrees){
        let annotation=MKPointAnnotation()
        annotation.coordinate=CLLocationCoordinate2D(latitude: lat, longitude: long)
        annotation.title=name
        mapView.addAnnotation(annotation)
        print("add annotation success")
    }

    func listenFarmer(category:String){
        db.collection(category).whereField("isVerified", isEqualTo: true).getDocuments { querySnapshot, error in
            if let err=error{
                print(err)
            }
            else{
                for document in querySnapshot!.documents{
                    let farmerAddress=document.data()["address"] as! String
                    let farmerName=document.data()["name"] as! String
                    switch category{
                    case "farmer":
                        self.farmerArr.append(farmerName)
                    case "market":
                        self.marketArr.append(farmerName)
                    case "restaurant":
                        self.resturantArr.append(farmerName)
                    default:
                        self.leisurefarmArr.append(farmerName)
                    }
                    self.farmerAddressAnnoation(farmerAddress, farmerName)
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
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let vc=segue.destination as! FarmerIntroVC
        vc.route=routes
    }
}


extension MapVC: CLLocationManagerDelegate {
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        guard let location = locations.last else { return }
        let region = MKCoordinateRegion.init(center: location.coordinate, latitudinalMeters: regionInMeters, longitudinalMeters: regionInMeters)
        mapView.setRegion(region, animated: true)
    }

}
extension MapVC:MKMapViewDelegate {
    func mapView(_ mapView: MKMapView, didSelect view: MKAnnotationView) {
        let name=view.annotation?.title! ?? ""
        if farmerArr.contains(name){
            FetchData().getFarmInfo(category:"farmer", name: name)
        }
        else if marketArr.contains(name){
            FetchData().getFarmInfo(category:"market", name: name)
        }
        else if resturantArr.contains(name){
            FetchData().getFarmInfo(category:"restaurant", name: name)
        }
        else{
            FetchData().getFarmInfo(category:"leisurefarm", name: name)
        }
        let targetPlaceMark=MKPlacemark(coordinate: view.annotation!.coordinate)
        let targetItem=MKMapItem(placemark: targetPlaceMark)
        let userMapItem=MKMapItem.forCurrentLocation()
        routes=[userMapItem,targetItem]
        
        DispatchQueue.main.asyncAfter(deadline: .now()+1){
            self.performSegue(withIdentifier: "mapToFarmerIntro", sender: self)
        }
        
    }
    func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
        
        let annotationView = MKMarkerAnnotationView(annotation: annotation, reuseIdentifier: "MyMarker")
        
        if annotation is MKUserLocation {
            return nil
        }
        else{
            if farmerArr.contains(annotation.title!!){
                annotationView.markerTintColor = #colorLiteral(red: 0.2588235438, green: 0.7568627596, blue: 0.9686274529, alpha: 1)
                annotationView.glyphImage=UIImage(named: "farmer")
            }
            else if marketArr.contains(annotation.title!!){
                annotationView.markerTintColor = #colorLiteral(red: 0.9349918962, green: 0.3118436337, blue: 0.3081356585, alpha: 1)
                annotationView.glyphImage=UIImage(named: "market")
            }
            else if resturantArr.contains(annotation.title!!){
                annotationView.markerTintColor = #colorLiteral(red: 0.9665998816, green: 0.6432610154, blue: 0.2488057911, alpha: 1)
                annotationView.glyphImage=UIImage(named: "restaurant")
            }
            else{
                annotationView.markerTintColor = #colorLiteral(red: 0.6217060685, green: 0.8996583223, blue: 0.6259074807, alpha: 1)
                annotationView.glyphImage=UIImage(named: "farm")
            }
        }
        return annotationView
    }
    func mapViewWillStartLoadingMap(_ mapView: MKMapView) {
        listenFarmer(category: "farmer")
        listenFarmer(category: "market")
        listenFarmer(category: "restaurant")
        listenFarmer(category: "leisurefarm")
    }
}
//    func listenFarmer(){
//        db.collection("leisurefarm")
//            .whereField("isVerified", isEqualTo: true)
//            .addSnapshotListener { querySnapshot, error in
//                guard let snapshot = querySnapshot else {
//                    print("Error fetching snapshots: \(error!)")
//                    return
//                }
//                snapshot.documentChanges.forEach { diff in
//                    if (diff.type == .added) {
//                        let add=diff.document.data()
//                        let farmerAddress=add["address"] as! String
//                        let farmerName=add["name"] as! String
//                        print("New farmer: \(add)")
//                        self.farmerAddressAnnoation(farmerAddress, farmerName)
//                    }
//                    if (diff.type == .modified) {
//                        print("Modified famer: \(diff.document.data())")
//                    }
//                    if (diff.type == .removed) {
//                        print("Removed city: \(diff.document.data())")
//                    }
//                }
//            }
//    }
