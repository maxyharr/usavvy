//
//  ProfileViewController.swift
//  USavvy
//
//  Created by Maximilian Harris on 4/14/15.
//  Copyright (c) 2015 Max Harris. All rights reserved.
//

import UIKit

protocol ProfileViewControllerDelegate {
    func userDidFinishUpdatingProfile()
}

class ProfileViewController: UITableViewController, UINavigationControllerDelegate, UIImagePickerControllerDelegate, UITextFieldDelegate {
    var delegate:ProfileViewControllerDelegate? = nil
    let imageWidth = UIScreen.mainScreen().bounds.width*0.25
    
    var user = PFUser.currentUser()
    
    var picker:UIImagePickerController? = UIImagePickerController()
    var popover:UIPopoverController? = nil
    
    
    @IBOutlet weak var profileImageView: UIImageView!
    @IBOutlet weak var profilePictureButton: UIButton!
    @IBOutlet weak var firstNameField: UITextField!
    @IBOutlet weak var lastNameField: UITextField!
    @IBOutlet weak var emailField: UITextField!
    @IBOutlet weak var descriptionTextView: UITextView!
    
    @IBAction func saveChanges(sender: AnyObject) {
        println("trying to save changes")
        if delegate != nil {
            println("delegate was indeed not nil")
            user["firstName"] = self.firstNameField.text
            user["lastName"] = self.lastNameField.text
            user["personalDescription"] = self.descriptionTextView.text
            user["email"] = self.emailField.text
            user.saveInBackgroundWithBlock(nil)
            
            let imageData = UIImageJPEGRepresentation(self.profileImageView.image, 0.9)
            let imageFile = PFFile(name:"image.png", data:imageData)
            
            var userPhoto = PFObject(className:"UserPhoto")
            userPhoto["imageName"] = "\(user.email)\'s profile\'s image"
            userPhoto["imageFile"] = imageFile
            userPhoto.saveInBackgroundWithBlock(nil)
            
            user["profilePicture"] = imageFile
            user.saveInBackgroundWithBlock {
                (success: Bool, error: NSError!) -> Void in
                if error == nil {
                    let alert = UIAlertView()
                    alert.title = "Saved"
                    alert.message = "Profile successfully updated"
                    alert.addButtonWithTitle("Ok")
                    alert.show()
                    self.delegate!.userDidFinishUpdatingProfile()
                    self.navigationController?.popViewControllerAnimated(true)
                }
            }
        }
        
    }
    
    @IBAction func logout(sender: AnyObject) {
        PFUser.logOut()
        
        let delegate = UIApplication.sharedApplication().delegate as! AppDelegate
        delegate.setUpRootViewController(false, animated: false, alert: true)
    }
    
    @IBAction func uploadPicture(sender: AnyObject) {
        
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
            popover!.presentPopoverFromRect(profilePictureButton.frame, inView: self.view, permittedArrowDirections: UIPopoverArrowDirection.Any, animated: true)
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
            popover!.presentPopoverFromRect(profilePictureButton.frame, inView: self.view, permittedArrowDirections: UIPopoverArrowDirection.Any, animated: true)
        }
    }
    
    func imagePickerController(picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [NSObject : AnyObject]) {
        
        picker.dismissViewControllerAnimated(true, completion: nil)
        
        //sets the selected image to image view
        if let image = info[UIImagePickerControllerOriginalImage] as? UIImage {
                self.profileImageView.image = ImageCropper.squareImageWithImage(image, newSize: CGSizeMake(imageWidth, imageWidth))
        }
    }
    
    override func viewWillAppear(animated: Bool) {
        self.navigationController?.setToolbarHidden(false, animated: true)
    }
    
    override func viewWillDisappear(animated: Bool) {
        self.navigationController?.setToolbarHidden(true, animated: true)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        refreshUserInfo()
        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem()
    }

    func refreshUserInfo() {
        self.emailField.text = user.email
        // making API calls each time I think. Could be stored in a user object to make better
        
        if let firstName = user["firstName"] as? String{
            self.firstNameField.text = firstName
        }
        if let lastName = user["lastName"] as? String {
            self.lastNameField.text = lastName
        }
        
        if let personalDescription = user["personalDescription"] as? String {
            self.descriptionTextView.text = personalDescription
        }
        
        if let userImageFile = user["profilePicture"] as? PFFile {
            userImageFile.getDataInBackgroundWithBlock {
                (imageData: NSData!, error: NSError!) -> Void in
                if error == nil {
                    let image = UIImage(data:imageData)
                    self.profileImageView.image = image
                }
            }
        }
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    
//    override func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
//        let width = imageWidth
//        
//        if indexPath.section == 0 {
//            if indexPath.row == 0 { return width }
//        }
//        
//        else if indexPath.section == 1 {
//            if indexPath.row == 0 { return UIScreen.mainScreen().bounds.width * 0.5 }
//        }
//        
//        return 44
//    }

    // MARK: - Table view data source

    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 4
    }

    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if section == 0 { return 4 }
        else if section == 1 { return 1 }
//        else if section == 2 { return host.favoritedPostings.count }
//        else if section == 3 { return host.postings.count }
        else { return 1 }
    }


//    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
////        if indexPath.section == 0 {
////            if indexPath.row == 0 {
////                return tableView.dequeueReusableCellWithIdentifier("profilePictureIdentifier") as! UITableViewCell
////            }
////            
////            else { return tableView.dequeueReusableCellWithIdentifier("commonIdentifier") as! UITableViewCell }
////        }
//        
////        else if indexPath.section == 1 {
////            return tableView.dequeueReusableCellWithIdentifier("descriptionIdentifier") as! UITableViewCell
////        }
//        
//        if indexPath.section == 2 {
//            let cell = tableView.dequeueReusableCellWithIdentifier("favoriteCell") as! UITableViewCell
//            cell.textLabel?.text = ""
//        }
//        
//        else if indexPath.section == 3 {
//            return tableView.dequeueReusableCellWithIdentifier("myPostingCell") as! UITableViewCell
//        }
//        
//        return tableView.dequeueReusableCellWithIdentifier("reuseIdentifier", forIndexPath: indexPath) as! UITableViewCell
//        
//    }

    /*
    // Override to support conditional editing of the table view.
    override func tableView(tableView: UITableView, canEditRowAtIndexPath indexPath: NSIndexPath) -> Bool {
        // Return NO if you do not want the specified item to be editable.
        return true
    }
    */

    /*
    // Override to support editing the table view.
    override func tableView(tableView: UITableView, commitEditingStyle editingStyle: UITableViewCellEditingStyle, forRowAtIndexPath indexPath: NSIndexPath) {
        if editingStyle == .Delete {
            // Delete the row from the data source
            tableView.deleteRowsAtIndexPaths([indexPath], withRowAnimation: .Fade)
        } else if editingStyle == .Insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
        }    
    }
    */

    /*
    // Override to support rearranging the table view.
    override func tableView(tableView: UITableView, moveRowAtIndexPath fromIndexPath: NSIndexPath, toIndexPath: NSIndexPath) {

    }
    */

    /*
    // Override to support conditional rearranging of the table view.
    override func tableView(tableView: UITableView, canMoveRowAtIndexPath indexPath: NSIndexPath) -> Bool {
        // Return NO if you do not want the item to be re-orderable.
        return true
    }
    */

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using [segue destinationViewController].
        // Pass the selected object to the new view controller.
    }
    */

}
