//
//  CreateTimeSlotViewController.swift
//  Street-FootBall
//
//  Created by Khanh Nguyen on 7/13/17.
//  Copyright © 2017 Khanh Nguyen. All rights reserved.
//

import UIKit
import Alamofire

class CreateTimeSlotViewController: UIViewController {

    @IBOutlet weak var tfPrice: UITextField!
    @IBOutlet weak var tfTimeEnd: UITextField!
    @IBOutlet weak var tfTimeStart: UITextField!
    @IBOutlet weak var tvPriceBoard: UITextView!

    
    var pitchID = 0
    var arrPriceBoard = [""]
    var index = 1
    
    override func viewDidLoad() {
        super.viewDidLoad()
         navigationController?.setNavigationBarHidden(true, animated: false)
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func btnBackClick(_ sender: Any) {
       
    }
    
    @IBAction func btnAddClick(_ sender: Any) {
        let priceHour = "\(tfTimeStart.text!)h" + " - " + "\(tfTimeEnd.text!)h" + " : " + "\(tfPrice.text!) Đ" + "\n"
        arrPriceBoard.append(priceHour)
        tvPriceBoard.text! = "\(tvPriceBoard.text!)" + arrPriceBoard[index]
        index = index + 1
        
        let parameters = [
            "pitch_id" : "\(pitchID)",
            "fromTime"  : "\((tfTimeStart.text)!))",
            "toTime": "\((tfTimeEnd.text)!)",
            "pitchPrice" : "\((self.tfPrice.text)!)",
        ]
        
        print(parameters)
        Alamofire.request( "http://fooco.esy.es/public/api/pitch/add-time-slot.php" , method: .post, parameters: parameters, encoding: URLEncoding.default).log(level: .all, options: [.onlyDebug, .jsonPrettyPrint, .includeSeparator])
            .responseJSON { (response) in
                
                if let statusCode = response.response?.statusCode {
                    print("STATUS CODE \(statusCode)")
                }
                
                switch response.result {
                case .failure(let error) :
                    print(error)
                case .success(let responseObject):
                    print("Thanh Cong")
                    self.tfTimeStart.text = ""
                    self.tfTimeEnd.text = ""
                    self.tfPrice.text = ""
                    
                }
        }
        
    }
}




