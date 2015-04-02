//
//  Posting.swift
//  USavvy
//
//  Created by Max Harris on 11/24/14.
//  Copyright (c) 2014 Max Harris. All rights reserved.
//

import Foundation

class Posting {
    var title: String
    var description: String
    var picture: UIImage
    var cost: String
    var availableSpots: String
    var profPic: UIImage
    var host:User
    
    init(title:String, description:String, cost:String, availableSpots: String, picture: UIImage, profPic: UIImage, host: User) {

        self.title = title
        self.description = description
        self.picture = picture
        self.cost = cost
        self.availableSpots = availableSpots
        self.profPic = profPic
        self.host = host


    }
}
