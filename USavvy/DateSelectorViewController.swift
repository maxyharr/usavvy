//
//  DateSelectorViewController.swift
//  USavvy
//
//  Created by Maximilian Harris on 3/6/15.
//  Copyright (c) 2015 Max Harris. All rights reserved.
//

import UIKit
protocol DateSelectorDelegate {
    func updateTime(data: NSDate, cameFrom:String)
}

class DateSelectorViewController: UIViewController {
    var delegate:DateSelectorDelegate?
    
    var cameFrom = ""
    
    @IBOutlet weak var datePicker: UIDatePicker!
    
    @IBAction func dismiss(sender: AnyObject) {
        dismissViewControllerAnimated(true, completion: nil)
    }
    
    @IBAction func finishPickingTime(sender: AnyObject) {
        self.delegate?.updateTime(self.datePicker.date, cameFrom: cameFrom)
        dismissViewControllerAnimated(true, completion: nil)
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
