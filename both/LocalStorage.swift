//
//  LocalStorage.swift
//  both
//
//  Created by Le Tyrant Mathieu on 01/06/2015.
//  Copyright (c) 2015 both. All rights reserved.
//

import Foundation

struct LocalStorage {
    
    static let userDefault = NSUserDefaults.standardUserDefaults()

    // MARK: Setter
    
    static func setUserID(id: Int){
        userDefault.setInteger(id, forKey: "userId")
    }
    
    static func setPartnerUserID(id: Int) {
        userDefault.setInteger(id, forKey: "parterId")
    }
    
    static func setRoomToken(token: String) {
        userDefault.setObject(token, forKey: "roomToken")
    }
    
    static func setConnected() {
        userDefault.setInteger(1, forKey: "connected")
    }
    
    
    // MARK: Getter
    
    static func getUserId() -> Int? {
        return userDefault.integerForKey("userId")
    }
    
    static func getPartnerId() -> Int? {
        return userDefault.integerForKey("parterId")
    }
    
    static func getToken() -> String? {
        return userDefault.stringForKey("roomToken")
    }
    
    static func getConnected() -> Int? {
        return userDefault.integerForKey("connected")
    }
    
    
    // MARK: Clean LocalStorage
    
    static func cleanLocal() {
        userDefault.removeObjectForKey("userId")
        userDefault.removeObjectForKey("parterId")
        userDefault.removeObjectForKey("roomToken")
        userDefault.removeObjectForKey("connected")
    }
    
}