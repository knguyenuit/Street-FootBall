//
//  SignUpViewController.swift
//  Street-FootBall
//
//  Created by Khanh Nguyen on 6/21/17.
//  Copyright © 2017 Khanh Nguyen. All rights reserved.
//

import UIKit
import Firebase
import FirebaseAuth
import FirebaseDatabase
import FirebaseStorage

class SignUpViewController: UIViewController {

    @IBOutlet weak var tfEmail: UITextField!
    @IBOutlet weak var tfPassword: UITextField!
    @IBOutlet weak var tfUsername: UITextField!
    @IBOutlet weak var btnUserProfilePicture: UIButton!
    @IBOutlet weak var ivUserProfilePicture: UIImageView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        btnUserProfilePicture.isHidden = false
        self.hideKeyboardWhenTappedAround()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    @IBAction func test(_ sender: Any) {
        let vc = ListPitchViewController(nibName: "ListPitchViewController", bundle: nil)
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    @IBAction func btnSignUpClick(_ sender: Any) {
        print("Sign Up Click")
//        if tfEmail.text == "" {
//            let alertController = UIAlertController(title: "Error", message: "Please enter your email and password", preferredStyle: .alert)
//            
//            let defaultAction = UIAlertAction(title: "OK", style: .cancel, handler: nil)
//            alertController.addAction(defaultAction)
//            
//            present(alertController, animated: true, completion: nil)
//            
//        } else {
//            FIRAuth.auth()?.createUser(withEmail: tfEmail.text!, password: tfPassword.text!) { (user, error) in
//                
//                if error == nil {
//                    guard let uid = user?.uid else {
//                        return
//                    }
//                    let imageName = NSUUID().uuidString
//                    let storageRef = FIRStorage.storage().reference().child("profile_images").child("\(imageName).png")
//                    if let uploadData = UIImagePNGRepresentation(self.ivUserProfilePicture.image!) {
//                        
//                        storageRef.put(uploadData, metadata: nil, completion: { (metadata, error) in
//                            
//                            if let error = error {
//                                print(error)
//                                return
//                            }
//                            
//                            if let profileImageUrl = metadata?.downloadURL()?.absoluteString {
//                                
//                                let values = ["name": self.tfEmail.text!, "email": self.tfUsername.text!, "profileImageUrl": profileImageUrl]
//                                self.registerUserIntoDatabaseWithUID(uid, values: values as [String : AnyObject])
//                            }
//                        })
//                    }
//                    let vc = ListPitchViewController(nibName: "ListPitchViewController", bundle: nil)
//                    self.navigationController?.pushViewController(vc, animated: true)
//                    
//                } else {
//                    let alertController = UIAlertController(title: "Error", message: error?.localizedDescription, preferredStyle: .alert)
//                    
//                    let defaultAction = UIAlertAction(title: "OK", style: .cancel, handler: nil)
//                    alertController.addAction(defaultAction)
//                    
//                    self.present(alertController, animated: true, completion: nil)
//                }
//            }
//        }
    }
    
    fileprivate func registerUserIntoDatabaseWithUID(_ uid: String, values: [String: AnyObject]) {
        let ref = FIRDatabase.database().reference()
        let usersReference = ref.child("users").child(uid)
        
        usersReference.updateChildValues(values, withCompletionBlock: { (err, ref) in
            
            if let err = err {
                print(err)
                return
            }
            
            self.dismiss(animated: true, completion: nil)
        })
    }
    
    @IBAction func btnPickUserPicture(_ sender: Any) {
        let picker = UIImagePickerController()
        picker.delegate = self
        picker.allowsEditing = true
        present(picker, animated: true, completion: nil)
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

extension SignUpViewController: UIImagePickerControllerDelegate, UINavigationControllerDelegate{
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        
        var selectedImageFromPicker: UIImage?
        
        if let editedImage = info["UIImagePickerControllerEditedImage"] as? UIImage {
            selectedImageFromPicker = editedImage
        } else if let originalImage = info["UIImagePickerControllerOriginalImage"] as? UIImage {
            
            selectedImageFromPicker = originalImage
        }
        
        if let selectedImage = selectedImageFromPicker {
            ivUserProfilePicture.image = selectedImage
            ivUserProfilePicture.layer.cornerRadius = 0.5 * ivUserProfilePicture.bounds.size.width
            ivUserProfilePicture.clipsToBounds = true
            btnUserProfilePicture.isHidden = true

        }
        
        dismiss(animated: true, completion: nil)
        
    }
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        print("canceled picker")
        dismiss(animated: true, completion: nil)
    }
}


