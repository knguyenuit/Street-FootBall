//
//  PitchOwnerProfileViewController.swift
//  Street-FootBall
//
//  Created by Khanh Nguyen on 6/29/17.
//  Copyright © 2017 Khanh Nguyen. All rights reserved.
//

import UIKit

class PitchOwnerProfileViewController: UIViewController {

    @IBOutlet weak var lbUserName: UILabel!
    @IBOutlet weak var lbEmail: UILabel!
    @IBOutlet weak var lbTotalPitch: UILabel!
    
    var pitchOwnerUserName = ""
    var pitchOwnerEmail = ""
    var pitchOwnerTotalPitch = 0
    var pitchOwnerID = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()
        lbUserName.text = pitchOwnerUserName
        lbEmail.text = pitchOwnerEmail
        navigationController?.setNavigationBarHidden(true, animated: false)
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func btnCreatePitchClick(_ sender: Any) {
        let vc = CreatePitchViewController(nibName: "CreatePitchViewController", bundle: nil)
        navigationController?.pushViewController(vc, animated: true)
    }
    
    @IBAction func btnSignOutClick(_ sender: Any) {
        NotificationCenter.default.post(name: NSNotification.Name(rawValue: "Logout"), object: nil)
    }

}
