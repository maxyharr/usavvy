//
//  HostFormViewController.swift
//  USavvy
//
//  Created by Max Harris on 11/23/14.
//  Copyright (c) 2014 Max Harris. All rights reserved.
//

import UIKit

protocol HostFormViewControllerDelegate {
    func didFinishCreatingPosting(posting: Posting)
}

class HostFormViewController: UIViewController, UITableViewDataSource, UITableViewDelegate, UINavigationControllerDelegate, UIImagePickerControllerDelegate, UITextFieldDelegate, DateSelectorDelegate {
    
    var frameView: UIView!
    
    enum Section:Int{
        case Title = 0
        case Spots = 1
        case StartTime = 2
        case EndTime = 3
        case Description = 4
        case Picture = 5
        case Cost = 6
        case Location = 7
    }
    
    let timeDisplay:MHTimeDisplay = MHTimeDisplay()
    var startTimeSelected = false
    var finishTimeSelected = false
    var pictureSelected = false
    var startTime = NSDate()
    var endTime = NSDate()
    var spots = 0
    var experienceDescription = ""
    var picture = UIImage()
    var cost = 0
    var location = ""
    let imageCropper = ImageCropper();
    
    var delegate:HostFormViewControllerDelegate? = nil

    @IBOutlet weak var hostFormTableView: UITableView!
    @IBOutlet weak var descriptionTextView: UITextView!
    @IBOutlet weak var experienceImageView: UIImageView!
    @IBOutlet weak var uploadPictureButton: UIButton!
    var picker:UIImagePickerController? = UIImagePickerController()
    var popover:UIPopoverController? = nil
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.frameView = UIView(frame: CGRectMake(0, 0, self.view.bounds.width, self.view.bounds.height))
        
