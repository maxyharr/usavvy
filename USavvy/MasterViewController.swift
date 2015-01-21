//
//  MasterViewController.swift
//  USavvy
//
//  Created by Max Harris on 11/21/14.
//  Copyright (c) 2014 Max Harris. All rights reserved.
//

import UIKit

class MasterViewController: UITableViewController, HostFormViewControllerDelegate, ProfileViewControllerDelegate {

    var detailViewController: DetailViewController? = nil
    var postings = NSMutableArray()

    // callback from HostFromViewControllerDelegate when user finishes creating a posting
    func didFinishCreatingPosting(posting: Posting) {
        postings.insertObject(posting, atIndex: 0)
        self.tableView.reloadData()
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        if UIDevice.currentDevice().userInterfaceIdiom == .Pad {
            self.clearsSelectionOnViewWillAppear = false
            self.preferredContentSize = CGSize(width: 320.0, height: 600.0)
        }
    }
    
    override func viewDidAppear(animated: Bool) {
        // make sure to pull in new data when view loads (only for now, want to require action (pull down) that updates the postings data)
    }
    
    // Pull in new data about postings in the marketplace that are available
    // TODO: Explain how this is being performed - Right now it is working, but horribly ineficiently
    func refreshPostings() {
        // this is a test comment
        var query = PFQuery(className:"Posting")
        var postingsTemp = query.findObjects()
        if postingsTemp.count > 0 {
            self.postings.removeAllObjects()
            for parsePosting in postingsTemp {
                let title = parsePosting["title"]! as String
                let numHours = parsePosting["numHours"]! as String
                let numGuests = parsePosting["numGuests"]! as String
                let description = parsePosting["description"]! as String
                let imageFile = parsePosting["experiencePhoto"]! as PFFile
                
                var backgroundPhoto:UIImage? = nil
                
                // extract the background UIImage from the imageFile and store in 'backgroundPhoto'
                imageFile.getDataInBackgroundWithBlock {
                    (imageData: NSData!, error: NSError!) -> Void in
                    if error == nil {
                        let image = UIImage(data:imageData)
                        backgroundPhoto = image
                        println("loaded in background image in viewDidLoad")
                        
                        // get user from posting (so we can get the profpic)
                        let parseUser = parsePosting["user"]! as? PFUser
                        let userid = parseUser?.objectId as String!
                        let query = PFUser.query()
                        query.getObjectInBackgroundWithId(userid){
                            (retrievedUser: PFObject!, error: NSError!) -> Void in
                            if error == nil {
                                // get user's profpic to store in iOS object
                                var profPic:UIImage? = nil
                                let profileImageFile = retrievedUser["profilePicture"]! as PFFile
                                profileImageFile.getDataInBackgroundWithBlock {
                                    (imageData: NSData!, error: NSError!) -> Void in
                                    if error == nil {
                                        println("found profPicImage")
                                        let image = UIImage(data:imageData)
                                        profPic = image
                                        
                                        // create a posting object
                                        let posting = Posting(title: title, numGuests: numGuests, numHours: numHours, description: description, picture: backgroundPhoto!, profPic: profPic!)
                                        
                                        self.postings.insertObject(posting, atIndex: 0)
                                        self.tableView.reloadData()
                                    } else {
                                        println("didn't find profPicImage")
                                    }
                                }
                            } else {
                                NSLog("%@", error)
                            }
                        }
                        
                    } else {
                        println("Couldn't find the background photo!")
                    }
                }
            }
        }
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        if let split = self.splitViewController {
            let controllers = split.viewControllers
            self.detailViewController = controllers[controllers.count-1].topViewController as? DetailViewController
        }
        
        refreshPostings()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func tableView(tableView: UITableView, didDeselectRowAtIndexPath indexPath: NSIndexPath) {
        self.performSegueWithIdentifier("showDetail", sender: indexPath)
    }

    // MARK: - Segues
    override func shouldPerformSegueWithIdentifier(identifier: String?, sender: AnyObject?) -> Bool {
        let user = PFUser.currentUser()
        if identifier == "pushHostFormSegue" {
            if user["profilePicture"] == nil || user["firstName"] == nil || user["lastName"] == nil || user["personalDescription"] == nil {
                let alert = UIAlertView()
                alert.title = "Update Profile"
                alert.message = "You must complete your profile before creating a posting"
                alert.addButtonWithTitle("Ok")
                alert.show()
                return false
            }
        }
        return true
    }

    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        
        // User wants to show the posting details for a specific one
        if segue.identifier == "showDetail" {
            
            if let indexPath = sender as? NSIndexPath {
                let posting = postings[indexPath.row] as Posting
                let controller = (segue.destinationViewController as UINavigationController).topViewController as DetailViewController
//                controller.detailItem = posting
//                controller.navigationItem.leftBarButtonItem = self.splitViewController?.displayModeButtonItem()
//                controller.navigationItem.leftItemsSupplementBackButton = true
            }
        }
        
        // User wants to create a new posting
        else if segue.identifier == "pushHostFormSegue" {
            let hostFormViewController:HostFormViewController = segue.destinationViewController as HostFormViewController
            hostFormViewController.delegate = self
        }
        
        else if segue.identifier == "profileSegue" {
            let profileViewController:ProfileViewController = segue.destinationViewController as ProfileViewController
            profileViewController.delegate = self
        }
    }

    // MARK: - Table View

    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }

    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return postings.count
    }

    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let posting = postings[indexPath.row] as Posting
        
        let cell = tableView.dequeueReusableCellWithIdentifier("Cell", forIndexPath: indexPath) as PostingTableViewCell
        
        cell.backgroundImageView.image  = posting.picture
        cell.titleLabel.text = posting.title
        cell.hoursLabel.text = "\(posting.numHours) hour(s) :"
        cell.guestsLabel.text = "\(posting.numGuests) guest(s)"
        
        // setting profile image programmatically
        cell.profileImageView.image = posting.profPic
        cell.profileImageView.layer.cornerRadius = 38 // 38 because width and height are 76 (76/2)
        cell.profileImageView.clipsToBounds = true
        cell.profileImageView.layer.borderWidth = 3
        cell.profileImageView.layer.borderColor = UIColor.orangeColor().CGColor
        
        return cell
    }

    override func tableView(tableView: UITableView, canEditRowAtIndexPath indexPath: NSIndexPath) -> Bool {
        // Return false if you do not want the specified item to be editable.
        return true
    }

    override func tableView(tableView: UITableView, commitEditingStyle editingStyle: UITableViewCellEditingStyle, forRowAtIndexPath indexPath: NSIndexPath) {
        if editingStyle == .Delete {
            postings.removeObjectAtIndex(indexPath.row)
            tableView.deleteRowsAtIndexPaths([indexPath], withRowAnimation: .Fade)
        } else if editingStyle == .Insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view.
        }
    }
    
    func userDidFinishUpdatingProfile() {
        refreshPostings()
    }
    


}

