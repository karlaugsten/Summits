//
//  User.swift
//  Summits
//
//  Created by Karl Augsten on 2014-11-28.
//  Copyright (c) 2014 Summits LLC. All rights reserved.
//

import Foundation

var user = User()

class User {
    var username:String
    var password:String
    var profilePicture:String
    
    init(){
        self.username = ""
        self.password = ""
        self.profilePicture = ""
    }
}
