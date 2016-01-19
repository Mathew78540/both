import UIKit
import SwiftyJSON

class TaskProgress: NSObject {
    
    var name:String!
    var category:String!
    var difference:Int!
    var id:Int!
    
    override init() {}
    
    init(name:String, category:String, difference:Int, id:Int) {
        self.id         = id
        self.name       = name
        self.category   = category
        self.difference = difference
    }
}

extension TaskProgress {
    
    convenience init(json:JSON) {
        self.init()
        
        self.name       = json["name"].string ?? ""
        self.category   = json["category"]["category"].string ?? ""
        self.difference = json["difference"].int ?? 0
        self.id         = json["id"].int ?? 0
        
    }
    
    static func moviesFromJson(json:AnyObject) -> [TaskProgress] {
        
        var tasks = [TaskProgress]()
        
        let jsonObject = JSON(json)
        
        if let tasksResults = jsonObject["tasks"].array {
            for tasksResult in tasksResults {
                tasks.append(TaskProgress(json: tasksResult))
            }
        }
        
        return tasks
        
    }
    
}







