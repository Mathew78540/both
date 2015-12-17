//
//  Alert.swift
//  both
//
//  Created by Mathieu Le tyrant on 15/12/2015.
//  Copyright © 2015 Mathieu Le tyrant. All rights reserved.
//

import UIKit

class Alert {
    
    static func display(instance:UIViewController, title:String, message:String){
        let alertController = UIAlertController(
            title   : title,
            message : message,
            preferredStyle: .Alert
        )
        alertController.addAction(UIAlertAction(title: "OK", style: .Default) { (action) in })
        instance.presentViewController(alertController, animated: true) { }
    }
    
}
