//
//  DetailViewController.swift
//  USavvy
//
//  Created by Maximilian Harris on 4/13/15.
//  Copyright (c) 2015 Max Harris. All rights reserved.
//

import UIKit

class DetailViewController: UITableViewController {
    var detailItem: Posting?
    
    @IBOutlet weak var mainImageView: UIImageView!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var locationLabel: UILabel!
    @IBOutlet weak var costLabel: UILabel!
    @IBOutlet weak var dateLabel: UILabel!
    @IBOutlet weak var startFinishTimeLabel: UILabel!
    @IBOutlet weak var descriptionTextView: UITextView!
    
    @IBOutlet weak var hostImageView: UIImageView!
    @IBOutlet weak var hostNameLabel: UILabel!
    @IBOutlet weak var hostEmail: UILabel!
    @IBOutlet weak var hostDescription: UITextView!
    
    @IBAction func bookNow(sender: AnyObject) {
        let alert = UIAlertView()
        alert.title = "Booking Complete"
        alert.message = "Congratulations! You booked an experience. You will receive an email explaining the details and notification before to remind you."
        alert.addButtonWithTitle("Awesome!")
        alert.show()
    }
    
    let imageCropper = ImageCropper()
    
    func configureView() {
        if let detail: Posting = self.detailItem {
            // Image
            let width = UIScreen.mainScreen().bounds.width
            self.mainImageView.image = detail.picture
            
            // Title
            self.titleLabel.text = detail.title
            
            // Location
            self.locationLabel.text = detailItem?.location
            
            // Cost
            if detail.cost.toInt() == 0 { self.costLabel.text = "Free" }
            else { self.costLabel.text = "$" + detail.cost }
            
            // Date
            self.dateLabel.text = MHTimeDisplay.dateSimple(detail.startTime)
            
            // Time
            self.startFinishTimeLabel.text = MHTimeDisplay.startToEnd(detailItem!.startTime, endTime: detailItem!.endTime)
            
            // Description
            self.descriptionTextView.text = detailItem?.description
            
            
            // Host Image
            self.hostImageView.image = detailItem?.profPic
            
            // Host Name
            self.hostNameLabel.text = detailItem?.host.name
            
            // Host Email
            self.hostEmail.text = detailItem?.host.email
            
            // Host Description
            self.hostDescription.text = detailItem?.host.description
            
            self.navigationController?.setToolbarHidden(false, animated: true)
        }
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem()
    }
    
    override func viewWillAppear(animated: Bool) {
        self.configureView()
    }
    
    override func viewWillDisappear(animated: Bool) {
        self.navigationController?.setToolbarHidden(true, animated: true)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


    
    override func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        let width = UIScreen.mainScreen().bounds.width
        // Picture row
        
        if indexPath.section == 0 {
            if indexPath.row == 0 { return width }
            else if indexPath.row == 1 { return width*0.25 }
        }
        
        if indexPath.section == 3 {
            if indexPath.row == 1 { return width }
            if indexPath.row == 3 { return width*0.65 }
            return 44
        }
        
        if indexPath.section == 2 { return width*0.65 }
        
        return width*0.25
    }
    
    override func tableView(tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        if (section == 0) {return 0}
        else {return UIScreen.mainScreen().bounds.width * 0.1}
    }
    
    override func tableView(tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return 0
    }

    /*
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("reuseIdentifier", forIndexPath: indexPath) as! UITableViewCell

        // Configure the cell...

        return cell
    }
    */

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
