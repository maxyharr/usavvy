//
//  User.swift
//  USavvy
//
//  Created by Maximilian Harris on 3/5/15.
//  Copyright (c) 2015 Max Harris. All rights reserved.
//

import Foundation

class User {
    var firstName:String
    var lastName:String
    var name:String
    var email:String
    var description:String
    var profilePicture:UIImage
    
    init(firstName:String, lastName:String, email:String, description:String, profilePicture:UIImage) {
        self.firstName = firstName
        self.lastName = lastName
        self.name = "\(firstName) \(lastName)"
        self.email = email
        self.description = description
        self.profilePicture = profilePicture
    }
}