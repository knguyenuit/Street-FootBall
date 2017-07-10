//
//  PitchOwnerLoginViewController.swift
//  Street-FootBall
//
//  Created by Khanh Nguyen on 6/20/17.
//  Copyright © 2017 Khanh Nguyen. All rights reserved.
//

import UIKit
import NVActivityIndicatorView
import Alamofire
import AlamofireActivityLogger
import ObjectMapper


class PitchOwnerLoginViewController: UIViewController {

    @IBOutlet weak var tfEmail: UITextField!
    @IBOutlet weak var tfPassword: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.hideKeyboardWhenTappedAround()
        navigationController?.setNavigationBarHidden(true, animated: false)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func btnBackClick(_ sender: Any) {
        navigationController?.popViewController(animated: true)
    }
    
    @IBAction func btnLoginClick(_ sender: Any) {
//        if self.tfEmail.text == "" || self.tfPassword.text == "" {
//            let alertController = UIAlertController(title: "Error", message: "Please enter an email and password.", preferredStyle: .alert)
//            let defaultAction = UIAlertAction(title: "OK", style: .cancel, handler: nil)
//            alertController.addAction(defaultAction)
//            self.present(alertController, animated: true, completion: nil)
//        } else {
//            FIRAuth.auth()?.signIn(withEmail: self.tfEmail.text!, password: self.tfPassword.text!) { (user, error) in
//                if error == nil {
//                    print("You have successfully logged in")
//                    let vc = ListPitchViewController(nibName: "ListPitchViewController", bundle: nil)
//                    self.navigationController?.pushViewController(vc, animated: true)
//                } else {
//                    let alertController = UIAlertController(title: "Error", message: error?.localizedDescription, preferredStyle: .alert)
//                    let defaultAction = UIAlertAction(title: "OK", style: .cancel, handler: nil)
//                    alertController.addAction(defaultAction)
//                    self.present(alertController, animated: true, completion: nil)
//                }
//            }
//        }
        
            let activityData = ActivityData()
            NVActivityIndicatorPresenter.sharedInstance.startAnimating(activityData)
            
        Alamofire.request( "http://fooco.esy.es/public/api/users/login.php" , method: .post, parameters: ["user_name" : tfEmail.text!, "user_pw" : tfPassword.text!], encoding: URLEncoding.default).log(level: .all, options: [.onlyDebug, .jsonPrettyPrint, .includeSeparator])
                .responseJSON { (response) in
                    
                    NVActivityIndicatorPresenter.sharedInstance.stopAnimating()
                    
                    if let statusCode = response.response?.statusCode {
                        print("STATUS CODE \(statusCode)")
                    }
                    
                    switch response.result {
                    case .failure(let error) :
                        print(error)
                    case .success(let responseObject):
                        
                        if let reponse = Mapper<LoginStatus>().map(JSONObject: responseObject){
                            if reponse.reponseStatus! == 1 {
                                print("Change view controller")
                                let vc = TabbarControllerPitchOwnerViewController(nibName: "TabbarControllerPitchOwnerViewController", bundle: nil)
                                if let apiResponse = Mapper<APIResponse<User>>().map(JSONObject: responseObject) {
                                    vc.pitchOwnerID = (apiResponse.data?.id!)!
                                    GlobalVariable.pitchOwnerID = (apiResponse.data?.id!)!
                                    vc.pitchOwnerUserName = (apiResponse.data?.name!)!
                                    vc.pitchOwnerEmail = (apiResponse.data?.email!)!
                                }
                                self.navigationController?.pushViewController(vc, animated: true)
                            }
                        }
                        
                        
                    }
            }
            
        
}

    @IBAction func btnRegisterNowAction(_ sender: Any) {
        let vc = SignUpViewController(nibName: "SignUpViewController", bundle: nil)
        navigationController?.pushViewController(vc, animated: true)
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

extension UIViewController {
    func hideKeyboardWhenTappedAround() {
        let tap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(UIViewController.dismissKeyboard))
        tap.cancelsTouchesInView = false
        view.addGestureRecognizer(tap)
    }
    
    func dismissKeyboard() {
        view.endEditing(true)
    }
}

