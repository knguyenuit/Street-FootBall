//
//  SearchPitchViewController.swift
//  Street-FootBall
//
//  Created by Khanh Nguyen on 6/28/17.
//  Copyright © 2017 Khanh Nguyen. All rights reserved.
//

import UIKit
import NVActivityIndicatorView
import GoogleMaps
import GooglePlaces
import CoreLocation

class SearchPitchViewController: UIViewController, NVActivityIndicatorViewable, CLLocationManagerDelegate {

   
    @IBOutlet weak var pkDistrict: UIPickerView!
    @IBOutlet weak var tblListPitch: UITableView!
    @IBOutlet weak var btnDistrict: UIButton!
    var placesClient: GMSPlacesClient!
    let locationManager = CLLocationManager()
     var listPitch = [Pitch]()
    
    let pickerData = [
        ["Thủ Đức","Quận 9","Quận 1","Quận 2","Quận 3", "Quận 4","Quận 5","Quận 6","Quận 7", "Quận 8","Tân Bình","Quận 10","Quận 11","Quận 12", "Bình Thạnh","Gò Vấp", "Tân Phú", "Bình Tân"]
    ]

   
    override func viewDidLoad() {
        super.viewDidLoad()
        tblListPitch.register(UINib(nibName: "ListPitchTableViewCell", bundle: nil), forCellReuseIdentifier: "ListPitchCell")
        tblListPitch.delegate = self
        tblListPitch.dataSource = self
        pkDistrict.delegate = self
        pkDistrict.dataSource = self
        pkDistrict.isHidden = true
       
        self.locationManager.requestAlwaysAuthorization()
        self.locationManager.requestWhenInUseAuthorization()
        if CLLocationManager.locationServicesEnabled() {
            locationManager.delegate = self
            locationManager.desiredAccuracy = kCLLocationAccuracyNearestTenMeters
            locationManager.startUpdatingLocation()
        }
        placesClient = GMSPlacesClient.shared()
        
        Pitch.listPitch.removeAll()
        Net.shared.getPitch().continueWith { (task) -> Void in
            self.stopAnimating(view: self.view)
            if task.error != nil {
                //
            } else {
                if let result = task.result as? [Pitch] {
                    result.forEach({ (pitch) in
                        print(pitch.name!)
                        self.listPitch.append(pitch)
                    })
                    print(self.listPitch.count)
                }
            }
        }
        // Do any additional setup after loading the view.
    }

