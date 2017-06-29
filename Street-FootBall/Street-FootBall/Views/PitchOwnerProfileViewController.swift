//
//  PitchOwnerProfileViewController.swift
//  Street-FootBall
//
//  Created by Khanh Nguyen on 6/29/17.
//  Copyright © 2017 Khanh Nguyen. All rights reserved.
//

import UIKit

class PitchOwnerProfileViewController: UIViewController {

    @IBOutlet weak var tfPitchOwnerUserName: UITextField!
    @IBOutlet weak var tfPitchOwnerEmail: UITextField!
    @IBOutlet weak var lbPitchOwnerTotalPitch: UILabel!
    
    var pitchOwnerUserName = ""
    var pitchOwnerEmail = ""
    var pitchOwnerTotalPitch = 0
    var pitchOwnerID = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tfPitchOwnerUserName.text = pitchOwnerUserName
        tfPitchOwnerEmail.text = pitchOwnerEmail
        
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

}
