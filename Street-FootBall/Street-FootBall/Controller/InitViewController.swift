//
//  InitViewController.swift
//  Street-FootBall
//
//  Created by Khanh Nguyen on 6/20/17.
//  Copyright © 2017 Khanh Nguyen. All rights reserved.
//

import UIKit

class InitViewController: UIViewController {

    @IBOutlet weak var btnPitchOwner: UIButton!
    @IBOutlet weak var btnPlayer: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        customButton(button: btnPitchOwner)
        customButton(button: btnPlayer)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func btnShowPitchOwnerLogin(_ sender: Any) {
        let VC = PitchOwnerLoginViewController(nibName: "PitchOwnerLoginViewController", bundle: nil)
        navigationController?.pushViewController(VC, animated: true)
//        show(VC, sender: nil)
    }
    
    @IBAction func btnPlayerClick(_ sender: Any) {
        let vc = TabbarViewController(nibName: "TabbarViewController", bundle: nil)
        navigationController?.pushViewController(vc, animated: true)
    }
    func customButton(button: UIButton){
        button.layer.cornerRadius = 0.5 * button.bounds.size.width
        button.clipsToBounds = true
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
