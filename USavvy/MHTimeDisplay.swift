//
//  MHTimeDisplay.swift
//  USavvy
//
//  Created by Maximilian Harris on 3/6/15.
//  Copyright (c) 2015 Max Harris. All rights reserved.
//

import Foundation

class MHTimeDisplay {
    func dateAndTimeSimple(date: NSDate) -> String {
        var dateFormat = NSDateFormatter()
        dateFormat.dateFormat = "EEEE, MMMM d, h:mm a"
        let dateString = dateFormat.stringFromDate(date)
        return dateString
    }
}