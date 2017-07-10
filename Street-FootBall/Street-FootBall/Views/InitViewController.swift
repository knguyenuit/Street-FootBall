//
//  InitViewController.swift
//  Street-FootBall
//
//  Created by Khanh Nguyen on 6/29/17.
//  Copyright © 2017 Khanh Nguyen. All rights reserved.
//

import UIKit

import UIKit

class InitViewController: UIViewController {
    
 
    @IBOutlet weak var btnPlayer: UIButton!
    @IBOutlet weak var btnPitchOwner: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        customButton(button: btnPitchOwner)
        customButton(button: btnPlayer)
//        Net.shared.getPitch().continueWith { (task) -> Void in
//            if task.error != nil {
//                //
//            } else {
//                if let result = task.result as? [Pitch] {
//                    //khi thanh cong gio cast ve va reload lai data cua table view
//                    result.forEach({ (pitch) in
//                        Pitch.listPitch.append(pitch)
//                    })
//                    print("-------- Load xong ALL LIST PITCH")
//                }
//            }
//
//            
//        }
//        
//        Net.shared.getPitchByDistrict(id: 2).continueWith { (task) -> Void in
//            if task.error != nil {
//                //
//            } else {
//                if let result = task.result as? [Pitch] {
//                    //khi thanh cong gio cast ve va reload lai data cua table view
//                    result.forEach({ (pitch) in
//                        Pitch.listPitchByDistrict.append(pitch)
//                    })
//                    print("-------- Load xong ALL LIST PITCH BY DISTRICT")
//                }
//            }
//            
//            
//        }
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
