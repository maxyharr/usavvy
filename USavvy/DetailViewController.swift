//
//  DetailViewController.swift
//  USavvy
//
//  Created by Max Harris on 11/21/14.
//  Copyright (c) 2014 Max Harris. All rights reserved.
//

import UIKit

class DetailViewController: UIViewController {

    @IBAction func logOutUser(sender: AnyObject) {
        PFUser.logOut()
        let delegate = UIApplication.sharedApplication().delegate as AppDelegate
        delegate.setUpRootViewController(false, animated: false, alert: true)
    }

    var detailItem: Posting? {
        didSet {
            // Update the view.
            self.configureView()
            self.title = detailItem?.title
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
    }
    
    

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        self.configureView()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


}

