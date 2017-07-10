//
//  PitchMapViewController.swift
//  Street-FootBall
//
//  Created by Khanh Nguyen on 6/27/17.
//  Copyright © 2017 Khanh Nguyen. All rights reserved.
//

import UIKit
import GoogleMaps
import GooglePlaces
import CoreLocation


class ListPitchMapViewController: UIViewController, CLLocationManagerDelegate, GMSMapViewDelegate  {
    
    @IBOutlet weak var vMap: UIView!
    @IBOutlet weak var lable: UILabel!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var addressLabel: UILabel!
    
    var location = ""
    let locationManager = CLLocationManager()
    var latitude = 0.0
    var longitude = 0.0
    var coordinate = CGPoint(x: 0, y: 0)
    var mapView: GMSMapView!
    var myLocation:CLLocationCoordinate2D?
    var placesClient: GMSPlacesClient!
    var geocoder = CLGeocoder()
    
    override func viewDidLoad() {
        mapView.delegate = self
        self.locationManager.delegate = self
    }
    
    override func viewDidAppear(_ animated: Bool) {
        
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        
        let location = locations.last
        
        let camera = GMSCameraPosition.camera(withLatitude: (location?.coordinate.latitude)!, longitude: (location?.coordinate.longitude)!, zoom: 15.0)
        
        self.mapView?.animate(to: camera)
        
        self.locationManager.stopUpdatingLocation()

        //Finally stop updating location otherwise it will come again and again in this delegate
    }
    

    
    override func loadView() {
        super.loadView()
//        self.locationManager.requestAlwaysAuthorization()
//        self.locationManager.requestWhenInUseAuthorization()
//        if CLLocationManager.locationServicesEnabled() {
//            locationManager.delegate = self
//            locationManager.desiredAccuracy = kCLLocationAccuracyNearestTenMeters
//            locationManager.startUpdatingLocation()
//        }
//        placesClient = GMSPlacesClient.shared()
//        
//        placesClient.currentPlace(callback: { (placeLikelihoodList, error) -> Void in
//            if let error = error {
//                print("Pick Place error: \(error.localizedDescription)")
//                return
//            }
//            
//            if let placeLikelihoodList = placeLikelihoodList {
//                for likelihood in placeLikelihoodList.likelihoods {
//                    let place = likelihood.place
//                    print("Current Place name \(place.name) at likelihood \(likelihood.likelihood)")
//                    print("Current Place address \(place.formattedAddress)")
//                    print("Current Place attributions \(place.attributions)")
//                    print("Current PlaceID \(place.placeID)")
//                    self.latitude = (place.coordinate.latitude)
//                    self.longitude = place.coordinate.longitude
//                }
//            }
//        })

        
        mapView = GMSMapView(frame: view.bounds)
        vMap.addSubview(mapView)
        mapView.isMyLocationEnabled = true
        mapView.sizeToFit()
        self.locationManager.startUpdatingLocation()
        
        Net.shared.getPitch().continueWith { (task) -> Void in
            if task.error != nil {
                //
            } else {
                if let result = task.result as? [Pitch] {
                    //khi thanh cong gio cast ve va reload lai data cua table view
                    
                    DispatchQueue.main.async {
                        result.forEach({ (pitch) in
                            let marker = GMSMarker()
                            marker.position = CLLocationCoordinate2D(latitude: (pitch.location?.geoLocation?.lat)!
                                , longitude: (pitch.location?.geoLocation?.lng)!)
                            print(pitch.location?.geoLocation!)
                            marker.title = "\((pitch.location?.address)!)"
                            marker.snippet = "VietNam"
                            marker.icon = GMSMarker.markerImage(with: .green)
                            
                            marker.map = self.mapView
                        })
                    }
                    
                    
                }
            }
        }

      
        
        self.mapView.camera = GMSCameraPosition.camera(withLatitude: 10.871137, longitude: 106.796268, zoom: 15)
    }
    
//    func mapView(_ mapView: GMSMapView, didTap marker: GMSMarker) -> Bool {
//        print(marker.title)
//        return true
//    }
    
    
    func load() {
        super.viewDidLoad()
        self.locationManager.requestAlwaysAuthorization()
        self.locationManager.requestWhenInUseAuthorization()
        if CLLocationManager.locationServicesEnabled() {
            locationManager.delegate = self
            locationManager.desiredAccuracy = kCLLocationAccuracyNearestTenMeters
            locationManager.startUpdatingLocation()
        }
        placesClient = GMSPlacesClient.shared()
        
        placesClient.currentPlace(callback: { (placeLikelihoodList, error) -> Void in
            if let error = error {
                print("Pick Place error: \(error.localizedDescription)")
                return
            }
            
            if let placeLikelihoodList = placeLikelihoodList {
                for likelihood in placeLikelihoodList.likelihoods {
                    let place = likelihood.place
                    print("Current Place name \(place.name) at likelihood \(likelihood.likelihood)")
                    print("Current Place address \(place.formattedAddress)")
                    print("Current Place attributions \(place.attributions)")
                    print("Current PlaceID \(place.placeID)")
                    self.latitude = (place.coordinate.latitude)
                    self.longitude = place.coordinate.longitude
                }
            }
        })
    }
    
    func convertData(lat: Double, long: Double){
        self.latitude = lat
        self.longitude = long
    }
    
    
    
    @IBAction func btnBackClick(_ sender: Any) {
        navigationController?.popViewController(animated: true)
    }
    @IBAction func getCurrentPlace(_ sender: Any){
        placesClient.currentPlace(callback: { (placeLikelihoodList, error) -> Void in
            if let error = error {
                print("Pick Place error: \(error.localizedDescription)")
                return
            }
            self.nameLabel.text = "No current place"
            self.addressLabel.text = ""
            if let placeLikelihoodList = placeLikelihoodList {
                let place = placeLikelihoodList.likelihoods.first?.place
                if let place = place {
                    self.nameLabel.text = place.name
                    self.addressLabel.text = place.formattedAddress?.components(separatedBy: ", ")
                        .joined(separator: "\n")
                }
            }
        })
    }
}
