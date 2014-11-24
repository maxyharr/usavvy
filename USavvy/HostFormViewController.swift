//
//  HostFormViewController.swift
//  USavvy
//
//  Created by Max Harris on 11/23/14.
//  Copyright (c) 2014 Max Harris. All rights reserved.
//

import UIKit

class HostFormViewController: UIViewController, UINavigationControllerDelegate, UIImagePickerControllerDelegate {
    
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
        var gallaryAction = UIAlertAction(title: "Gallary", style: UIAlertActionStyle.Default)
            {
                UIAlertAction in
                self.openGallary()
        }
        var cancelAction = UIAlertAction(title: "Cancel", style: UIAlertActionStyle.Cancel)
            {
                UIAlertAction in
                
        }
        // Add the actions
        alert.addAction(cameraAction)
        alert.addAction(gallaryAction)
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
    
    func openGallary()
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
        } else {
            self.navigationController?.popViewControllerAnimated(true)
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

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
