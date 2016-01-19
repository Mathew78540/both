//
//  NavigationBar.swift
//  both
//
//  Created by Mathieu Le tyrant on 15/12/2015.
//  Copyright © 2015 Mathieu Le tyrant. All rights reserved.
//

import UIKit

class NavigationBar: UINavigationController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        customNavigationBarStyle()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    // Custom style for the navigationBar
    func customNavigationBarStyle(){
        
        UINavigationBar.appearance().tintColor = UIColor.whiteColor() // Buttons
        UINavigationBar.appearance().barTintColor = UIColorFromRGBA(Config.backgroundColorNavBar, alpha: 1.0) // Background
        UINavigationBar.appearance().titleTextAttributes = [NSForegroundColorAttributeName:UIColor.whiteColor()]  // Title's text color
        UIApplication.sharedApplication().statusBarStyle = .LightContent // StatusBar text color
        
    }

}
