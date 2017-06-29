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


class PitchMapViewController: UIViewController, CLLocationManagerDelegate  {
    
    @IBOutlet weak var lable: UILabel!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var addressLabel: UILabel!
    @IBOutlet weak var vMap: UIView!
    var location = ""
    let locationManager = CLLocationManager()
    var latitude = 0.0
    var longitude = 0.0
    var coordinate = CGPoint(x: 0, y: 0)
    var mapView: GMSMapView!
    var myLocation:CLLocationCoordinate2D?
    var placesClient: GMSPlacesClient!
    
    override func viewDidLoad() {
        
    }
    
    override func viewDidAppear(_ animated: Bool) {
        
    }
    
    override func loadView() {
        super.loadView()
        mapView = GMSMapView(frame: view.bounds)
        vMap.addSubview(mapView)
        Net.shared.getCoordinateLocation(location: location) { (lat, long) in
            print("latitude: " + "\(lat)")
            print("long: " + "\(long)")
            let marker = GMSMarker()
            marker.position = CLLocationCoordinate2D(latitude: lat, longitude: long)
            marker.title = "Sydney"
            marker.snippet = "Australia"
            marker.map = self.mapView
            self.mapView.camera = GMSCameraPosition.camera(withLatitude: lat, longitude: long, zoom: 15)
        }
    }
    
    func convertData(lat: Double, long: Double){
        self.latitude = lat
        self.longitude = long
    }
    
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
