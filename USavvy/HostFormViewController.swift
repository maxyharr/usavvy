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

class HostFormViewController: UIViewController, UINavigationControllerDelegate, UIImagePickerControllerDelegate, UITextFieldDelegate {
    
    var delegate:HostFormViewControllerDelegate? = nil
    
    @IBOutlet weak var descriptionTextView: UITextView!
    @IBOutlet weak var titleField: UITextField!
    
    @IBOutlet weak var guestsField: UITextField!
    @IBOutlet weak var hoursField: UITextField!
    @IBOutlet weak var experienceImageView: UIImageView!
    
    @IBOutlet weak var uploadPictureButton: UIButton!
    var picker:UIImagePickerController? = UIImagePickerController()
    var popover:UIPopoverController? = nil
    
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
    
        println("finished picking image")
        picker .dismissViewControllerAnimated(true, completion: nil)
        
        self.experienceImageView.image = info[UIImagePickerControllerOriginalImage] as? UIImage
        self.experienceImageView.contentMode = UIViewContentMode.ScaleAspectFit
        //sets the selected image to image view
        
    }
    

    func imagePickerControllerDidCancel(picker: UIImagePickerController!) {
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
        
        if (self.titleField.text.isEmpty) {
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
                let imageFile = PFFile(name:"\(self.titleField.text).png", data:imageData)
                
                var experiencePhoto = PFObject(className:"ExperiencePhoto")
                experiencePhoto["imageName"] = "\(self.titleField.text)\'s image"
                experiencePhoto["imageFile"] = imageFile
                experiencePhoto.saveInBackgroundWithBlock(nil)
                
                // create Posting object in Parse
                var parsePosting = PFObject(className:"Posting")
                parsePosting["title"] = self.titleField.text
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
                            let posting = Posting(title: self.titleField.text, description: self.descriptionTextView.text, picture: self.experienceImageView.image!, profPic: profPicImage!, host: host)
                            
                            self.delegate!.didFinishCreatingPosting(posting)
                            self.navigationController?.popViewControllerAnimated(true)
                        }
                    }
                }
            }
        }
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
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


    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
