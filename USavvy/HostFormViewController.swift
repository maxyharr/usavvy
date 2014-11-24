//
//  HostFormViewController.swift
//  USavvy
//
//  Created by Max Harris on 11/23/14.
//  Copyright (c) 2014 Max Harris. All rights reserved.
//

import UIKit

class HostFormViewController: UIViewController {

    @IBOutlet weak var titleField: UITextField!
    
    @IBOutlet weak var guestsField: UITextField!
    @IBOutlet weak var hoursField: UITextField!
    @IBOutlet weak var experienceImageView: UIImageView!
    
    @IBAction func uploadBackgroundPicture(sender: AnyObject) {
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
