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
    
    @IBOutlet weak var labelUserName: UITextField!
    @IBOutlet weak var labelUserEmail: UITextField!
    @IBOutlet weak var labelUserPassword: UITextField!
    
    @IBOutlet weak var labelPartnerName: UITextField!
    @IBOutlet weak var labelPartnerEmail: UITextField!
    @IBOutlet weak var labelPartnerPassword: UITextField!
    
    @IBOutlet weak var labelBtn: UIButton!
    @IBOutlet weak var activityCreate: UIActivityIndicatorView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
                
        // Add border-bottom
        borderBottom(labelUserName)
        borderBottom(labelUserEmail)
        borderBottom(labelUserPassword)
        
        borderBottom(labelPartnerName)
        borderBottom(labelPartnerEmail)
        borderBottom(labelPartnerPassword)
        
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
        
        
        // User must complete all fields
        if(labelUserName.text!.isEmpty || labelUserEmail.text!.isEmpty || labelUserPassword.text!.isEmpty){
            Alert.display(self, title: "Erreur", message: "Merci de remplir tous les champs")
            return
        }
        
        if(labelPartnerName.text!.isEmpty || labelPartnerEmail.text!.isEmpty || labelPartnerPassword.text!.isEmpty){
            Alert.display(self, title: "Erreur", message: "Merci de remplir tous les champs")
            return
        }
        
        
        // Display the activity
        activityCreate.hidden = false
        
        // Try to join a room create by the first user
        Api.createRoom(labelUserName.text!, userEmail: labelUserEmail.text!, userPassword: labelUserPassword.text!, partnerName: labelPartnerName.text!, partnerEmail: labelPartnerEmail.text!, partnerPassword: labelPartnerPassword.text!, callback: { (result) -> () in
            
            self.activityCreate.hidden = true
            
            // Success join
            if(result["status_code"] == 200){
                
                // Hide keyboard
                self.view.endEditing(true)
                
                // Display success alert
                Alert.display(self, title: "Succès", message: result["success"].string!)
                
                // Redirect to the home
                self.performSegueWithIdentifier("create_to_home", sender: nil)
                
            } else {
                print(result["errors"])
            }
            
            
        });
        
    }
    
}
