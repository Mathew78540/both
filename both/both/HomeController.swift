//
//  ViewController.swift
//  both
//
//  Created by Mathieu Le tyrant on 14/12/2015.
//  Copyright © 2015 Mathieu Le tyrant. All rights reserved.
//

import UIKit
import SwiftyJSON

class HomeController: UIViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Hide Navigation
        navigationController?.navigationBar.hidden          = true;
        UIApplication.sharedApplication().statusBarStyle    = .Default
    }
    
    // If the user is already connected -> Redirect to the dashboard
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(true)
        
        LocalStorage.cleanLocal()
        
        if let connected = LocalStorage.getConnected(){
            if (connected == 1) {
                if let viewController = self.storyboard?.instantiateViewControllerWithIdentifier("dashboard_identifier") {
                    UIApplication.sharedApplication().keyWindow?.rootViewController = viewController
                }
            }
        }
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }

}

