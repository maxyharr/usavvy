//
//  LoginViewController.swift
//  USavvy
//
//  Created by Max Harris on 11/21/14.
//  Copyright (c) 2014 Max Harris. All rights reserved.
//

import UIKit

class LoginViewController: UIViewController, UITextFieldDelegate {
    
    @IBOutlet weak var emailLoginField: UITextField!
    @IBOutlet weak var passwordLoginField: UITextField!
    @IBOutlet weak var emailSignUpField: UITextField!
    @IBOutlet weak var passwordSignUpField: UITextField!
    @IBOutlet weak var passwordConfirmationSignUpField: UITextField!
    
    @IBAction func loginUser(sender: AnyObject) {
        if self.emailLoginField.text != nil {
            if self.passwordLoginField.text != nil {
                PFUser.logInWithUsernameInBackground(emailLoginField.text, password:passwordLoginField.text) {
                    (user: PFUser!, error: NSError!) -> Void in
                    if user != nil {
                        println("Signing in \(PFUser.currentUser().email) succeeded")
                        // Do stuff after successful login.
                        self.dismissViewControllerAnimated(true, completion: nil)
                    } else {
                        println(error.localizedFailureReason)
                        // The login failed. Check error to see why.
                    }
                }
            } else {
                println("didn't provide password")
            }
        } else {
            println("didn't provide email")
        }
    }
    
    @IBAction func signUpUser(sender: AnyObject) {
        if self.emailSignUpField.text != nil {
            if self.passwordSignUpField.text != nil {
                if self.passwordConfirmationSignUpField.text == self.passwordSignUpField.text {
                    var user = PFUser()
                    user.username = emailSignUpField.text
                    user.email = emailSignUpField.text
                    user.password = passwordSignUpField.text
                    
                    user.signUpInBackgroundWithBlock {
                        (succeeded: Bool!, error: NSError!) -> Void in
                        if error == nil {
                            // Hooray! Let them use the app now.
                            println("Signing up succeeded")
                            self.dismissViewControllerAnimated(true, completion: nil)
                        } else {
                            println("Signing up failed")
                            //let errorString = error.userInfo["error"] as NSString
                            // Show the errorString somewhere and let the user try again.
                        }
                    }
                } else {
                    println("password and confirmation don't match")
                }
            } else {
                println("didn't provide password")
            }
        } else {
            println("didn't provide email")
        }
    }

    override func viewDidAppear(animated: Bool) {
        let user = PFUser.currentUser()
        if user == nil {
            println("Not Logged In")
        } else {
            println("logged in as \(user.email)")
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
    
    // No Delegate needed -- removes keyboard when screen is touched outside of keyboard
    override func touchesBegan(touches: NSSet, withEvent event: UIEvent) {
        self.view.endEditing(true)
    }
    
    func textFieldShouldReturn(textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return false
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