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
    
    @IBOutlet weak var labelEmail: UITextField!
    @IBOutlet weak var labelPassword: UITextField!
    
    @IBOutlet weak var labelBtnLogin: UIButton!
    @IBOutlet weak var activityLogin: UIActivityIndicatorView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Add border-bottom
        borderBottom(labelEmail)
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
        
        if (labelEmail.text!.isEmpty || labelPassword.text!.isEmpty){
            Alert.display(self, title: "Erreur", message: "Merci de remplir tous les champs")
            return
        }
        
        self.activityLogin.hidden = false
        
        // Try to create the user and the room
        Api.login(labelEmail.text!, password: labelPassword.text!, callback: { (result) -> () in
            
            self.activityLogin.hidden = true
            
            // Success Creation
            if(result["status_code"] == 200){
                
                LocalStorage.setUserID(result["data"]["me"]["id"].int!)
                LocalStorage.setPartnerUserID(result["data"]["partner"]["id"].int!)
                LocalStorage.setRoomToken(result["data"]["room"]["token"].string!)
                LocalStorage.setConnected()
                
                // Hide keyboard
                self.view.endEditing(true)
                
                // Go to the dashboard
                if let viewController = self.storyboard?.instantiateViewControllerWithIdentifier("dashboard_identifier") {
                    UIApplication.sharedApplication().keyWindow?.rootViewController = viewController
                }
                
            }
            else if(result["status_code"] == 404){
                var errorMessage:String = ""
                
                for obj in result["errors"] {
                    errorMessage += "\(obj.1.stringValue) \n"
                }
                
                Alert.display(self, title: "Erreur", message: errorMessage)
            }
            else {
                Alert.display(self, title: "Erreur", message: "L'API de Both semble hors ligne. Merci de réessayer.")
            }
            
            
        });
        
    }
    
    
}
