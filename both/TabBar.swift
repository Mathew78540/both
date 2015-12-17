//
//  TapBar.swift
//  both
//
//  Created by Mathieu Le tyrant on 14/12/2015.
//  Copyright © 2015 Mathieu Le tyrant. All rights reserved.
//

import UIKit

class TabBar: UITabBarController {

    override func viewDidLoad() {
        super.viewDidLoad()
        customtabBarStyle()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    // Custom tabBar style
    func customtabBarStyle(){
        
        UITabBar.appearance().tintColor = UIColorFromRGBA(Config.backgroundColorNavBar, alpha: 1) // Text color on active
        UITabBar.appearance().barTintColor = UIColorFromRGBA("F6F6F6", alpha: 1.0) // Background color
        UITabBar.appearance().opaque = false
        UITabBar.appearance().translucent = false

    }

}
