//
//  PitchDetailViewController.swift
//  Street-FootBall
//
//  Created by Khanh Nguyen on 6/26/17.
//  Copyright © 2017 Khanh Nguyen. All rights reserved.
//

import UIKit

class PitchDetailViewController: UIViewController {

    @IBOutlet weak var ivPitchAvatar: UIImageView!
    @IBOutlet weak var lbPitchName: UILabel!
    @IBOutlet weak var lbPitchAddress: UILabel!
    @IBOutlet weak var lbPitchPhone: UILabel!
    @IBOutlet weak var btnPitchAddress: UIButton!
    
    var pitchAvatar = ""
    var pitchName = ""
    var pitchAddress = ""
    var pitchPhone = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()
        lbPitchName.text = pitchName
        btnPitchAddress.setTitle(pitchAddress, for: .normal)
        lbPitchPhone.text = pitchPhone
        
        let imageUrl = NSURL(string: pitchAvatar)
        let data = NSData(contentsOf:imageUrl! as URL)
        ivPitchAvatar.image = UIImage(data: data! as Data)
        // Do any additional setup after loading the view.
        
        navigationController?.setNavigationBarHidden(false, animated: true)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    @IBAction func btnPitchAddressClick(_ sender: Any) {
        let vc = PitchMapViewController(nibName: "PitchMapViewController", bundle: nil)
        vc.location = (btnPitchAddress.titleLabel?.text!)!
        navigationController?.pushViewController(vc, animated: true)
    }
    
    @IBAction func btnBackClick(_ sender: Any) {
        navigationController?.popViewController(animated: true)
    }
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}