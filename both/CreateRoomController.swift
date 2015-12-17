//
//  CreateRoomController.swift
//  both
//
//  Created by Mathieu Le tyrant on 14/12/2015.
//  Copyright © 2015 Mathieu Le tyrant. All rights reserved.
//

import UIKit
import SwiftyJSON

class CreateRoomController: UIViewController {
    
    
    // MARK: Outlets
    
    @IBOutlet weak var labelUserUsername: UITextField!
    @IBOutlet weak var labelUserEmail: UITextField!
    @IBOutlet weak var labelUserPassword: UITextField!
    @IBOutlet weak var labelPartnerEmail: UITextField!
    @IBOutlet weak var labelBtn: UIButton!
    @IBOutlet weak var activityCreate: UIActivityIndicatorView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
                
        // Add border-bottom
        borderBottom(labelUserUsername)
        borderBottom(labelUserEmail)
        borderBottom(labelUserPassword)
        borderBottom(labelPartnerEmail)
        
        // Hide activity
        activityCreate.hidden = true
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
        
        if(labelUserUsername.text != "" && labelUserEmail.text != "" && labelUserPassword.text != "" && labelPartnerEmail.text != ""){
            
            activityCreate.hidden = false
            
            // Try to join a room create by the first user
            Api.createRoom(labelUserUsername.text!, userEmail: labelUserEmail.text!, userPassword: labelUserPassword.text!, partnerEmail: labelPartnerEmail.text!, callback: { (result) -> () in
                
                self.activityCreate.hidden = true
                
                // Success join
                if(result["status_code"] == 200){
                    
                    LocalStorage.setUserID(result["data"]["user_id"].int!)
                    LocalStorage.setPartnerUserID(result["data"]["partner_id"].int!)
                    LocalStorage.setRoomToken(result["data"]["token"].string!)
                    LocalStorage.setConnected()
                    
                    // Hide keyboard
                    self.view.endEditing(true)
                    
                    // Go to the dashboard
                    if let viewController = self.storyboard?.instantiateViewControllerWithIdentifier("dashboard_identifier") {
                        UIApplication.sharedApplication().keyWindow?.rootViewController = viewController
                    }
                    
                } else {
                    // TODO : Display errors
                }
                
                
            });
            
        } else {
            Alert.display(self, title: "Erreur", message: "Merci de remplir tous les champs")
        }
        
    }
    
}
