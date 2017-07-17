//
//  TabbarViewController.swift
//  Street-FootBall
//
//  Created by Khanh Nguyen on 6/27/17.
//  Copyright © 2017 Khanh Nguyen. All rights reserved.
//

import UIKit

class TabbarViewController: UIViewController, UITabBarControllerDelegate {

    
    var listViewController = [UIViewController]()
    var listVCNavigation = [UIViewController]()
    var listTabbarItem = [UITabBarItem]()
    var tbbar:UITabBarController = UITabBarController()
    var navigationListPitch: UINavigationController?
    var navigationListPitchByDistrict: UINavigationController?
    
       override func viewDidLoad() {
        super.viewDidLoad()
        navigationController?.setNavigationBarHidden(true, animated: false)
        
        self.tabBarController?.delegate = self
        
        let vcListPitch = ListPitchMapViewController(nibName: "ListPitchMapViewController", bundle: nil)
        vcListPitch.tabBarItem = UITabBarItem(title: "List Pitch", image: #imageLiteral(resourceName: "icon_Pitch"), tag: 0)
        let vcSearchPitch = SearchPitchViewController(nibName: "SearchPitchViewController", bundle: nil)
        vcSearchPitch.tabBarItem = UITabBarItem(title: "Search Pitch", image: #imageLiteral(resourceName: "icon_Location"), tag: 1)
        
        navigationListPitch = UINavigationController(rootViewController: vcListPitch)
        navigationListPitchByDistrict = UINavigationController(rootViewController: vcSearchPitch)
        listViewController.append(navigationListPitch!)
        listViewController.append(navigationListPitchByDistrict!)
        
        tbbar.setViewControllers(listViewController, animated: true)
        
        tbbar.view.autoresizingMask = [.flexibleHeight, .flexibleWidth]
        tbbar.view.frame = view.bounds
        //navigation.view.autoresizingMask = [.flexibleHeight, .flexibleWidth]
        //navigation.view.frame = view.bounds
        view.insertSubview(tbbar.view, at: 0)
//        view.addSubview(tbbar.view)
        
        
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
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
