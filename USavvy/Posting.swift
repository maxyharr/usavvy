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
    
    init(parsePosting: PFObject) {
        self.picture = UIImage()
        self.profPic = UIImage()
        self.host = User(firstName: "", lastName: "", email: "", description: "", profilePicture: UIImage())
        
        self.title = parsePosting["title"] as! String
        self.description = parsePosting["description"] as! String
        self.cost = parsePosting["cost"] as! String
        self.availableSpots = parsePosting["availableSpots"] as! String
        self.startTime = parsePosting["startTime"] as! NSDate
        self.endTime = parsePosting["endTime"] as! NSDate
        self.location = parsePosting["location"] as! String
        
        // Fish out experience photo
        let imageFile = parsePosting["experiencePhoto"]! as! PFFile
        imageFile.getDataInBackgroundWithBlock {
            (imageData: NSData!, error: NSError!) -> Void in
            if error == nil {
                let image = UIImage(data:imageData)
                self.picture = image!
            }
        }
        
        
        // Fish out host
        let parseUser = parsePosting["user"] as! PFUser
        let userid = parseUser.objectId as String!
        let query = PFUser.query()
        query.getObjectInBackgroundWithId(userid){
            (retrievedUser: PFObject!, error: NSError!) -> Void in
            if error == nil {
                // get user's profpic to store in iOS object
                var profPic:UIImage? = nil
                let profileImageFile = retrievedUser["profilePicture"]! as! PFFile
                profileImageFile.getDataInBackgroundWithBlock {
                    (imageData: NSData!, error: NSError!) -> Void in
                    if error == nil {
                        let hostFirstName = retrievedUser["firstName"] as! String
                        let hostLastName = retrievedUser["lastName"] as! String
                        let hostEmail = retrievedUser["email"] as! String
                        let hostDescription = retrievedUser["personalDescription"] as! String
                        
                        let image = UIImage(data:imageData)
                        self.profPic = image!
                        
                        let host = User(firstName: hostFirstName, lastName: hostLastName, email: hostEmail, description: hostDescription, profilePicture: UIImage())
                        self.host = host
                    }
                }
            }
        }

        
        
    }
}
