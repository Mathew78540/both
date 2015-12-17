import UIKit
import SwiftyJSON

class Category: NSObject {
    
    var id:Int!
    var category:String!
    var name:String!
    
    override init() {}
    
    init(id:Int, name:String, category:String) {
        self.id         = id
        self.category   = category
        self.name       = name
    }
}

extension Category {
    
    convenience init(json:JSON) {
        self.init()
        
        self.category   = json["category"].string ?? ""
        self.id         = json["id"].int ?? 0
        self.name       = json["name"].string ?? ""
        
    }
    
    static func categoriesFromJson(json:AnyObject) -> [Category] {
        
        var categories = [Category]()
        
        let jsonObject = JSON(json)
        
        if let categoriesResults = jsonObject["data"].array {
            for categoryResult in categoriesResults {
                categories.append(Category(json: categoryResult))
            }
        }
        
        return categories
        
    }
    
}







