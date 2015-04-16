//
//  MasterViewController.swift
//  USavvy
//
//  Created by Max Harris on 11/21/14.
//  Copyright (c) 2014 Max Harris. All rights reserved.
//

import UIKit

class MasterViewController: UITableViewController, CreateAnExperienceDelegate, ProfileViewControllerDelegate {

    @IBOutlet weak var profileButton: UIBarButtonItem!
   
    var detailViewController: DetailViewController? = nil
    let imageCropper = ImageCropper()
    
    // Holds array of IOS Posting Objects to show on the screen
    var postings = NSMutableArray()
    

    // callback from HostFromViewControllerDelegate when user finishes creating a posting
    func didFinishCreatingPosting(posting: Posting) {
        postings.addObject(posting)
        self.postings.sortUsingComparator (
            {
                (p1:AnyObject!, p2:AnyObject!)->NSComparisonResult in
                let posting1 = p1 as! Posting
                let posting2 = p2 as! Posting
                return posting1.startTime.compare(posting2.startTime)
        })
        //postings.insertObject(posting, atIndex: 0)
        self.tableView.reloadData()
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        if UIDevice.currentDevice().userInterfaceIdiom == .Pad {
            self.clearsSelectionOnViewWillAppear = false
            self.preferredContentSize = CGSize(width: 320.0, height: 600.0)
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.tableView.contentInset = UIEdgeInsetsMake(-1, 0, 0, 0)
        self.view.backgroundColor = UIColor.groupTableViewBackgroundColor()
        if let split = self.splitViewController {
            let controllers = split.viewControllers
            self.detailViewController = controllers[controllers.count-1].topViewController as? DetailViewController
        }
        
        refreshPostings()
        let user = PFUser.currentUser()
        self.profileButton.title = user["firstName"] as? String
    }
    
    override func viewDidAppear(animated: Bool) {
        // make sure to pull in new data when view loads (only for now, want to require action (pull down) that updates the postings data)
        
        var nav = self.navigationController?.navigationBar
        nav?.tintColor = UIColor.orangeColor()
    }
    
    @IBAction func refreshFromPull(sender: AnyObject) {
        self.refreshPostings()
        self.refreshControl?.endRefreshing()
    }
    // Pull in new data about postings in the marketplace that are available
    // TODO: Explain how this is being performed - Right now it is working, but horribly ineficiently
    func refreshPostings() {
        var query = PFQuery(className:"Posting")
        
        // only get listings that are in the future
        query.whereKey("startTime", greaterThan: NSDate())
        
        query.findObjectsInBackgroundWithBlock {
                (postingsTemp: [AnyObject]!, error: NSError!) -> Void in
            if error == nil {
                if postingsTemp.count > 0 {
                    self.postings.removeAllObjects()
                    for parsePosting in postingsTemp {
                        
                        // GRAB DATA OUT OF THE PARSE POSTING
                        let title = parsePosting["title"]! as! String
                        let description = parsePosting["description"]! as! String
                        let imageFile = parsePosting["experiencePhoto"]! as! PFFile
                        let cost = parsePosting["cost"] as! String
                        let availableSpots = parsePosting["availableSpots"] as! String
                        let startTime = parsePosting["startTime"] as! NSDate
                        let endTime = parsePosting["endTime"] as! NSDate
                        let location = parsePosting["location"] as! String
                        
                        var backgroundPhoto:UIImage? = nil
                        
                        // extract the background UIImage from the imageFile and store in 'backgroundPhoto'
                        imageFile.getDataInBackgroundWithBlock {
                            (imageData: NSData!, error: NSError!) -> Void in
                            if error == nil {
                                let image = UIImage(data:imageData)
                                backgroundPhoto = image
                                
                                // get user from posting (so we can get the profpic)
                                let parseUser = parsePosting["user"] as! PFUser
                                let userid = parseUser.objectId as String!
                                let query = PFUser.query()
                                query.getObjectInBackgroundWithId(userid){
                                    (retrievedUser: PFObject!, error: NSError!) -> Void in
                                    if error == nil {
                                        // get user's profpic to store in iOS object
                                        var profPic:UIImage? = nil
                                        let profileImageFile = retrievedUser["profilePicture"]! as! PFFile
                                        profileImageFile.getDataInBackgroundWithBlock {
                                            (imageData: NSData!, error: NSError!) -> Void in
                                            if error == nil {
                                                let hostFirstName = retrievedUser["firstName"] as! String
                                                let hostLastName = retrievedUser["lastName"] as! String
                                                let hostEmail = retrievedUser["email"] as! String
                                                let hostDescription = retrievedUser["personalDescription"] as! String
                                            
                                                let image = UIImage(data:imageData)
                                                profPic = image
                                                
                                                let host = User(firstName: hostFirstName, lastName: hostLastName, email: hostEmail, description: hostDescription, profilePicture: profPic!)
                                                
                                                let width = UIScreen.mainScreen().bounds.width
                                                // create a posting object
                                                let posting = Posting(title: title, description: description, cost: cost, availableSpots: availableSpots, startTime: startTime, endTime: endTime, picture: ImageCropper.squareImageWithImage(backgroundPhoto!, newSize: CGSizeMake(width, width)) , profPic: profPic!, host: host, location: location)
                                                
                                                //self.postings.insertObject(posting, atIndex: 0)
                                                self.postings.addObject(posting)
                                                self.postings.sortUsingComparator (
                                                    {
                                                        (p1:AnyObject!, p2:AnyObject!)->NSComparisonResult in
                                                        let posting1 = p1 as! Posting
                                                        let posting2 = p2 as! Posting
                                                        return posting1.startTime.compare(posting2.startTime)
                                                })
                                                
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
            } else {
                println("Couldn't retrieve postings %@", error)
            }
        }
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
            var detailVC = (segue.destinationViewController as! UINavigationController).topViewController as! DetailViewController
            
            if let indexPath = self.tableView.indexPathForSelectedRow() {
                let posting = postings[indexPath.section] as! Posting
                detailVC.detailItem = posting
                
                detailVC.navigationItem.leftBarButtonItem = self.splitViewController?.displayModeButtonItem()
                detailVC.navigationItem.leftItemsSupplementBackButton = true
            }
        }
        
        // User wants to create a new posting
        else if segue.identifier == "createAnExperienceSegue" {
            let createAnExperienceController:CreateAnExperienceController = segue.destinationViewController as! CreateAnExperienceController
            createAnExperienceController.delegate = self
        }
        
        else if segue.identifier == "profileSegue" {
            let profileViewController:ProfileViewController = segue.destinationViewController as! ProfileViewController
            profileViewController.delegate = self
        }
    }

    // MARK: - Table View

    // CUSTOM SEPARATOR
    override func tableView(tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        if (section > 0) { return UIScreen.mainScreen().bounds.width * 0.0625 } //0.0625
        else { return 1 }
    }
    override func tableView(tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        var headerView = UIView(frame: CGRectMake(0, 0, UIScreen.mainScreen().bounds.width, 30))
        headerView.backgroundColor = UIColor.groupTableViewBackgroundColor()
        return headerView
    }
    
    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return postings.count
    }
    
    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }

    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let posting = postings[indexPath.section] as! Posting
        
        let cell = tableView.dequeueReusableCellWithIdentifier("experienceCell", forIndexPath: indexPath) as! PostingTableViewCell
        let cellWidth = UIScreen.mainScreen().bounds.width
        cell.backgroundImageView.image  = posting.picture
        cell.titleLabel.text = posting.title
        cell.hostNameLabel.text = posting.host.name
        
        var pfUser = PFUser.currentUser()
        //########## COMPUTE IF RELATIONSHIP WORTHY HERE ######### - will also need to pull in list of "favoritedPostings" when pulling in list of all postings
        
        // Display cost as "Free" if 0
        if (posting.cost.toInt() == 0) { cell.costLabel.text = "Free" }
        else { cell.costLabel.text = "$" + posting.cost }
        
        cell.spotsLabel.text = posting.availableSpots + " spots left"
        
        cell.dateLabel.text = MHTimeDisplay.dateSimple(posting.startTime)
        cell.startEndTimeLabel.text = MHTimeDisplay.startToEnd(posting.startTime, endTime: posting.endTime)
        
        
        
        // setting profile image programmatically
        cell.profileImageView.image = posting.profPic
        cell.profileImageView.layer.cornerRadius = cell.profileImageView.frame.width/2 // to make it a circle
        cell.profileImageView.clipsToBounds = true
        cell.profileImageView.layer.borderWidth = 3
        cell.profileImageView.layer.borderColor = UIColor.orangeColor().CGColor
        
        var bottomLineView = UIView(frame: CGRectMake(0, cell.contentView.frame.size.height - 1, cell.contentView.frame.size.width, 1))
        var topLineView = UIView(frame: CGRectMake(0, 0, cell.contentView.frame.size.width, 1))
        
        bottomLineView.backgroundColor = UIColor.darkGrayColor()
        topLineView.backgroundColor = UIColor.darkGrayColor()
        
        cell.contentView.addSubview(bottomLineView)
        cell.contentView.addSubview(topLineView)
        
        return cell
    }

    override func tableView(tableView: UITableView, canEditRowAtIndexPath indexPath: NSIndexPath) -> Bool {
        // Return false if you do not want the specified item to be editable.
        return false
    }
    
    
    override func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        return UIScreen.mainScreen().bounds.width
    }
    
    func userDidFinishUpdatingProfile() {
        refreshPostings()
    }
    


}

