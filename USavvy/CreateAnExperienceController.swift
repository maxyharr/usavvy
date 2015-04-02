//
//  CreateAnExperienceController.swift
//  USavvy
//
//  Created by Maximilian Harris on 4/1/15.
//  Copyright (c) 2015 Max Harris. All rights reserved.
//

import UIKit

// Delegate Method to pass the newly created posting back to MasterViewController
protocol CreateAnExperienceDelegate {
    func didFinishCreatingPosting(posting: Posting)
}


class CreateAnExperienceController: UITableViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate, UITextFieldDelegate, DateSelectorDelegate {
    
    // Self Delegate
    var delegate:CreateAnExperienceDelegate? = nil
    
    
    // Field outlets to static cells
    @IBOutlet var experienceTableView: UITableView!
    @IBOutlet weak var titleField: UITextField!
    @IBOutlet weak var spotsField: UITextField!
    @IBOutlet weak var startTimeLabel: UILabel!
    @IBOutlet weak var endTimeLabel: UILabel!
    @IBOutlet weak var descriptionTextView: UITextView!
    @IBOutlet weak var uploadPictureButton: UIButton!
    @IBOutlet weak var costField: UITextField!
    @IBOutlet weak var locationField: UITextField!
    
    
    
    // Photo Variables
    var picker:UIImagePickerController? = UIImagePickerController()
    var popover:UIPopoverController? = nil
    let imageCropper = ImageCropper();
    
    
    
    
    
    
    
    // #################################################################
    // ####     TIME VARIABLES, SEGUES, and DELEGATE METHODS        ####
    // #################################################################
    
    // Pretty Time Display
    let timeDisplay:MHTimeDisplay = MHTimeDisplay()
    var startTime = NSDate()
    var endTime = NSDate()
    
    
    // Segue to pick a date
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        
        // Select Start Time
        if segue.identifier == "startTimePickerSegue" {
            
            let DVC = segue.destinationViewController as DateSelectorViewController
            DVC.delegate = self
            DVC.cameFrom = "start"
        }
            
