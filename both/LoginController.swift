//
//  LoginController.swift
//  both
//
//  Created by Mathieu Le tyrant on 14/12/2015.
//  Copyright © 2015 Mathieu Le tyrant. All rights reserved.
//

import UIKit

class LoginController: UIViewController {
    
    
    // MARK: Outlets
    
    @IBOutlet weak var labelUsername: UITextField!
    @IBOutlet weak var labelPassword: UITextField!
    @IBOutlet weak var labelBtnLogin: UIButton!
    @IBOutlet weak var activityLogin: UIActivityIndicatorView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Add border-bottom
        borderBottom(labelUsername)
        borderBottom(labelPassword)
        
        // Hide activity
        activityLogin.hidden = true
        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    // Close the keyboard
    override func touchesBegan(touches: Set<UITouch>, withEvent event: UIEvent?){
        view.endEditing(true)
        super.touchesBegan(touches, withEvent: event)
    }

    // MARK: Actions

    @IBAction func validateForm(sender: UIButton) {
        
        if(labelUsername.text != "" && labelPassword.text != ""){
            
            self.activityLogin.hidden = false
            
            // Try to create the user and the room
            Api.login(labelUsername.text!, password: labelPassword.text!, callback: { (result) -> () in
                
                self.activityLogin.hidden = false
                
                // Success Creation
                if(result["status_code"] == 200){
                    LocalStorage.setUserID(result["me"]["id"].int!)
                    LocalStorage.setPartnerUserID(result["partner"]["id"].int!)
                    LocalStorage.setRoomToken(result["room"]["token"].string!)
                    LocalStorage.setConnected()
                    
                    // Hide keyboard
                    self.view.endEditing(true)
                    
                    // Go to the dashboard
                    if let viewController = self.storyboard?.instantiateViewControllerWithIdentifier("dashboard_identifier") {
                        UIApplication.sharedApplication().keyWindow?.rootViewController = viewController
                    }
                    
                } else {
                    Alert.display(self, title: "Erreur", message: result["errors"].string!)
                }
                
                
            });
            
        } else {
            
            Alert.display(self, title: "Erreur", message: "Merci de remplir tous les champs")
        }
        
    }
    
    
}
