//
//  ListPitchViewController.swift
//  Street-FootBall
//
//  Created by Khanh Nguyen on 6/21/17.
//  Copyright © 2017 Khanh Nguyen. All rights reserved.
//

import UIKit
import NVActivityIndicatorView
import Kingfisher

class ListPitchViewController: UIViewController, NVActivityIndicatorViewable {

    @IBOutlet weak var tblListPitch: UITableView!
    var pitchOwnerID = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tblListPitch.register(UINib(nibName: "ListPitchTableViewCell", bundle: nil), forCellReuseIdentifier: "ListPitchCell")
        tblListPitch.delegate = self
        tblListPitch.dataSource = self
        
        //an hien cai quay quay
        automaticallyAdjustsScrollViewInsets = false
        // Do any additional setup after loading the view.
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        if Pitch.listPitch.isEmpty{
            showActivity()
            
            if pitchOwnerID == 0 {
                DispatchQueue.global(qos: .default).async {
                    Net.shared.getPitch().continueWith { (task) -> Void in
                        self.stopAnimating(view: self.view)
                        if task.error != nil {
                            //
                        } else {
                            if let result = task.result as? [Pitch] {
                                //khi thanh cong gio cast ve va reload lai data cua table view
                                result.forEach({ (pitch) in
                                    Pitch.listPitch.append(pitch)
                                })
                                self.tblListPitch.reloadData()
                            }
                        }
                    }

                }
                
            } else {
            Net.shared.getPitchOwner(id: pitchOwnerID).continueWith { (task) -> Void in
                self.stopAnimating(view: self.view)
                if task.error != nil {
                    //
                } else {
                    if let result = task.result as? [Pitch] {
                        //khi thanh cong gio cast ve va reload lai data cua table view
                        result.forEach({ (pitch) in
                            Pitch.listPitch.append(pitch)
                        })
                        self.tblListPitch.reloadData()
                    }
                }
            }
        }
        }
    }

    override func viewWillDisappear(_ animated: Bool) {
        //Pitch.listPitch.removeAll()
    }
    
    
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func refreshPitch(pitch: [Pitch]){
        Pitch.listPitch = pitch
        print(Pitch.listPitch.count)
        tblListPitch.reloadData()
    }
    
    func showActivity() {
        
        self.startAnimating(view: self.view)
    }
    

}

/*
 // MARK: - Extension
 
*/

extension ListPitchViewController: UITableViewDelegate, UITableViewDataSource{
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return Pitch.listPitch.count
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 95.0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tblListPitch.dequeueReusableCell(withIdentifier: "ListPitchCell") as! ListPitchTableViewCell
        cell.lbPitchName.text = Pitch.listPitch[indexPath.row].name
        cell.lbPitchPhoneNumber.text = Pitch.listPitch[indexPath.row].phone
        cell.lbPitchAddress.text = Pitch.listPitch[indexPath.row].location?.address
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
        let pitch = Pitch.listPitch[indexPath.row]
        detailViewController.pitchName = pitch.name!
        detailViewController.pitchAddress = (pitch.location?.address)!
        detailViewController.pitchPhone = pitch.phone!
        detailViewController.pitchAvatar = pitch.avatar!
        detailViewController.lat = (pitch.location?.geoLocation?.lat)!
        detailViewController.lng = (pitch.location?.geoLocation?.lng)!
        detailViewController.priceBoard = pitch.timeSlot!
        
        tblListPitch.deselectRow(at: indexPath, animated: true)

        navigationController?.pushViewController(detailViewController, animated: true)
    }
}
