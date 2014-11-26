//
//  Profile.swift
//  USavvy
//
//  Created by Max Harris on 11/24/14.
//  Copyright (c) 2014 Max Harris. All rights reserved.
//

import Foundation

class Profile {
    var firstName : String
    var lastName : String
    var email : String
    var personalDescription : String
    var profilePicture : UIImage
    
    init(firstName: String, lastName: String, email: String, personalDescription: String, profilePicture: UIImage) {
        self.firstName = firstName
        self.lastName = lastName
        self.email = email
        self.personalDescription = personalDescription
        self.profilePicture = profilePicture
    }
}