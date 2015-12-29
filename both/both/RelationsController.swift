//
//  RelationsController.swift
//  both
//
//  Created by Mathieu Le tyrant on 15/12/2015.
//  Copyright © 2015 Mathieu Le tyrant. All rights reserved.
//

import UIKit

class RelationsController: UIViewController, UITableViewDataSource {

    // All current tasks from API
    private lazy var allCategories = [CategoryStat]()
    
    // Pull to Refresh
    var refreshControl:UIRefreshControl!
    
    //MARK: Outlets
    @IBOutlet weak var imageViewMe: UIImageView!
    @IBOutlet weak var imageViewPartner: UIImageView!
    @IBOutlet weak var labelMeAndPartnerName: UILabel!
    @IBOutlet weak var categoriesTableView: UITableView!
    
    
    //MARK: Override
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Add Pull to refresh
        self.refreshControl = UIRefreshControl()
        self.refreshControl.addTarget(self, action: "refresh:", forControlEvents: UIControlEvents.ValueChanged)
        self.refreshControl.tintColor = UIColor.whiteColor()
        self.refreshControl.backgroundColor = UIColorFromRGBA("424557")
        self.categoriesTableView.addSubview(refreshControl)
        
        // Get user & partner information
        getProfilesInformation()
        
        // Get categories stats
        refreshCategoryViewFromApi()
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(true)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    //MARK: Table view
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return allCategories.count
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
        // Remove bottom border
        tableView.separatorStyle = .None
        
        // Création ou récupération d'une cellule depuis le cache
        let cell = tableView.dequeueReusableCellWithIdentifier(CategoryStatCell.identifier, forIndexPath: indexPath) as! CategoryStatCell
                
        // Change value in the cell
        cell.category = allCategories[indexPath.row]
        cell.backgroundColor = UIColorFromRGBA("E9E9E9")
                
        return cell
    }
    
    func refresh(sender:AnyObject) {
        self.refreshCategoryViewFromApi()
    }
    
    //MARK: Methods
    @IBAction func breakBtn(sender: AnyObject) {
        
        
        let alertController = UIAlertController(
            title   : "Rupture",
            message : "Etes-vous sûr de vouloir rompre ? Votre relation sera définitivement supprimée",
            preferredStyle: .Alert
        )
        
        let yesButton = UIAlertAction(title: "Oui", style: .Destructive) { (action) in
            LocalStorage.cleanLocal()
            
            
            // TODO : CALL API
            
            // Redirect to the home
            if let viewController = self.storyboard?.instantiateViewControllerWithIdentifier("home_identifier") {
                UIApplication.sharedApplication().keyWindow?.rootViewController = viewController
            }
        }
        
        let noButton  = UIAlertAction(title: "Non", style: .Default) { (action) in }
        
        alertController.addAction(noButton)
        alertController.addAction(yesButton)
        
        self.presentViewController(alertController, animated: true) { }
        
        
    }
    
    @IBAction func forgiveMeBtn(sender: UIButton) {
        
        var proposeTextField: UITextField?
        
        let alertController = UIAlertController(
            title: "Demander pardon",
            message: "Que proposez-vous ?",
            preferredStyle: .Alert
        )
        
        let cancelButton = UIAlertAction(title: "Annuler", style: .Destructive, handler: nil)
        let okButton     = UIAlertAction(title: "Envoyer", style: .Default, handler: { (action) -> Void in
            
            // Check if user enter a text ...
            if (proposeTextField?.text != ""){
                Api.askSorry((proposeTextField!.text)!)
            }
            
        })
        
        alertController.addAction(cancelButton)
        alertController.addAction(okButton)
        

        alertController.addTextFieldWithConfigurationHandler({(textField: UITextField!) in
            textField.placeholder = "Entrez votre proposition de pardon"
            proposeTextField = textField
        })
        
        presentViewController(alertController, animated: true, completion: nil)
        
    }
    
    //MARK: Privates methods
    func getProfilesInformation(){
        
        let meAvatar        = UIImage(data: NSData(contentsOfURL: NSURL(string:"https://assets.peerstreet.com/assets/default_avatar-886fa1c653f484f00f53dff216dbfd016234e1b16c99203f727392aa2f3dd42b.png")!)!)!
        let partnerAvatar   = UIImage(data: NSData(contentsOfURL: NSURL(string:"https://assets.peerstreet.com/assets/default_avatar-886fa1c653f484f00f53dff216dbfd016234e1b16c99203f727392aa2f3dd42b.png")!)!)!
        
        // Add avatar circle
        self.imageViewMe.image       = meAvatar.circle
        self.imageViewPartner.image  = partnerAvatar.circle
        
        // Add border to the avatar
        borderCercle(self.imageViewMe, border: 5.0)
        borderCercle(self.imageViewPartner, border: 5.0)
        
        Api.getProfiles { (result) -> () in
            self.labelMeAndPartnerName.text = "\(result["me"]["name"]) & \(result["partner"]["name"])"
        }
        
    }
    
    func refreshCategoryViewFromApi() {
        Api.getCategoriesStats({ (result) -> () in
            
            self.allCategories.removeAll()
            self.allCategories+=result
            
            // tell refresh control it can stop showing up now
            if self.refreshControl.refreshing {
                self.refreshControl.endRefreshing()
            }
            
            self.categoriesTableView.reloadData()
        })
    }
    
}
