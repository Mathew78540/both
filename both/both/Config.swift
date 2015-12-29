//
//  Config.swift
//  both
//
//  Created by Mathieu Le tyrant on 15/12/2015.
//  Copyright © 2015 Mathieu Le tyrant. All rights reserved.
//

import UIKit

class Config {
        
    // API URL
    static let apiURL:String = "http://localhost:8000/api/"
    
    // Background color navigationBar
    static let backgroundColorNavBar:String = "EF3061"
    
    // Badge value
    static let badgeValue:Int = 10
    
    // Success message
    static func getBadgeBaseOnCategory(category:String) ->String{
        
        switch category {
        case "KITCHEN_ROOM" : return "Yeah +10 points, la cuisine n’a plus de secret pour toi !"
        case "BATHROOM"     : return "Yeah +10 points, la salle de bain n’a plus de secret pour toi !"
        case "HOME"         : return "+10 points C’est qui le patron ?"
        case "WATCHING"     : return "Génial ! + 10 points Monsieur Propre c’est toi !"
        case "ANIMALS"      : return "+10 points Tu es un véritable ami des bêtes ! "
        default:              return "Congratulation ! You win a badge"
        }
        
    }
    
}