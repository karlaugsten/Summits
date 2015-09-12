//
//  ActivityViewController.swift
//  Summits
//
//  Created by Karl Augsten on 2014-11-29.
//  Copyright (c) 2014 Summits LLC. All rights reserved.
//

import UIKit

class ActivityViewController: UIViewController, APIControllerProtocol {
    
    @IBOutlet var descriptionTextLabel:UILabel!
    @IBOutlet var userTextLabel:UILabel!
    @IBOutlet var mountainTextLabel:UILabel!
    @IBOutlet var imageView:UIImageView!
    
    var activity:Activity?
    
    lazy var api : APIController = APIController(delegate: self, user:user)
    
    required init(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        if let activity = self.activity {
            self.userTextLabel.text = activity.user
            self.mountainTextLabel.text = activity.mountain
            if activity.pictureBase64 != "" {
                let decodedData = NSData(base64EncodedString: activity.pictureBase64, options: NSDataBase64DecodingOptions(rawValue: 0))
                var decodedimage = UIImage(data: decodedData!)!
                imageView.image = decodedimage as UIImage
            }
            self.descriptionTextLabel.text = activity.description
        }
    }
        
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
            // Dispose of any resources that can be recreated.
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
    
    /*
    // MARK: - Navigation
    
    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
    // Get the new view controller using segue.destinationViewController.
    // Pass the selected object to the new view controller.
    }
    */
}
