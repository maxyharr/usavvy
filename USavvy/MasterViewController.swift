//
//  MasterViewController.swift
//  USavvy
//
//  Created by Max Harris on 11/21/14.
//  Copyright (c) 2014 Max Harris. All rights reserved.
//

import UIKit

class MasterViewController: UITableViewController {

    var detailViewController: DetailViewController? = nil
    var objects = NSMutableArray()

    override func awakeFromNib() {
        super.awakeFromNib()
        if UIDevice.currentDevice().userInterfaceIdiom == .Pad {
            self.clearsSelectionOnViewWillAppear = false
            self.preferredContentSize = CGSize(width: 320.0, height: 600.0)
        }
    }
//    @IBAction func addExperience(sender: AnyObject) {
//        insertNewObject(sender)
//    }
    
    override func viewDidAppear(animated: Bool) {
        // Commented code below is now taken care of in the AppDelagate in order to work with iPad MasterDetailView constraints
        
//        if (PFUser.currentUser() == nil) {
//            let storyboard = self.storyboard!
//            let LoginVC = storyboard.instantiateViewControllerWithIdentifier("login") as? LoginViewController
//            LoginVC?.modalPresentationStyle = UIModalPresentationStyle.CurrentContext
//            self.presentViewController(LoginVC!, animated: true, completion: nil)
//        }
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        self.navigationItem.leftBarButtonItem = self.editButtonItem()

//        let addButton = UIBarButtonItem(barButtonSystemItem: .Add, target: self, action: "insertNewObject:")
//        self.navigationItem.rightBarButtonItem = addButton
        if let split = self.splitViewController {
            let controllers = split.viewControllers
            self.detailViewController = controllers[controllers.count-1].topViewController as? DetailViewController
        }
        
        // ONLY HERE TO TEST THE LOG IN PAGE - Remove on actual implementation
        //PFUser.logOut()
    }
    
        func insertNewObject(sender: AnyObject) {
            objects.insertObject(NSDate(), atIndex: 0)
            let indexPath = NSIndexPath(forRow: 0, inSection: 0)
            self.tableView.insertRowsAtIndexPaths([indexPath], withRowAnimation: .Automatic)
        }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    // MARK: - Segues

    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if segue.identifier == "showDetail" {
            if let indexPath = self.tableView.indexPathForSelectedRow() {
                let object = objects[indexPath.row] as NSDate
                let controller = (segue.destinationViewController as UINavigationController).topViewController as DetailViewController
                controller.detailItem = object
                controller.navigationItem.leftBarButtonItem = self.splitViewController?.displayModeButtonItem()
                controller.navigationItem.leftItemsSupplementBackButton = true
            }
        }
        
        else if segue.identifier == "showHostForm" {
            
        }
    }

    // MARK: - Table View

    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }

    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return objects.count
    }

    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("Cell", forIndexPath: indexPath) as PostingTableViewCell
        
        // setting image programmatically
        cell.profileImageView.image = UIImage(named: "steve-profile")
        cell.profileImageView.layer.cornerRadius = 38 // 38 because width and height are 76 (76/2)
        cell.profileImageView.clipsToBounds = true
        cell.profileImageView.layer.borderWidth = 3
        cell.profileImageView.layer.borderColor = UIColor.orangeColor().CGColor
        
//        let object = objects[indexPath.row] as NSDate
//        cell.textLabel.text = object.description
        return cell
    }

    override func tableView(tableView: UITableView, canEditRowAtIndexPath indexPath: NSIndexPath) -> Bool {
        // Return false if you do not want the specified item to be editable.
        return false
    }

    override func tableView(tableView: UITableView, commitEditingStyle editingStyle: UITableViewCellEditingStyle, forRowAtIndexPath indexPath: NSIndexPath) {
        if editingStyle == .Delete {
            objects.removeObjectAtIndex(indexPath.row)
            tableView.deleteRowsAtIndexPaths([indexPath], withRowAnimation: .Fade)
        } else if editingStyle == .Insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view.
        }
    }


}

