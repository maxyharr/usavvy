//
//  ImageCropper.swift
//  USavvy
//
//  Created by Maximilian Harris on 3/5/15.
//  Copyright (c) 2015 Max Harris. All rights reserved.
//

import Foundation

class ImageCropper {
    func squareImageWithImage(image: UIImage, newSize: CGSize) -> UIImage {
        var ratio:CGFloat = 0.0
        var delta:CGFloat = 0.0
        var offset:CGPoint
        
        //make a new square size, that is the resized imaged width
        var sz = CGSizeMake(newSize.width, newSize.height)
        
        /*figure out if the picture is landscape or portrait , then
        calculate scale factor and offset */
        if (image.size.width > image.size.height) {
            ratio = (newSize.width / image.size.width)
            delta = ratio*image.size.width - ratio*image.size.height
            offset = CGPointMake(delta/2, 0)
        } else {
            ratio = newSize.width / image.size.height
            delta = ratio*image.size.height - ratio*image.size.width
            offset = CGPointMake(0, delta/2)
        }
        
        //make the final clippin rect based on the calculated values
        var clipRect = CGRectMake(-offset.x, -offset.y, (ratio * image.size.width) + delta, (ratio * image.size.height) + delta)
        
        /*start a new context, with scale factor 0.0 so retina displays get
        high quality image*/
        if (UIScreen.mainScreen().respondsToSelector(Selector("scale"))) {
            UIGraphicsBeginImageContextWithOptions(sz, true, 0.0)
        } else {
            UIGraphicsBeginImageContext(sz)
        }
        
        UIRectClip(clipRect)
        image.drawInRect(clipRect)
        var newImage:UIImage = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        
        return newImage
    }
    
    class func squareImageWithImage(image: UIImage, newSize: CGSize) -> UIImage {
        var ratio:CGFloat = 0.0
        var delta:CGFloat = 0.0
        var offset:CGPoint
        
        //make a new square size, that is the resized imaged width
        var sz = CGSizeMake(newSize.width, newSize.height)
        
        /*figure out if the picture is landscape or portrait , then
        calculate scale factor and offset */
        if (image.size.width > image.size.height) {
            ratio = (newSize.width / image.size.width)
            delta = ratio*image.size.width - ratio*image.size.height
            offset = CGPointMake(delta/2, 0)
        } else {
            ratio = newSize.width / image.size.height
            delta = ratio*image.size.height - ratio*image.size.width
            offset = CGPointMake(0, delta/2)
        }
        
        //make the final clippin rect based on the calculated values
        var clipRect = CGRectMake(-offset.x, -offset.y, (ratio * image.size.width) + delta, (ratio * image.size.height) + delta)
        
        /*start a new context, with scale factor 0.0 so retina displays get
        high quality image*/
        if (UIScreen.mainScreen().respondsToSelector(Selector("scale"))) {
            UIGraphicsBeginImageContextWithOptions(sz, true, 0.0)
        } else {
            UIGraphicsBeginImageContext(sz)
        }
        
        UIRectClip(clipRect)
        image.drawInRect(clipRect)
        var newImage:UIImage = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        
        return newImage
    }
    
}