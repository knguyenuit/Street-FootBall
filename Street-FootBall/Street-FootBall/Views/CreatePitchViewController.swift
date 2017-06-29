//
//  CreatePitchViewController.swift
//  Street-FootBall
//
//  Created by Khanh Nguyen on 6/22/17.
//  Copyright © 2017 Khanh Nguyen. All rights reserved.
//

import UIKit
import NVActivityIndicatorView
import ObjectMapper
import AlamofireActivityLogger
import Alamofire

class CreatePitchViewController: UIViewController {

    @IBOutlet weak var tfPitchName: UITextField!
    @IBOutlet weak var tfPitchPhone: UITextField!
    @IBOutlet weak var tfPitchAddress: UITextField!
    @IBOutlet weak var btnPitchDistrict: UIButton!
    @IBOutlet weak var pkDistrict: UIPickerView!
    @IBOutlet weak var ivPitchAvatar: UIImageView!
    @IBOutlet weak var btnChooseImage: UIButton!
    
    var pitchOwnerID = 0
    var districtID = 0
    let pickerData = [
        ["Thủ Đức","Quận 9","Quận 1","Quận 2","Quận 3", "Quận 4","Quận 5","Quận 6","Quận 7", "Quận 8","Tân Bình","Quận 10","Quận 11","Quận 12", "Bình Thạnh","Gò Vấp", "Tân Phú", "Bình Tân"]
    ]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        pkDistrict.delegate = self
        pkDistrict.dataSource = self
        pkDistrict.isHidden = true
        self.hideKeyboardWhenTappedAround()
        print(pitchOwnerID)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func btnAppyClick(_ sender: Any) {
        uploadWithAlamofire()
    }

    @IBAction func btnCancelClick(_ sender: Any) {
        
    }
    
    @IBAction func btnChooseDistrictClick(_ sender: Any) {
        pkDistrict.isHidden = false
    }
    
    func createPitch(){
//        let param = [
//            "user_id" : "1",
//            "pitch_name"  : "\(tfPitchName.text!)",
//            "location_district": "\(districtID)",
//            "pitch_phone" : "\(tfPitchPhone.text!)",
//            "location_address"    : "\(tfPitchAddress.text!)",
//        ]
//        
//        Alamofire.request("http://fooco.esy.es/public/api/pitch/create-pitch.php?type=json", method: .post, parameters: param, encoding: JSONEncoding.default, headers: nil).responseJSON({(reponse) in
//            
//        })
        
    }
    
    // import Alamofire
    func uploadWithAlamofire() {
        let activityData = ActivityData()
        NVActivityIndicatorPresenter.sharedInstance.startAnimating(activityData)
        let image = ivPitchAvatar.image
        
        print("Pitch Owner ID: \(self.pitchOwnerID)")
        // define parameters
        let parameters = [
            "user_id" : "\(String(GlobalVariable.pitchOwnerID))",
            "pitch_name"  : "\(tfPitchName.text!)",
            "location_district": "\(districtID)",
            "pitch_phone" : "\(tfPitchPhone.text!)",
            "location_address"    : "\(tfPitchAddress.text!)"
        ]
        
        print(parameters)
        
        Alamofire.upload(multipartFormData: { multipartFormData in
            if let imageData = UIImageJPEGRepresentation(image!, 1) {
                multipartFormData.append(imageData, withName: "avatar", fileName: "\(self.tfPitchName.text)", mimeType: "image/png")
            }
            
            for (key, value) in parameters {
                multipartFormData.append((value.data(using: .utf8))!, withName: key)
            }}, to: "http://fooco.esy.es/public/api/pitch/create-pitch.php?type=json", method: .post, headers: ["Authorization": "auth_token"],
                encodingCompletion: { encodingResult in
                    NVActivityIndicatorPresenter.sharedInstance.stopAnimating()
                    switch encodingResult {
                    case .success(let upload, _, _):
                        upload.response { [weak self] response in
                            guard self != nil else {
                                return
                            }
                            debugPrint(response)
                        }
                    case .failure(let encodingError):
                        print("error:\(encodingError)")
                    }
        })
    }
    
    func showArlert() {
        
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

extension CreatePitchViewController: UIImagePickerControllerDelegate,UINavigationControllerDelegate,UIPickerViewDataSource, UIPickerViewDelegate{
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return pickerData.count
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return pickerData[component].count
    }
    func pickerView(_
        pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int
        ) -> String? {
        return pickerData[component][row]
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        let location = pickerData[0][pkDistrict.selectedRow(inComponent: 0)]
        btnPitchDistrict.setTitle(location, for: .normal)
        pkDistrict.isHidden = true
        districtID = pkDistrict.selectedRow(inComponent: 0) + 2
    }
    
    @IBAction func btnChooseImageClick(_ sender: Any) {
        if UIImagePickerController.isSourceTypeAvailable(UIImagePickerControllerSourceType.photoLibrary) {
            let imagePicker = UIImagePickerController()
            imagePicker.delegate = self
            imagePicker.sourceType = UIImagePickerControllerSourceType.photoLibrary;
            imagePicker.allowsEditing = true
            self.present(imagePicker, animated: true, completion: nil)
        }
    }
    
    private func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : AnyObject]) {
        if let pickedImage = info[UIImagePickerControllerOriginalImage] as? UIImage {
            ivPitchAvatar.contentMode = .scaleToFill
            ivPitchAvatar.image = pickedImage
            btnChooseImage.isHidden = true
        }
        
        picker.dismiss(animated: true, completion: nil)
    }
}