        // Keyboard Stuff
        var center: NSNotificationCenter = NSNotificationCenter.defaultCenter()
        center.addObserver(self, selector: "keyboardWillShow:", name: UIKeyboardWillShowNotification, object: nil)
        center.addObserver(self, selector: "keyboardWillHide:", name: UIKeyboardWillHideNotification, object: nil)
        
//        self.hostFormTableView.estimatedRowHeight = 300.0;
//        self.hostFormTableView.rowHeight = UITableViewAutomaticDimension;
    }
    

    func keyboardWillShow(notification: NSNotification) {
        var info:NSDictionary = notification.userInfo!
        var keyboardSize = (info[UIKeyboardFrameBeginUserInfoKey] as NSValue).CGRectValue()
        var keyboardHeight:CGFloat = keyboardSize.height
        var animationDuration:CGFloat = info[UIKeyboardAnimationDurationUserInfoKey] as CGFloat
        
//        UIView.animateWithDuration(0.25, delay: 0.25, options: UIViewAnimationOptions.CurveEaseInOut, animations: {
//            self.frameView.frame = CGRectMake(0, (self.frameView.frame.origin.y - keyboardHeight), self.view.bounds.width, self.view.bounds.height)
//        }, completion: nil)
        
        //hostFormTableView.setContentOffset(CGPointMake(0, keyboardHeight), animated: true)
        
    }
    
    func keyboardWillHide(notification: NSNotification) {
        var info:NSDictionary = notification.userInfo!
        var keyboardSize = (info[UIKeyboardFrameBeginUserInfoKey] as NSValue).CGRectValue()
        
        var keyboardHeight:CGFloat = keyboardSize.height
        
        var animationDuration:CGFloat = info[UIKeyboardAnimationDurationUserInfoKey] as CGFloat
        
//        UIView.animateWithDuration(0.25, delay: 0.25, options: UIViewAnimationOptions.CurveEaseInOut, animations: {
//            self.frameView.frame = CGRectMake(0, (self.frameView.frame.origin.y + keyboardHeight), self.view.bounds.width, self.view.bounds.height)
//            }, completion: nil)
        //hostFormTableView.setContentOffset(CGPointMake(0, -keyboardHeight), animated: true)
    }

    override func viewWillDisappear(animated: Bool) {
        NSNotificationCenter.defaultCenter().removeObserver(self, name: UIKeyboardWillShowNotification, object: nil)
        NSNotificationCenter.defaultCenter().removeObserver(self, name: UIKeyboardWillHideNotification, object: nil)
    }
    
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        // Title, begin date, end date, spots, description, pictures, costToGuest, location, submit
        return 7
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        switch section {
        case Section.Title.rawValue, Section.Spots.rawValue, Section.Description.rawValue: return 1
        case Section.StartTime.rawValue:  if (startTimeSelected) {return 2} else {return 1}
        case Section.EndTime.rawValue:  if (finishTimeSelected){return 2} else {return 1}
        case Section.Picture.rawValue: return 2 //if (pictureSelected){return 2} else {return 1}
        case Section.Cost.rawValue: return 1
        default: return 0
        }
    }
    
    func tableView(tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return UIScreen.mainScreen().bounds.width * 0.1
    }
    
    func tableView(tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        switch section {
        case Section.Title.rawValue: return "Title:"
        case Section.StartTime.rawValue: return "Start Time:"
        case Section.EndTime.rawValue: return "End Time:"
        case Section.Spots.rawValue: return "Number of Spots:"
        case Section.Description.rawValue: return "Description:"
        case Section.Picture.rawValue: return "Picture:"
        case Section.Cost.rawValue: return "Cost:"
        default: return ""
        }
     }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        switch indexPath.section {
        case Section.Title.rawValue: return tableView.dequeueReusableCellWithIdentifier("textCell") as SimpleTextCell
        case Section.StartTime.rawValue, Section.EndTime.rawValue:
            if (indexPath.row == 0) {
                let cell = tableView.dequeueReusableCellWithIdentifier("pickerCell") as DatePickerCell
                if (indexPath.section == Section.StartTime.rawValue) {
                    if (!startTimeSelected) {cell.label.text = "Add Start Time"}
                    else {cell.label.text = "Edit Start Time"}
                }
                else {
                    if (!finishTimeSelected) {cell.label.text = "Add End Time"}
                    else {cell.label.text = "Edit End Time"}
                }
                
                return cell
            } else {
                let cell = tableView.dequeueReusableCellWithIdentifier("basicCell") as BasicCell
                if (indexPath.section == Section.StartTime.rawValue) {cell.label.text = timeDisplay.dateAndTimeSimple(startTime)}
                else {cell.label.text = timeDisplay.dateAndTimeSimple(endTime)}
                return cell
            }
        
        case Section.Spots.rawValue:
            let cell = tableView.dequeueReusableCellWithIdentifier("numberInputCell") as simpleNumberInputCell
            cell.numberField.placeholder = "How many spots are still open?"
            return cell
        case Section.Description.rawValue:
            let cell = tableView.dequeueReusableCellWithIdentifier("descriptionCell") as DescriptionCell
            cell.descriptionTextView.text = "Please describe the experience as best as possible. Provide details like skill level expected, equipment provided, additional location information, and similar..."
            cell.descriptionTextView.textColor = UIColor.lightGrayColor()
            return cell
        case Section.Picture.rawValue:
            if indexPath.row == 0 {
                let cell = tableView.dequeueReusableCellWithIdentifier("pickerCell") as DatePickerCell
                cell.label.text = "Choose Picture"
                return cell
            }
            
            else {
                let cell = tableView.dequeueReusableCellWithIdentifier("pictureCell") as PictureCell
                cell.pictureView.image = self.picture
                return cell
            }
        case Section.Cost.rawValue:
            let cell = tableView.dequeueReusableCellWithIdentifier("numberInputCell") as simpleNumberInputCell
            cell.numberField.placeholder = "Free, $10, $25, $50..."
            return cell
        case Section.Location.rawValue:
            let cell = tableView.dequeueReusableCellWithIdentifier("textCell") as SimpleTextCell
            cell.textField.placeholder = "Address or location description"
            return cell
            
        default: return UITableViewCell()
        }
    }
    
    func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        if indexPath.section == Section.Description.rawValue { return 200 }
        else if indexPath.section == Section.Picture.rawValue && indexPath.row == 1 { return UIScreen.mainScreen().bounds.width }
        return 44;
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        tableView.deselectRowAtIndexPath(indexPath, animated: true)
        if ((indexPath.section == Section.StartTime.rawValue || indexPath.section == Section.EndTime.rawValue) && indexPath.row == 0) { performSegueWithIdentifier("datePickerSegue", sender: indexPath) }
        
        else if indexPath.section == Section.Picture.rawValue && indexPath.row == 0 {
            uploadBackgroundPicture(self)
        }
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if let theSender = sender as? NSIndexPath {
            if (theSender.section == Section.StartTime.rawValue && theSender.row == 0) {
                let DVC = segue.destinationViewController as DateSelectorViewController
                DVC.delegate = self
                DVC.cameFrom = "start"
            } else if (theSender.section == Section.EndTime.rawValue && theSender.row == 0) {
                let DVC = segue.destinationViewController as DateSelectorViewController
                DVC.delegate = self
                DVC.cameFrom = "end"
            }
        }
    }
    
    func updateTime(data: NSDate, cameFrom: String) {
        if (cameFrom == "start") {startTime = data; startTimeSelected = true}
        else if (cameFrom == "end") {endTime = data; finishTimeSelected = true}
        
    }
    
    
    @IBAction func uploadBackgroundPicture(sender: AnyObject) {
        picker?.delegate = self
        
        var alert:UIAlertController=UIAlertController(title: "Choose Image", message: nil, preferredStyle: UIAlertControllerStyle.ActionSheet)
        
        var cameraAction = UIAlertAction(title: "Camera", style: UIAlertActionStyle.Default)
            {
                UIAlertAction in
                self.openCamera()
                
        }
        var galleryAction = UIAlertAction(title: "Gallery", style: UIAlertActionStyle.Default)
            {
                UIAlertAction in
                self.openGallery()
        }
        var cancelAction = UIAlertAction(title: "Cancel", style: UIAlertActionStyle.Cancel)
            {
                UIAlertAction in
                
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
    
    func imagePickerController(picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [NSObject : AnyObject]) {
        self.pictureSelected = true;
        println("finished picking image")
        picker.dismissViewControllerAnimated(true, completion: nil)
        let cellWidth = UIScreen.mainScreen().bounds.width
        self.picture = imageCropper.squareImageWithImage(info[UIImagePickerControllerOriginalImage] as UIImage, newSize: CGSize(width: cellWidth, height: cellWidth))
        hostFormTableView.reloadData()
    }
    

    func imagePickerControllerDidCancel(picker: UIImagePickerController!) {
        self.dismissViewControllerAnimated(true, completion: nil)
        println("picker cancel.")
    }

    
    func openCamera() {
        println("opened camera")
            if(UIImagePickerController .isSourceTypeAvailable(UIImagePickerControllerSourceType.Camera)) {
                picker!.sourceType = UIImagePickerControllerSourceType.Camera
                self .presentViewController(picker!, animated: true, completion: nil)
            }
    }
    
    func openGallery()
    {
        println("opened gallery")
        
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
    
    @IBAction func completePosting(sender: AnyObject) {
        // return to previous screen
        
        let titleCell = hostFormTableView.cellForRowAtIndexPath(NSIndexPath(forRow: 0, inSection: Section.Title.rawValue)) as SimpleTextCell

        if (titleCell.textField.text.isEmpty) {
            let alert = UIAlertView()
            alert.title = "No Title"
            alert.message = "Please give the posting a title"
            alert.addButtonWithTitle("Ok")
            alert.show()
        } else if (self.descriptionTextView.text.isEmpty){
            let alert = UIAlertView()
            alert.title = "Description"
            alert.message = "Please describe the experience"
            alert.addButtonWithTitle("Ok")
            alert.show()
            
        } else { // SUCCESSFULLY CAN SAVE POSTING CREATION
            let user = PFUser.currentUser()
            
            if (delegate != nil) {
                // ###################################################################
                // ########             CREATE POSTING FOR PARSE             #########
                // ###################################################################
                
                // create image file in Parse
                let imageData = UIImageJPEGRepresentation(self.experienceImageView.image, 0.9)
                let imageFile = PFFile(name:"\(titleCell.textField.text).png", data:imageData)
                
                var experiencePhoto = PFObject(className:"ExperiencePhoto")
                experiencePhoto["imageName"] = "\(titleCell.textField.text)\'s image"
                experiencePhoto["imageFile"] = imageFile
                experiencePhoto.saveInBackgroundWithBlock(nil)
                
                // create Posting object in Parse
                var parsePosting = PFObject(className:"Posting")
                parsePosting["title"] = titleCell.textField.text
                parsePosting["description"] = self.descriptionTextView.text
                
                // set postings image to image created above
                parsePosting["experiencePhoto"] = imageFile
                parsePosting["user"] = user
                
                // save posting
                parsePosting.saveInBackgroundWithBlock(nil)
                println("uploaded Posting")
            
                
                // ###################################################################
                // ########             CREATE POSTING OBJECT - IOS          #########
                // ###################################################################
                
                var profPicImage:UIImage? = nil
                if let userImageFile = user["profilePicture"] as? PFFile {
                    userImageFile.getDataInBackgroundWithBlock {
                        (imageData: NSData!, error: NSError!) -> Void in
                        if error == nil {
                            let image = UIImage(data:imageData)
                            profPicImage = image!
                            println("saved User profile image successfully!")
                            
                            let hostFirstName = user["firstName"] as String
                            let hostLastName = user["lastName"] as String
                            let hostEmail = user["email"] as String
                            let hostDescription = user["personalDescription"] as String
                            
                            let host = User(firstName: hostFirstName, lastName: hostLastName, email: hostEmail, description: hostDescription, profilePicture: profPicImage!)
                            
                            
                            // Finally create an object to return to the Postings array in the Master
//                            let posting = Posting(title: titleCell.textField.text, description: self.descriptionTextView.text, picture: self.experienceImageView.image!, profPic: profPicImage!, host: host)
                            
//                            self.delegate!.didFinishCreatingPosting(posting)
                            self.navigationController?.popViewControllerAnimated(true)
                        }
                    }
                }
            }
        }
    }
    


    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func touchesBegan(touches: NSSet, withEvent event: UIEvent) {
        self.view.endEditing(true)
    }
    
    func textFieldShouldReturn(textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
    
    func textViewDidEndEditing(textView: UITextView) {
        if textView.text.isEmpty {
            textView.text = "Placeholder"
            textView.textColor = UIColor.lightGrayColor()
        }
    }

}