            // Select End Time
        else if segue.identifier == "endTimePickerSegue" {
            
            let DVC = segue.destinationViewController as DateSelectorViewController
            DVC.delegate = self
            DVC.cameFrom = "end"
        }
    }
    
    // Delegate method called from DatePickerView
    func updateTime(data: NSDate, cameFrom: String) {
        
        println("********   updateTime delegate method fired!   *********")
        
        
        if (cameFrom == "start") {
            self.startTime = data
            self.startTimeLabel.text = timeDisplay.dateAndTimeSimple(data)
            self.experienceTableView.reloadData()
        }
        
        else if (cameFrom == "end") {
            self.endTime = data
            self.endTimeLabel.text = timeDisplay.dateAndTimeSimple(data)
            self.experienceTableView.reloadData()
        }
    }
    
    
    
    
    
    
    
    
    // #################################
    // ####     VIEW DID LOAD       ####
    // #################################
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if (self.uploadPictureButton.backgroundImageForState(UIControlState.Normal)) == nil {println("background pic is nil onload")}
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }

    override func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        if (indexPath.section == 6) { return 160 }
        if (indexPath.section == 7) { return UIScreen.mainScreen().bounds.width }
        return 44
    }
    
    
    
    
    
    
    
    
    
    // #####################################
    // ####     SUBMIT EXPERIENCE       ####
    // #####################################
    
    @IBAction func submitExperience(sender: AnyObject) {
        
        // Validate all fields
        if (self.titleField.text.isEmpty || self.spotsField.text.isEmpty || self.startTimeLabel.text == "Select Start Time" || self.endTimeLabel.text == "Select End Time" || self.descriptionTextView.text.isEmpty || self.uploadPictureButton.backgroundImageForState(UIControlState.Normal) == nil || self.costField.text.isEmpty || self.locationField.text.isEmpty) {
            let alert = UIAlertView()
            alert.title = "Not Finished"
            alert.message = "You must complete all fields to submit experience"
            alert.addButtonWithTitle("Ok")
            alert.show()
        }
        
            
        else {
            // Disable functionality
            UIApplication.sharedApplication().beginIgnoringInteractionEvents()
            
            let user = PFUser.currentUser()
            
            // ###################################################################
            // ########             CREATE POSTING FOR PARSE             #########
            // ###################################################################
            
            // Prepare the background image for uploading
            let imageData: NSData = UIImageJPEGRepresentation(self.uploadPictureButton.backgroundImageForState(UIControlState.Normal), 0.9)
            let imageFile: PFFile = PFFile(name:"\(self.titleField.text).png", data:imageData)
        
            
            
            // Create a Posting Object in Parse
            var posting = PFObject(className: "Posting")
            posting["experiencePhoto"] = imageFile
            posting["title"] = self.titleField.text
            posting["totalSpots"] = self.spotsField.text
            posting["availableSpots"] = self.spotsField.text
            posting["startTime"] = self.startTime
            posting["endTime"] = self.endTime
            posting["description"] = self.descriptionTextView.text
            posting["cost"] = self.costField.text
            posting["location"] = self.locationField.text
            posting["user"] = user
            
            
            
            
            // create the spinner
            let spinner = UIActivityIndicatorView(activityIndicatorStyle: UIActivityIndicatorViewStyle.Gray)

            posting.saveInBackgroundWithBlock {
                (success: Bool, error: NSError!) -> Void in
                print("Current Thread in saveInBackground: ")
                println( NSThread.currentThread() )
                
                
                // Display spinner
                dispatch_async(dispatch_get_main_queue()) {
                    self.view.addSubview(spinner)
                    spinner.startAnimating()
                    
                    print("Current Thread in dispatch_get_main_queue: ")
                    println( NSThread.currentThread() )

                }
                
                
                // Remove Spinner
                dispatch_async(dispatch_get_main_queue()) {
                    spinner.stopAnimating()
                }
                
                
                // Reenable Functionalility
                UIApplication.sharedApplication().endIgnoringInteractionEvents()
                
                
                // ###################################################################
                // ########             CREATE POSTING OBJECT - IOS          #########
                // ###################################################################
                
                //let retPosting = Posting(pfPosting: posting)
                //self.delegate!.didFinishCreatingPosting(retPosting)
                
                
                // Check for errors
                if (success) {
                    println("The object has been saved.")
                } else {
                    println("There was a problem, check error.description")
                    println(error.description)
                    
                    let alert = UIAlertView()
                    alert.title = "Error"
                    alert.message = "Your posting could not be saved. Please try again."
                    alert.addButtonWithTitle("Ok")
                    alert.show()
                }
                
                self.navigationController?.popViewControllerAnimated(true)
            }
        }
    }
    
    
    
    
    
    
    
    
    
    // #####################################
    // ####         UPLOAD PHOTO        ####
    // #####################################
    
    @IBAction func uploadPhoto(sender: AnyObject) {
        picker?.delegate = self
        
        var alert:UIAlertController = UIAlertController(title: "Choose Image", message: nil, preferredStyle: UIAlertControllerStyle.ActionSheet)
        
        var cameraAction = UIAlertAction(title: "Camera", style: UIAlertActionStyle.Default) {
                UIAlertAction in
                self.openCamera()
        }
        
        var galleryAction = UIAlertAction(title: "Gallery", style: UIAlertActionStyle.Default) {
                UIAlertAction in
                self.openGallery()
        }
        
        var cancelAction = UIAlertAction(title: "Cancel", style: UIAlertActionStyle.Cancel) {
                UIAlertAction in
                self.dismissViewControllerAnimated(true, completion: nil)
        }
        // Add the actions
        alert.addAction(cameraAction)
        alert.addAction(galleryAction)
        alert.addAction(cancelAction)
        // Present the actionsheet
        if UIDevice.currentDevice().userInterfaceIdiom == .Phone
        {
            self.presentViewController(alert, animated: true, completion: nil)
        }
        else
        {
            popover=UIPopoverController(contentViewController: alert)
            popover!.presentPopoverFromRect(uploadPictureButton.frame, inView: self.view, permittedArrowDirections: UIPopoverArrowDirection.Any, animated: true)
        }
    }
    
    func openCamera() {
        if(UIImagePickerController .isSourceTypeAvailable(UIImagePickerControllerSourceType.Camera)) {
            picker!.sourceType = UIImagePickerControllerSourceType.Camera
            self .presentViewController(picker!, animated: true, completion: nil)
        }
    }
    
    func openGallery()
    {
        picker!.sourceType = UIImagePickerControllerSourceType.PhotoLibrary
        if UIDevice.currentDevice().userInterfaceIdiom == .Phone
        {
            self.presentViewController(picker!, animated: true, completion: nil)
        }
        else
        {
            popover=UIPopoverController(contentViewController: picker!)
            popover!.presentPopoverFromRect(uploadPictureButton.frame, inView: self.view, permittedArrowDirections: UIPopoverArrowDirection.Any, animated: true)
        }
    }
    
    func imagePickerController(picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [NSObject : AnyObject]) {
        picker.dismissViewControllerAnimated(true, completion: nil)
        let cellWidth = UIScreen.mainScreen().bounds.width
        let image = imageCropper.squareImageWithImage(info[UIImagePickerControllerOriginalImage] as UIImage, newSize: CGSize(width: cellWidth, height: cellWidth))
        self.uploadPictureButton.setBackgroundImage(image, forState: UIControlState.Normal)
        self.experienceTableView.reloadData()
    }
    
    
    
    
    
    
    
    
    
    // #############################################
    // ####     TEXTFIELD DELEGATE METHODS      ####
    // #############################################
    
    func textFieldShouldReturn(textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
    
    
    
    
    
    
    
    // #####################################################
    // ####         TABLEVIEW DELEGATE METHODS          ####
    // #####################################################
    
    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        tableView.deselectRowAtIndexPath(indexPath, animated: true)
        if (indexPath.section == 2) { performSegueWithIdentifier("startTimePickerSegue", sender: self) }
        else if (indexPath.section == 3) { performSegueWithIdentifier("endTimePickerSegue", sender: self) }
    }
}
