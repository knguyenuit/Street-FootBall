//
//  PitchInfoMakerViewController.swift
//  Street-FootBall
//
//  Created by Khanh Nguyen on 7/11/17.
//  Copyright © 2017 Khanh Nguyen. All rights reserved.
//

import UIKit
import Kingfisher

class PitchInfoMakerViewController: UIViewController {

    @IBOutlet weak var ivPitchAvatar: UIImageView!
    @IBOutlet weak var lbPitchName: UILabel!
    @IBOutlet weak var lbPitchAddress: UILabel!
    @IBOutlet weak var lbPitchPhone: UILabel!
    @IBOutlet weak var btnOrderPitch: UIButton!
    
    var name: String?
    var address: String?
    var phone: String?
    
    var avatar: String?
    
    override func viewDidLoad() {
        
        super.viewDidLoad()
       
       // print(avatar!)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        print(name)
        lbPitchName.text = name
        lbPitchAddress.text = address
        lbPitchPhone.text = phone
        let url = URL(string: avatar!)
        ivPitchAvatar.kf.setImage(with: url)

    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func btnPitchDetailClick(_ sender: Any) {
        
    }
    
    @IBAction func btnOrderPitchClick(_ sender: Any) {
      
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
