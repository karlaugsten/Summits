//
//  NewActivityViewController.swift
//  Summits
//
//  Created by Karl Augsten on 2014-11-29.
//  Copyright (c) 2014 Summits LLC. All rights reserved.
//

import UIKit

class NewActivityViewController: UIViewController, UITextViewDelegate, APIControllerProtocol, UIImagePickerControllerDelegate, UINavigationControllerDelegate {

    @IBOutlet var descriptionTextView:UITextView!
    @IBOutlet var btnPost:UIButton!
    @IBOutlet var imagePreview : UIImageView!
    
    lazy var imagePicker = UIImagePickerController()
    
    var mountain:Mountain?
    
    lazy var api : APIController = APIController(delegate: self, user:user)
    
    required init(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
            
            // Do any additional setup after loading the view.
    }
        
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
            // Dispose of any resources that can be recreated.
    }
        
    // Events
    @IBAction func btnPostClicked(sender:UIButton) {
        var base64Picture = ""
        if var image : UIImage = imagePreview.image {
            var imageData = UIImagePNGRepresentation(image)
            base64Picture = imageData.base64EncodedStringWithOptions(NSDataBase64EncodingOptions(0))
        }
        api.createActivity(user.username, mountainId: mountain!.name, description: descriptionTextView.text!, picture: base64Picture)
    }
        
        // IOS Touch
    override func touchesBegan(touches: NSSet, withEvent event: UIEvent) {
        self.view.endEditing(true)
    }
        
    func textViewShouldReturn(descriptionTextView: UITextView) -> Bool {
        descriptionTextView.resignFirstResponder()
        return true
    }
        
    func didReceiveAPIResults(results: NSDictionary) {
        dispatch_async(dispatch_get_main_queue(), {
            self.dismissViewControllerAnimated(true, completion: nil)
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
            self.dismissViewControllerAnimated(true, completion: nil)
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
