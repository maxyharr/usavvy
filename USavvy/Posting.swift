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
    var profPic: UIImage
    var host:User
    
    init(title:String, description:String, picture: UIImage, profPic: UIImage, host: User) {

        self.title = title
        self.description = description
        self.picture = picture
        self.profPic = profPic
        self.host = host

    }
}
