//
//  AddNewTaskController.swift
//  both
//
//  Created by Mathieu Le tyrant on 15/12/2015.
//  Copyright © 2015 Mathieu Le tyrant. All rights reserved.
//

import UIKit

class AddNewTaskController: UIViewController, UIPickerViewDelegate {
    
    // All current tasks from API
    private lazy var allCategories = [Category]()
    private var categoryIdSelected:Int = 1
    
    // MARK: Outlets
    @IBOutlet weak var labelBtn: UIButton!
    @IBOutlet weak var labelTaskName: UITextField!
    @IBOutlet weak var labelUIPicker: UIPickerView!
    @IBOutlet weak var activityAddTask: UIActivityIndicatorView!
    
    
    // MARK: Override
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Title page
        self.title = "Ajouter une tâche"
        
        // Hide Activity
        activityAddTask.hidden = true
        
        // Add border-bottom
        borderBottom(labelTaskName)
        
        // Get categories from API
        getCategories()
    }
    
    override func touchesBegan(touches: Set<UITouch>, withEvent event: UIEvent?){
        view.endEditing(true)
        super.touchesBegan(touches, withEvent: event)
    }
    
    
    // MARK: UIPickerView
    func numberOfComponentsInPickerView(pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return allCategories.count
    }
    
    func pickerView(pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return allCategories[row].name
    }
    
    func pickerView(pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        self.categoryIdSelected = allCategories[row].id
    }

    
    // MARK: Actions
    @IBAction func btnAddTask(sender: UIButton) {
        
        if(self.labelTaskName.text != ""){
            
            self.activityAddTask.hidden = false
            
            Api.addTask(self.categoryIdSelected, name: self.labelTaskName.text!) { (result) -> () in
                self.activityAddTask.hidden = true
                self.navigationController?.popViewControllerAnimated(true)
            }
            
        } else {
            Alert.display(self, title: "Erreur", message: "Merci de rentrer un nom pour votre tâche")
        }
        
        
    }
    
    
    //MARK: Private methods
    func getCategories(){
        Api.getCategories { (result) -> () in
            self.allCategories += result
            self.labelUIPicker.reloadAllComponents()
        }
    }
}
