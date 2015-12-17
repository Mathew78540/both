//
//  CategoryStat.swift
//  both
//
//  Created by Mathieu Le tyrant on 16/12/2015.
//  Copyright © 2015 Mathieu Le tyrant. All rights reserved.
//

import UIKit
import SwiftyJSON

class CategoryStat: NSObject {
    
    var category:String!
    var name:String!
    var me: Int!
    var partner: Int!
    var meName: String!
    var partnerName: String!
    
    override init() {}
    
    init(name:String, category:String, me:Int, partner:Int, meName:String, partnerName:String) {
        self.category       = category
        self.name           = name
        self.me             = me
        self.partner        = partner
        self.meName         = meName
        self.partnerName    = partnerName
    }
}

extension CategoryStat {
    
    convenience init(json:JSON) {
        self.init()
        
        self.category       = json["category"].string ?? ""
        self.name           = json["name"].string ?? ""
        self.me             = json["me"].int ?? 0
        self.partner        = json["partner"].int ?? 0
        self.meName         = json["me_name"].string ?? ""
        self.partnerName    = json["partner_name"].string ?? ""

    }
    
    static func categoriesStatsFromJson(json:AnyObject) -> [CategoryStat] {
        
        var categories = [CategoryStat]()
        
        let jsonObject = JSON(json)
        
        if let categoriesResults = jsonObject["data"].array {
            for categoryResult in categoriesResults {
                categories.append(CategoryStat(json: categoryResult))
            }
        }
        
        return categories
        
    }
    
}














