//
//  UserOderPitchViewController.swift
//  Street-FootBall
//
//  Created by Khanh Nguyen on 7/10/17.
//  Copyright © 2017 Khanh Nguyen. All rights reserved.
//

import UIKit
import Alamofire

class UserOderPitchViewController: UIViewController {

    
    @IBOutlet weak var btnChooseTimeSlot: UIButton!
    
    
    @IBOutlet weak var btnDate: UIButton!
    @IBOutlet weak var tfMessage: UITextField!
    @IBOutlet weak var lbDate: UILabel!
    @IBOutlet weak var dpkDate: UIDatePicker!
    @IBOutlet weak var pkTimeSlot: UIPickerView!
    
    
    var pickerData = [String]()
    var timeSlot = [PitchTimeSlot]()
    var timeSlotID: Int?
   
    override func viewDidLoad() {
        super.viewDidLoad()
      
        self.pkTimeSlot.dataSource = self;
        self.pkTimeSlot.delegate = self;
        
        dpkDate.isHidden = true
        dpkDate.datePickerMode = UIDatePickerMode.date
        
        pkTimeSlot.isHidden = true
        
        timeSlot.forEach { (timeSlot) in
            var dataTime = "\(timeSlot.timeStart!) - \(timeSlot.timeEnd!)"
            pickerData.append(dataTime)
        }
        pkTimeSlot.reloadAllComponents()
        
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func dpkDateEndEdit(_ sender: UIDatePicker) {
        
    }
    
    @IBAction func btnChooseTimeSlotClick(_ sender: Any) {
        pkTimeSlot.isHidden = false
    }
    @IBAction func btnOKClick(_ sender: Any) {
        uploadOrderPitch()
    }
    @IBAction func btnCancelClick(_ sender: Any) {
        
    }
    @IBAction func btnSelectDateClick(_ sender: Any) {
        dpkDate.datePickerMode = UIDatePickerMode.date
        var dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd"
        var selectedDate = dateFormatter.string(from: dpkDate.date)
        
        dpkDate.isHidden = true
        btnDate.setTitle(selectedDate, for: .normal)
        
    }
    
    func uploadOrderPitch() {
        
        let parameters = [
                        "user_id" : "",
                        "order_date"  : "\((self.btnDate.titleLabel?.text)!))",
                        "time_slot_id": "\(self.timeSlotID!)",
                        "order_message" : "\(self.tfMessage.text!)",
                    ]
        Alamofire.request( "http://fooco.esy.es/public/api/pitch/order.php" , method: .post, parameters: parameters, encoding: URLEncoding.default).log(level: .all, options: [.onlyDebug, .jsonPrettyPrint, .includeSeparator])
            .responseJSON { (response) in
                
                if let statusCode = response.response?.statusCode {
                    print("STATUS CODE \(statusCode)")
                }
                
                switch response.result {
                case .failure(let error) :
                    print(error)
                case .success(let responseObject):
                    print("Thanh Cong")
                    
                    
            }
        }

    }
    
    
}


extension UserOderPitchViewController: UIPickerViewDataSource, UIPickerViewDelegate {
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return pickerData.count
    }
    func pickerView(_
        pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int
        ) -> String? {
        return pickerData[row]
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        let location = pickerData[row]
        btnChooseTimeSlot.setTitle(location, for: .normal)
        let pitchTimeSlot = timeSlot[row]
        timeSlotID = pitchTimeSlot.id!
        pkTimeSlot.isHidden = true
    }
    
}

