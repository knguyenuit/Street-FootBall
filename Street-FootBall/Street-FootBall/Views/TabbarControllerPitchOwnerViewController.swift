//
//  TabbarControllerPitchOwnerViewController.swift
//  Street-FootBall
//
//  Created by Khanh Nguyen on 6/28/17.
//  Copyright © 2017 Khanh Nguyen. All rights reserved.
//

import UIKit

class TabbarControllerPitchOwnerViewController: UIViewController, UITabBarControllerDelegate {

    var listViewController = [UIViewController]()
    var listVCNavigation = [UIViewController]()
    var listTabbarItem = [UITabBarItem]()
    var tbbar:UITabBarController = UITabBarController()
    var navigation:UINavigationController?
    var pitchOwnerID = 0
    var pitchOwnerUserName = ""
    var pitchOwnerEmail = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.tabBarController?.delegate = self
        
        let vcListPitch = ListPitchViewController(nibName: "ListPitchViewController", bundle: nil)
        vcListPitch.pitchOwnerID = self.pitchOwnerID
        vcListPitch.tabBarItem = UITabBarItem(title: "List Pitch", image: #imageLiteral(resourceName: "icon_Pitch"), tag: 0)
        
        let vcPitchProfile = PitchOwnerProfileViewController(nibName: "PitchOwnerProfileViewController", bundle: nil)
        vcPitchProfile.pitchOwnerUserName = pitchOwnerUserName
        vcPitchProfile.pitchOwnerEmail = pitchOwnerEmail
        vcPitchProfile.tabBarItem = UITabBarItem(title: "Profile", image: #imageLiteral(resourceName: "icons-Businessman"), tag: 1)
        
        navigation = UINavigationController(rootViewController: vcListPitch)
        listViewController.append(navigation!)
        listViewController.append(vcPitchProfile)
        
        tbbar.setViewControllers(listViewController, animated: true)
        
        tbbar.view.autoresizingMask = [.flexibleHeight, .flexibleWidth]
        tbbar.view.frame = view.bounds
        //navigation.view.autoresizingMask = [.flexibleHeight, .flexibleWidth]
        //navigation.view.frame = view.bounds
        view.addSubview(tbbar.view)
        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
}