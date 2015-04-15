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
    var location: String
    var startTime: NSDate
    var endTime: NSDate
    var profPic: UIImage
    var host:User
    
    init(title:String, description:String, cost:String, availableSpots: String, startTime: NSDate, endTime: NSDate, picture: UIImage, profPic: UIImage, host: User, location: String) {

        self.title = title
        self.description = description
        self.picture = ImageCropper.squareImageWithImage(picture, newSize: CGSizeMake(UIScreen.mainScreen().bounds.width, UIScreen.mainScreen().bounds.width))
        self.cost = cost
        self.availableSpots = availableSpots
        self.startTime = startTime
        self.endTime = endTime
        self.profPic = profPic
        self.host = host
        self.location = location


    }
}
