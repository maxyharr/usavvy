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
    
    class func dateSimple(startTime: NSDate) -> String {
        var dateFormat = NSDateFormatter()
        dateFormat.dateFormat = "EEEE, MMMM d"
        let dateString = dateFormat.stringFromDate(startTime)
        return dateString
    }
    
    class func startToEnd(startTime: NSDate, endTime: NSDate) -> String {
        var dateFormat = NSDateFormatter()
        
        // start time
        dateFormat.dateFormat = "h:mm a"
        let startString = dateFormat.stringFromDate(startTime)
        
        
        // end time
        dateFormat.dateFormat = "h:mm a"
        let endString = dateFormat.stringFromDate(endTime)
        
        
        // combine them
        let startEndString = startString + " - " + endString
        
        
        return startEndString
    }
}