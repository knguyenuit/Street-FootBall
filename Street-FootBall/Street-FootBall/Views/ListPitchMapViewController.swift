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
import NVActivityIndicatorView

class ListPitchMapViewController: UIViewController, CLLocationManagerDelegate, GMSMapViewDelegate, NVActivityIndicatorViewable  {
    
    @IBOutlet weak var vMap: UIView!
    @IBOutlet weak var lable: UILabel!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var addressLabel: UILabel!
    @IBOutlet weak var lbMakerLocation: UILabel!
    
    
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
        showActivity()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        navigationController?.setNavigationBarHidden(true, animated: false)
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        
        //update location to my location
        
        let location = locations.last
        
        let camera = GMSCameraPosition.camera(withLatitude: (location?.coordinate.latitude)!, longitude: (location?.coordinate.longitude)!, zoom: 15.0)
        
        
        self.mapView?.animate(to: camera)
        
        self.locationManager.stopUpdatingLocation()

       
    }
    
    func mapView(_ mapView: GMSMapView, didTapInfoWindowOf marker: GMSMarker) {
        let detailViewController = PitchDetailViewController(nibName: "PitchDetailViewController", bundle: nil)
        let pitch = marker.userData as! Pitch
        detailViewController.pitchName = pitch.name!
        detailViewController.pitchAddress = (pitch.location?.address)!
        detailViewController.pitchPhone = pitch.phone!
        detailViewController.pitchAvatar = pitch.avatar!
        detailViewController.lat = (pitch.location?.geoLocation?.lat)!
        detailViewController.lng = (pitch.location?.geoLocation?.lng)!
        detailViewController.priceBoard = pitch.timeSlot!
        
        
        navigationController?.pushViewController(detailViewController, animated: true)

    }
    
    override func loadView() {
        super.loadView()
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
                   self.stopAnimating(view: self.view)
                    DispatchQueue.main.async {
                        result.forEach({ (pitch) in
                            let marker = GMSMarker()
                            marker.position = CLLocationCoordinate2D(latitude: (pitch.location?.geoLocation?.lat)!
                                , longitude: (pitch.location?.geoLocation?.lng)!)
                            marker.title = "\((pitch.location?.address)!)"
                            //marker.snippet = "VietNam"
                            marker.icon = #imageLiteral(resourceName: "icons8-Stadiumpng")
                            marker.tracksInfoWindowChanges = true
                            self.mapView.selectedMarker = marker
                            marker.map = self.mapView
                            
                            marker.userData = pitch
                        })
                    }
                    
                    
                }
            }
        }

      
        
        self.mapView.camera = GMSCameraPosition.camera(withLatitude: 10.871137, longitude: 106.796268, zoom: 15)
    }
    
    func mapView(_ mapView: GMSMapView, markerInfoWindow marker: GMSMarker) -> UIView? {
        
        let vc = PitchInfoMakerViewController(nibName: "PitchInfoMakerViewController", bundle: nil)
        let info = vc.view
        let pitch = marker.userData as! Pitch
        vc.name = pitch.name!
        vc.address = pitch.location?.address
        vc.avatar = pitch.avatar
        vc.phone = pitch.phone
        vc.btnOrderPitch.addTarget(self, action: #selector(buttonTapped(_:)), for: .touchUpInside)
       
        
        return info
        
    }
    
    func showActivity() {
        self.startAnimating(view: self.view)
    }

    
    func buttonTapped(_ sender: UIButton!) {
        print("Yeah! Button is tapped!")
    }
    
    @IBAction func btnBackClick(_ sender: Any) {
        (UIApplication.shared.delegate as! AppDelegate).navigation?.popViewController(animated: true)
    }
    
}


