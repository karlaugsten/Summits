//
//  LoginViewController.swift
//  Summits
//
//  Created by Karl Augsten on 2014-10-26.
//  Copyright (c) 2014 Summits LLC. All rights reserved.
//

import UIKit

class RegisterViewController: UIViewController, UITextFieldDelegate, UINavigationControllerDelegate, APIControllerProtocol, UIImagePickerControllerDelegate {
    
    @IBOutlet var txtUsername:UITextField!
    @IBOutlet var txtPassword:UITextField!
    @IBOutlet var txtEmail:UITextField!
    @IBOutlet var btnCreate:UIButton!
    @IBOutlet var imagePreview : UIImageView!
    
    lazy var imagePicker = UIImagePickerController()
    

    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    // Events
    @IBAction func btnCreateInClicked(sender:UIButton) {
        if let username = txtUsername.text {
            if let password = txtPassword.text {
                user.username = username
                user.password = password
                var api = APIController(delegate: self, username: username, password: password)
                UIApplication.sharedApplication().networkActivityIndicatorVisible = false
                var base64Picture = ""
                if var image : UIImage = imagePreview.image {
                    var imageData = UIImagePNGRepresentation(image)
                    base64Picture = imageData.base64EncodedStringWithOptions(NSDataBase64EncodingOptions(0))
                }
                user.profilePicture = base64Picture
                
                api.createUser(username, password: password, profilePicture: base64Picture)
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
    
    // MARK: - image stuff
    @IBAction func AddImageButton(sender : AnyObject) {
        imagePicker.modalPresentationStyle = UIModalPresentationStyle.CurrentContext
        imagePicker.delegate = self
        self.presentViewController(imagePicker, animated: true, completion: nil)
    }
    
    func imagePickerController(picker: UIImagePickerController!, didFinishPickingImage image: UIImage!, editingInfo: NSDictionary!) {
        let selectedImage : UIImage = image
        imagePreview.image  = selectedImage
        self.dismissViewControllerAnimated(true, completion: nil)
    }
    
    func imagePickerControllerDidCancel(picker: UIImagePickerController!) {
        self.dismissViewControllerAnimated(true, completion: nil)
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
