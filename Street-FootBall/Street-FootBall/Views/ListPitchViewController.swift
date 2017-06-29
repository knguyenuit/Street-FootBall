//
//  ListPitchViewController.swift
//  Street-FootBall
//
//  Created by Khanh Nguyen on 6/21/17.
//  Copyright © 2017 Khanh Nguyen. All rights reserved.
//

import UIKit

class ListPitchViewController: UIViewController {

    @IBOutlet weak var tblListPitch: UITableView!
    var pitchOwnerID = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tblListPitch.register(UINib(nibName: "ListPitchTableViewCell", bundle: nil), forCellReuseIdentifier: "ListPitchCell")
        tblListPitch.delegate = self
        tblListPitch.dataSource = self
        
        automaticallyAdjustsScrollViewInsets = false
        // Do any additional setup after loading the view.
    }
    
    override func viewDidAppear(_ animated: Bool) {
        if pitchOwnerID == 0 {
            Net.shared.getPitch(success: refreshPitch)
        } else {
            Net.shared.getPitchOwner(id: GlobalVariable.pitchOwnerID, success: refreshPitch)
        }
    }

    override func viewWillDisappear(_ animated: Bool) {
        Pitch.listPitch.removeAll()
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
        cell.lbPitchAddress.text = Pitch.listPitch[indexPath.row].location
        cell.lbPitchCount.text = "5 Sân"
        let imageUrl = NSURL(string: Pitch.listPitch[indexPath.row].avatar!)
        let data = NSData(contentsOf:imageUrl! as URL)
        cell.ivPitchAvatar.image = UIImage(data: data! as Data)
        
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
        detailViewController.pitchAddress = pitch.location!
        detailViewController.pitchPhone = pitch.phone!
        detailViewController.pitchAvatar = pitch.avatar!
        
        tblListPitch.deselectRow(at: indexPath, animated: true)

        navigationController?.pushViewController(detailViewController, animated: true)
    }
}
