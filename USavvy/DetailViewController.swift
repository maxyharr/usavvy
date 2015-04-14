//
//  DetailViewController.swift
//  USavvy
//
//  Created by Maximilian Harris on 4/13/15.
//  Copyright (c) 2015 Max Harris. All rights reserved.
//

import UIKit

class DetailViewController: UITableViewController {
    
    
    @IBOutlet weak var mainImageView: UIImageView!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var locationLabel: UILabel!
    @IBOutlet weak var costLabel: UILabel!
    @IBOutlet weak var dateLabel: UILabel!
    @IBOutlet weak var startFinishTimeLabel: UILabel!
    @IBOutlet weak var descriptionTextView: UITextView!
    

    var detailItem: Posting? {
        didSet {
            // Update the view.
        }
    }
    
    func configureView() {
        // Update the user interface for the detail item.
        //        if let detail: AnyObject = self.detailItem {
        //            if let label = self.detailDescriptionLabel {
        //                self.title = detail.description
        //                label.text = detail.description
        //            }
        //        }
        
        // Set the appropriate labels
        
        self.titleLabel.text = detailItem?.title
        // Still need to add location to posting model
        //self.locationLabel.text = detailItem?.location
        self.costLabel.text = detailItem?.cost
        if detailItem?.startTime != nil {
            self.dateLabel.text = MHTimeDisplay.dateSimple(detailItem!.startTime)
            self.startFinishTimeLabel.text = MHTimeDisplay.startToEnd(detailItem!.startTime, endTime: detailItem!.endTime)
        }
        self.descriptionTextView.text = detailItem?.description
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureView()
        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem()
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
            if indexPath.row == 1 { return width*0.25 }
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
