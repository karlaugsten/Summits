//
//  LoginViewController.swift
//  Summits
//
//  Created by Karl Augsten on 2014-10-26.
//  Copyright (c) 2014 Summits LLC. All rights reserved.
//

import UIKit

class LoginViewController: UIViewController, UITextFieldDelegate, APIControllerProtocol {

    @IBOutlet var txtUsername:UITextField!
    @IBOutlet var txtPassword:UITextField!
    @IBOutlet var btnSignIn:UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    // Events
    @IBAction func btnSignInClicked(sender:UIButton) {
        if let username = txtUsername.text {
            if let password = txtPassword.text {
                user.username = username
                user.password = password
                var api = APIController(delegate: self, username: username, password: password)
                UIApplication.sharedApplication().networkActivityIndicatorVisible = true
                api.verifyCredentials()
            }
        }
    }
    
    // IOS Touch
    override func touchesBegan(touches: NSSet, withEvent event: UIEvent) {
        self.view.endEditing(true)
    }
    
    func textFieldShouldReturn(textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }

    func didReceiveAPIResults(results: NSDictionary) {
        if let base64Picture = results["profile_picture"] as? String {
            user.profilePicture = base64Picture
        }
        
        let storyboard = UIStoryboard(name: "Main", bundle: nil);
        UIApplication.sharedApplication().networkActivityIndicatorVisible = false
        let vc = storyboard.instantiateViewControllerWithIdentifier("TabBarController") as UIViewController;
        dispatch_async(dispatch_get_main_queue(), {
            self.presentViewController(vc, animated: true, completion: nil);
        })
    }
    
    func didReceiveError() {
        UIApplication.sharedApplication().networkActivityIndicatorVisible = false
        dispatch_async(dispatch_get_main_queue(), {
            let alert = UIAlertView()
            alert.title = "Error"
            alert.message = "Could not connect to server"
            alert.addButtonWithTitle("Ok")
            alert.show()
        })
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
