//
//  ImageSelector.swift
//  USavvy
//
//  Created by Maximilian Harris on 3/19/15.
//  Copyright (c) 2015 Max Harris. All rights reserved.
//

import Foundation

//class ImageSelector {
//    var picker:UIImagePickerController? = UIImagePickerController()
//    var popover:UIPopoverController? = nil
//    
//    func selectImage(sender: AnyObject) -> UIImage {
//        picker?.delegate =
//        
//        var alert:UIAlertController=UIAlertController(title: "Choose Image", message: nil, preferredStyle: UIAlertControllerStyle.ActionSheet)
//        
//        var cameraAction = UIAlertAction(title: "Camera", style: UIAlertActionStyle.Default)
//            {
//                UIAlertAction in
//                sender.openCamera()
//                
//        }
//        var galleryAction = UIAlertAction(title: "Gallery", style: UIAlertActionStyle.Default)
//            {
//                UIAlertAction in
//                self.openGallery()
//        }
//        var cancelAction = UIAlertAction(title: "Cancel", style: UIAlertActionStyle.Cancel)
//            {
//                UIAlertAction in
//                
//        }
//        // Add the actions
//        alert.addAction(cameraAction)
//        alert.addAction(galleryAction)
//        alert.addAction(cancelAction)
//        // Present the actionsheet
//        if UIDevice.currentDevice().userInterfaceIdiom == .Phone
//        {
//            self.presentViewController(alert, animated: true, completion: nil)
//        }
//        else
//        {
//            popover=UIPopoverController(contentViewController: alert)
//            popover!.presentPopoverFromRect(uploadPictureButton.frame, inView: self.view, permittedArrowDirections: UIPopoverArrowDirection.Any, animated: true)
//        }
//    }
//}