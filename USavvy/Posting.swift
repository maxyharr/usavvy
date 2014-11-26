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
    var numGuests: String
    var numHours: String
    var description: String
    var picture: UIImage
    var profPic: UIImage
    
    init(title:String, numGuests:String, numHours: String, description:String, picture: UIImage, profPic: UIImage) {
        self.title = title
        self.numGuests = numGuests
        self.numHours = numHours
        self.description = description
        self.picture = picture
        self.profPic = profPic
    }
}
