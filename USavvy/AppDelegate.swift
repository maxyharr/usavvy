//
//  AppDelegate.swift
//  USavvy
//
//  Created by Max Harris on 11/21/14.
//  Copyright (c) 2014 Max Harris. All rights reserved.
//

import UIKit

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate, UISplitViewControllerDelegate {

    var window: UIWindow?

    func application(application: UIApplication, didFinishLaunchingWithOptions launchOptions: [NSObject: AnyObject]?) -> Bool {
        Parse.setApplicationId("ULjqQwhr3m7aVEqDgZ8VQMlrbTGaaWujloMFjkJJ", clientKey: "Qy24JHY8a8t0DnYwvj9uaj56JK3Lgcp0RJzFjsZ9")
        var loggedIn = (PFUser.currentUser() != nil)
        setUpRootViewController(loggedIn, animated: loggedIn, alert: false)
        return true
    }
    
    func setUpRootViewController(loggedIn: Bool, animated: Bool, alert: Bool) {
        if let window = self.window {
            var newRootViewController: UIViewController? = nil
            var transition: UIViewAnimationOptions
            
            if !loggedIn {
                let loginVC = window.rootViewController?.storyboard?.instantiateViewControllerWithIdentifier("login") as LoginViewController
                newRootViewController = loginVC
                transition = UIViewAnimationOptions.TransitionFlipFromLeft
            } else {
                let splitViewController = window.rootViewController?.storyboard?.instantiateViewControllerWithIdentifier("SplitVC") as SplitViewController
                let navigationController = splitViewController.viewControllers[splitViewController.viewControllers.count-1] as UINavigationController
                navigationController.topViewController.navigationItem.leftBarButtonItem = splitViewController.displayModeButtonItem()
                splitViewController.delegate = self
                
                let masterNavigationController = splitViewController.viewControllers[0] as UINavigationController
                let controller = masterNavigationController.topViewController as MasterViewController
                
                newRootViewController = splitViewController
                transition = UIViewAnimationOptions.TransitionFlipFromLeft
             }

            
            if let rootVC = newRootViewController {
                if animated {
                    UIView.transitionWithView(window, duration: 0.5, options: transition, animations: { () -> Void in
                        window.rootViewController = rootVC
                    }, completion: nil)
                } else {
                    window.rootViewController = rootVC
                }
                
                if alert == true {
                    let alert = UIAlertView()
                    alert.title = "Logged Out"
                    alert.message = "Successfully logged out"
                    alert.addButtonWithTitle("Ok")
                    alert.show()
                }
            }
        }
    }

    func applicationWillResignActive(application: UIApplication) {
        // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
        // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
    }

    func applicationDidEnterBackground(application: UIApplication) {
        // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
        // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
    }

    func applicationWillEnterForeground(application: UIApplication) {
        // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
    }

    func applicationDidBecomeActive(application: UIApplication) {
        // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
    }

    func applicationWillTerminate(application: UIApplication) {
        // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
    }

    // MARK: - Split view

    func splitViewController(splitViewController: UISplitViewController, collapseSecondaryViewController secondaryViewController:UIViewController!, ontoPrimaryViewController primaryViewController:UIViewController!) -> Bool {
        if let secondaryAsNavController = secondaryViewController as? UINavigationController {
            if let topAsDetailController = secondaryAsNavController.topViewController as? DetailViewController {
                if topAsDetailController.detailItem == nil {
                    // Return true to indicate that we have handled the collapse by doing nothing; the secondary controller will be discarded.
                    return true
                }
            }
        }
        return false
    }

}

