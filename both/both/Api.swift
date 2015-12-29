//
//  Api.swift
//  both
//
//  Created by Le Tyrant Mathieu on 01/06/2015.
//  Copyright (c) 2015 both. All rights reserved.
//

import Foundation
import SwiftyJSON
import Alamofire

struct Api {
    
    static let baseUrl = Config.apiURL
    static let headers = [
        "token"     : LocalStorage.getToken()!,
        "language"  : NSLocale.preferredLanguages()[0]
    ]
    
    // MARK: Login
    static func login(email:String, password:String, callback: (JSON) -> ()){
        
        let parameters = [
            "user_email"     : email,
            "user_password"  : password
        ]
        
        let urlAPI = NSURL(string: Api.baseUrl + "login/");
        
        Alamofire.request(.POST, urlAPI!, parameters: parameters, encoding: .JSON, headers: Api.headers)
            .responseJSON { (response) -> Void in
                if((response.result.value) != nil){
                    callback(JSON(response.result.value!))
                } else {
                    callback(JSON([
                        "status_code" : 500
                    ]))
                }
        }
        
    }
    
    
    // MARK: Create a room
    static func createRoom(userName:String, userEmail:String, userPassword:String, partnerName:String, partnerEmail:String, partnerPassword:String, callback: (JSON) -> ()){
        
        let parameters = [
            "user_name"         : userName,
            "user_email"        : userEmail,
            "user_password"     : userPassword,
            "partner_name"      : partnerName,
            "partner_email"     : partnerEmail,
            "partner_password"  : partnerPassword
        ]
        
        let urlAPI = NSURL(string: Api.baseUrl + "create-room/");
        
        Alamofire.request(.POST, urlAPI!, parameters: parameters, encoding: .JSON, headers: Api.headers)
                 .responseJSON { (response) -> Void in
                    if((response.result.value) != nil){
                        callback(JSON(response.result.value!))
                    } else {
                        callback(JSON([
                            "status_code" : 500
                        ]))
                    }
                    
        }
        
    }
    
    
    // MARK: Get dashboard Information
    static func getTasksForDashboard(callback: (tasks:[TaskProgress]) -> ()) {
        
        let userId    = LocalStorage.getUserId()!
        let partnerId = LocalStorage.getPartnerId()!
                
        let urlAPI = NSURL(string: "\(Api.baseUrl)dashboard/\(userId)/\(partnerId)");
        
        Alamofire.request(.GET, urlAPI!, parameters: nil, encoding: .JSON, headers: Api.headers)
            .responseJSON { (response) -> Void in
                let tasks = TaskProgress.moviesFromJson(response.result.value!)
                callback(tasks: tasks)
                
        }
    }
    
    
    // MARK: Get all categories
    static func getCategories(callback: (categories:[Category]) -> ()) {
        
        let urlAPI = NSURL(string: "\(Api.baseUrl)categories/");
        
        Alamofire.request(.GET, urlAPI!, parameters: nil, encoding: .JSON, headers: Api.headers)
            .responseJSON { (response) -> Void in
                let categories = Category.categoriesFromJson(response.result.value!)
                callback(categories: categories)
                
        }
        
    }
    
    
    // MARK: Add new task
    static func addTask(categoryId: Int, name: String, callback:(JSON) -> ()) {
        
        let urlAPI = NSURL(string: "\(Api.baseUrl)add-task")
        
        let parameters = [
            "category_id" : categoryId,
            "name"        : name,
        ]
        
        Alamofire.request(.POST, urlAPI!, parameters: parameters as? [String : AnyObject], encoding: .JSON, headers: Api.headers)
            .responseJSON { (response) -> Void in
                callback(JSON(response.result.value!))
        }
        
    }
    
    
    // MARK: Delete task
    static func deleteTask(taskId: Int, callback: (Bool) -> ()) {
        
        let urlAPI = NSURL(string: "\(Api.baseUrl)delete-task")
        
        let parameters = [
            "task_id" : taskId
        ]
        
        Alamofire.request(.POST, urlAPI!, parameters: parameters, encoding: .JSON, headers: Api.headers)
            .responseJSON { (response) -> Void in
                callback(true)
                
        }
    }
    
    
    // MARK: Profiles
    static func getProfiles(callback: (JSON) -> ()){
        
        let userId    = LocalStorage.getUserId()!
        let partnerId = LocalStorage.getPartnerId()!
        
        let urlAPI = NSURL(string: "\(Api.baseUrl)profiles/\(userId)/\(partnerId)");
        
        Alamofire.request(.GET, urlAPI!, parameters: nil, encoding: .JSON, headers: Api.headers)
            .responseJSON { (response) -> Void in
                callback(JSON(response.result.value!))
                
        }

    }
    
    
    // MARK: Get Categories stats
    static func getCategoriesStats(callback: (categories:[CategoryStat]) -> ()) {
        
        let userId    = LocalStorage.getUserId()!
        let partnerId = LocalStorage.getPartnerId()!
        
        let urlAPI = NSURL(string: "\(Api.baseUrl)tasks-profiles/\(userId)/\(partnerId)");
        
        Alamofire.request(.GET, urlAPI!, parameters: nil, encoding: .JSON, headers: Api.headers)
            .responseJSON { (response) -> Void in
                let categories = CategoryStat.categoriesStatsFromJson(response.result.value!)
                callback(categories: categories)
                
        }
    }
    
    
    // MARK: Add badge
    static func addBadge(category:String, message:String, callback: (Bool) -> ()){
        
        let userId = LocalStorage.getUserId()!
        
        let urlAPI = NSURL(string: "\(Api.baseUrl)add-badge/")
        
        let parameters = [
            "user_id"   : userId,
            "category"  : category,
            "message"   : message,
        ]
        
        Alamofire.request(.POST, urlAPI!, parameters: parameters as? [String : AnyObject], encoding: .JSON, headers: Api.headers)
            .responseJSON { (response) -> Void in
                callback(true)
        }
        
    }
    
    
    // MARK: Ask sorry
    static func askSorry(message:String){
        
        let partnerId = LocalStorage.getPartnerId()!
        
        let urlAPI = NSURL(string: "\(Api.baseUrl)sorry/")
        
        let parameters = [
            "user_id"   : partnerId,
            "message"   : message,
        ]
        
        Alamofire.request(.POST, urlAPI!, parameters: parameters as? [String : AnyObject], encoding: .JSON, headers: Api.headers)
            .responseJSON { (response) -> Void in
                print("Sorry added")
        }

    }
    
    
    // MARK: Delete sorry
    static func deleteSorry(accepted:Int){
        let userId = LocalStorage.getUserId()!
        
        let urlAPI = NSURL(string: "\(Api.baseUrl)sorry/\(userId)/\(accepted)")
        
        
        Alamofire.request(.DELETE, urlAPI!, parameters: nil, encoding: .JSON, headers: Api.headers)
            .responseJSON { (response) -> Void in
                print("Sorry delete")
        }

    }
    
    
    // MARK: Get sorry
    static func getSorry(callback: (JSON) -> ()){
        
        let userId = LocalStorage.getUserId()!
        let urlAPI = NSURL(string: "\(Api.baseUrl)sorry/\(userId)")
        
        Alamofire.request(.GET, urlAPI!, parameters: nil, encoding: .JSON, headers: Api.headers)
            .responseJSON { (response) -> Void in
                callback(JSON(response.result.value!))
                
        }
        
    }
    
    
    // MARK: Update Task Progress
    static func updateTaskProgress(userId: Int, taskId: Int, callback: (Bool) -> ()){
        
        let urlAPI = NSURL(string: "\(Api.baseUrl)task/\(taskId)/\(userId)")
        
        Alamofire.request(.PUT, urlAPI!, parameters: nil, encoding: .JSON, headers: Api.headers)
            .responseJSON { (response) -> Void in
                callback(true)
                
        }
    }
    
}