    override func viewDidAppear(_ animated: Bool) {
         navigationController?.setNavigationBarHidden(true, animated: false)
        if Pitch.listPitchByDistrict.isEmpty {
        Net.shared.getPitchByDistrict().continueWith { (task) -> Void in
            
            if task.error != nil {
                //
            } else {
                if let result = task.result as? [Pitch] {
                    self.tblListPitch.reloadData()
                }
            }
        }
        }
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func loadListPitchByDistrict(i: Int) {
        Pitch.listPitchByDistrict.removeAll()
        showActivity()
        Net.shared.getPitchByDistrict(id: i).continueWith { (task) -> Void in
            self.stopAnimating(view: self.view)
            if task.error != nil {
                //
            } else {
                if let result = task.result as? [Pitch] {
                 
                    self.tblListPitch.reloadData()
                }
            }
        }
    }
    
    func load() {

        placesClient.currentPlace(callback: { (placeLikelihoodList, error) -> Void in
            if let error = error {
                print("Pick Place error: \(error.localizedDescription)")
                return
            }
            if let placeLikelihoodList = placeLikelihoodList {
                let likelihood = placeLikelihoodList.likelihoods.first
                let place = likelihood?.place
                print(likelihood?.place.addressComponents)
                let coordinate1 = CLLocation(latitude: (place?.coordinate.latitude)!, longitude: (place?.coordinate.longitude)!)
                self.listPitch.forEach({ (pitch) in
                    let coordinate2 = CLLocation(latitude: (pitch.location?.geoLocation?.lat)!, longitude: (pitch.location?.geoLocation?.lng)!)
                    let a = Int(coordinate1.distance(from: coordinate2))
                    if a < 3000 {
                        print("\(pitch.name) : \(a)")
                        Pitch.listPitchByDistrict.append(pitch)
                    }
                
                    
                                        
            })
                self.tblListPitch.reloadData()

//                for likelihood in placeLikelihoodList.likelihoods {
//                    let place = likelihood.place
//                    let coordinate1 = CLLocation(latitude: place.coordinate.latitude, longitude: place.coordinate.longitude)
//                    self.listPitch.forEach({ (pitch) in
//                        let coordinate2 = CLLocation(latitude: (pitch.location?.geoLocation?.lat)!, longitude: (pitch.location?.geoLocation?.lng)!)
//                        let a = Int(coordinate1.distance(from: coordinate2))
//                        
//                       
//                            print("\(pitch.name!) : \(a)")
//                        
//                    })
//                    self.tblListPitch.reloadData()
//                    return
//                }
            }
        })
    }

    
    func refreshPitch(pitch: [Pitch]){
        Pitch.listPitchByDistrict = pitch
        tblListPitch.reloadData()
    }
    
    func showActivity() {
        self.startAnimating(view: self.view)
    }
    
    @IBAction func btnDistrictClick(_ sender: Any) {
         pkDistrict.isHidden = false
    }
    
    @IBAction func btnFindNearByClick(_ sender: Any) {
        Pitch.listPitchByDistrict.removeAll()
        load()
    }
    
    @IBAction func btnBackClick(_ sender: Any) {
        (UIApplication.shared.delegate as! AppDelegate).navigation?.popViewController(animated: true)
    }
    

}

extension SearchPitchViewController: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return Pitch.listPitchByDistrict.count
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 95.0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tblListPitch.dequeueReusableCell(withIdentifier: "ListPitchCell") as! ListPitchTableViewCell
        cell.lbPitchName.text = Pitch.listPitchByDistrict[indexPath.row].name
        cell.lbPitchPhoneNumber.text = Pitch.listPitchByDistrict[indexPath.row].phone
        cell.lbPitchAddress.text = Pitch.listPitchByDistrict[indexPath.row].location?.address
        cell.lbPitchCount.text = "5 Sân"
        let url = URL(string: Pitch.listPitch[indexPath.row].avatar!)
        cell.ivPitchAvatar.kf.setImage(with: url)
        
        cell.contentView.backgroundColor = UIColor.clear
        let whiteRoundedView : UIView = UIView(frame: CGRect(x: 10, y: 0, width: self.view.frame.size.width - 20, height: 85))
        whiteRoundedView.layer.backgroundColor = CGColor(colorSpace: CGColorSpaceCreateDeviceRGB(), components: [1.0, 1.0, 1.0, 0.9])
        whiteRoundedView.layer.masksToBounds = false
        whiteRoundedView.layer.cornerRadius = 10
        whiteRoundedView.layer.shadowOffset = CGSize(width: 0, height: 5)
        whiteRoundedView.layer.shadowOpacity = 0.15
        cell.contentView.addSubview(whiteRoundedView)
        cell.contentView.sendSubview(toBack: whiteRoundedView)
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let detailViewController = PitchDetailViewController(nibName: "PitchDetailViewController", bundle: nil)
        let pitch = Pitch.listPitchByDistrict[indexPath.row]
        detailViewController.pitchName = pitch.name!
        detailViewController.pitchAddress = (pitch.location?.address)!
        detailViewController.pitchPhone = pitch.phone!
        detailViewController.pitchAvatar = pitch.avatar!
        detailViewController.priceBoard = pitch.timeSlot!
        
        tblListPitch.deselectRow(at: indexPath, animated: true)
        
        navigationController?.pushViewController(detailViewController, animated: true)
    }
}

extension SearchPitchViewController: UIPickerViewDataSource,UIPickerViewDelegate {
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return pickerData.count
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return pickerData[component].count
    }
    func pickerView(_
        pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int
        ) -> String? {
        return pickerData[component][row]
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        let location = pickerData[0][pkDistrict.selectedRow(inComponent: 0)]
        btnDistrict.setTitle(location, for: .normal)
        pkDistrict.isHidden = true
        loadListPitchByDistrict(i: pkDistrict.selectedRow(inComponent: 0) + 2)
    }

}
