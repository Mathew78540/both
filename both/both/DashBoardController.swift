//
//  DashBoardController.swift
//  both
//
//  Created by Mathieu Le tyrant on 14/12/2015.
//  Copyright © 2015 Mathieu Le tyrant. All rights reserved.
//

import UIKit

class DashBoardController: UIViewController, UITableViewDataSource {
    
    
    // All current tasks from API
    private lazy var allTasksProgress = [TaskProgress]()
    
    // Pull to Refresh
    var refreshControl:UIRefreshControl!
    
    
    // MARK: Outlets
    @IBOutlet weak var tasksTableView: UITableView!
    @IBOutlet weak var emptyTableView: UILabel!
    
    // MARK: Override
    override func viewDidLoad() {
        
        super.viewDidLoad()
        
        emptyTableView.hidden = true
        tasksTableView.hidden = true
        
        // Add Pull to refresh
        self.refreshControl = UIRefreshControl()
        self.refreshControl.addTarget(self, action: "refresh:", forControlEvents: UIControlEvents.ValueChanged)
        self.refreshControl.tintColor = UIColor.whiteColor()
        self.refreshControl.backgroundColor = UIColorFromRGBA("424557")
        self.tasksTableView.addSubview(refreshControl)
        
        // Don't display empty cell
        tasksTableView.tableFooterView = UIView(frame: CGRect.zero)
        
    }
    
    func refresh(sender:AnyObject) {
        self.refreshTableViewFromApi()
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(true)
        
        // Get task progress
        self.refreshTableViewFromApi()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    
    
    // MARK: UITableView
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return allTasksProgress.count
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
        // Création ou récupération d'une cellule depuis le cache
        let cell = tableView.dequeueReusableCellWithIdentifier(TaskProgressCell.identifier, forIndexPath: indexPath) as! TaskProgressCell
        
        // Remove bottom border
        tableView.separatorStyle = .None
        
        // Change value in the cell
        cell.task = allTasksProgress[indexPath.row]
        
        // Gray background %2
        if(indexPath.row % 2 != 0){
            cell.backgroundColor = UIColorFromRGBA("F7F7F7", alpha: 1.0)
        }
        
        return cell
    }
    
    // When user click on a cell
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        
        let userId = LocalStorage.getUserId()!
        let taskId = allTasksProgress[indexPath.row].id
        
        Api.updateTaskProgress(userId, taskId: taskId) { (result) -> () in
            if (result){
                
                // Update value in the list
                self.allTasksProgress[indexPath.row].difference = self.allTasksProgress[indexPath.row].difference + 1
                
                // Reload the tableView
                self.tasksTableView.reloadData()
                
                // Test the new value :)
                let newDifferenceValue  = self.allTasksProgress[indexPath.row].difference
                let taskCategory        = self.allTasksProgress[indexPath.row].category
                
                if (newDifferenceValue == Config.badgeValue){
                    let message = Config.getBadgeBaseOnCategory(taskCategory)
                    
                    Api.addBadge(taskCategory, message: message, callback: { (result) -> () in
                        Alert.display(self, title: "Badge", message: Config.getBadgeBaseOnCategory(taskCategory))
                    })
                }
                
            }
        }
        
    }
    
    func tableView(tableView: UITableView, canEditRowAtIndexPath indexPath: NSIndexPath) -> Bool {
        return true
    }
    
    func tableView(tableView: UITableView, editActionsForRowAtIndexPath indexPath: NSIndexPath) -> [UITableViewRowAction]?  {

        let deleteAction = UITableViewRowAction(style: .Default, title: "Supprimer", handler: { (action , indexPath) -> Void in
            
            
            // Are you sure to delete the task ?
            let alertController = UIAlertController(
                title   : "Supprimer",
                message : "Etes-vous sûr de vouloir supprimer cette tâche ?",
                preferredStyle: .Alert
            )
            
            let yesButton = UIAlertAction(title: "Oui", style: .Destructive) { (action) in
                let taskId = self.allTasksProgress[indexPath.row].id
                
                Api.deleteTask(taskId, callback: { (result) -> () in
                    // Refresh the list
                    self.refreshTableViewFromApi()
                })
            }
            
            let noButton = UIAlertAction(title: "Non", style: .Default) { (action) in }
            
            alertController.addAction(noButton)
            alertController.addAction(yesButton)
            
            self.presentViewController(alertController, animated: true) { }
            
            
        })
        
        // You can set its properties like normal button
        deleteAction.backgroundColor = UIColorFromRGBA("424557", alpha: 1.0)
        
        return [deleteAction]
    }
    
    // MARK: Private methods
    func getSorry(){
        Api.getSorry({ (result) -> () in
            
            // I have a sorry
            if(result["status_code"] == 200){
                
                let alertController = UIAlertController(
                    title   : "Demande de pardon",
                    message : "Votre partenaire vous propose (\(result["success"]["message"])) pour repartir de zéro",
                    preferredStyle: .Alert
                )
                
                let yesButton = UIAlertAction(title: "J'accepte", style: .Default) { (action) in
                    Api.deleteSorry(1)
                    self.refreshTableViewFromApi()
                }
                
                let noButton  = UIAlertAction(title: "Je décline", style: .Default) { (action) in
                    Api.deleteSorry(0)
                    self.refreshTableViewFromApi()
                }
                
                alertController.addAction(noButton)
                alertController.addAction(yesButton)
                
                self.presentViewController(alertController, animated: true) { }
                
            }
            
        })
    }
    
    
    func refreshTableViewFromApi() {
        Api.getTasksForDashboard { (result) -> () in
            
            if(result.count == 0){
                self.emptyTableView.hidden = false
                self.tasksTableView.hidden = true
            }
            
            if(result.count > 0){
                self.tasksTableView.hidden = false
                self.emptyTableView.hidden = true
            }
            
            self.allTasksProgress.removeAll()
            self.allTasksProgress+=result
            
            // tell refresh control it can stop showing up now
            if self.refreshControl.refreshing {
                self.refreshControl.endRefreshing()
            }
            
            self.tasksTableView.reloadData()
            
            self.getSorry()
        }
    }
    
}
