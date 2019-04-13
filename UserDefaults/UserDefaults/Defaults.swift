//
//  Defaults.swift
//  UserDefaults
//
//  Created by Ramon Geronimo on 4/13/19.
//  Copyright © 2019 Ramon Geronimo. All rights reserved.
//

import Foundation

struct Defaults {
    
    static let token = "token"
    static let tokenKey = "tokenKey"
    
    struct Model {
        var token: String?
        
        init(token: String) {
            //complete the initializer
            self.token = token
        }
    }
    
    var saveToken = { (token: String) in
        // Set
        UserDefaults.standard.set(token, forKey: "token")

    }
    
    var getToken = { () -> Model in
        // Get
        let token = Model(token: UserDefaults.standard.string(forKey: "token") ?? "")
        return token
    }
    
    func clearUserData(){
        //complete the method using removeObject
        UserDefaults.standard.removeObject(forKey: "token")
    }
}
