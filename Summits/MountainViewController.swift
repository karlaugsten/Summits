//
//  MountainViewController.swift
//  Summits
//
//  Created by Karl Augsten on 2014-11-28.
//  Copyright (c) 2014 Summits LLC. All rights reserved.
//

import UIKit

class MountainViewController: UIViewController, APIControllerProtocol, UITableViewDelegate, UITableViewDataSource  {
    var mountain: Mountain?
    
    var activities = [Activity]()
    
    @IBOutlet weak var mountainLabel: UILabel!
    @IBOutlet weak var mountainNavBar: UINavigationBar!
    @IBOutlet weak var heightFeetLabel: UILabel!
    @IBOutlet weak var heightMetersLabel: UILabel!
    @IBOutlet weak var latitudeLabel: UILabel!
    @IBOutlet weak var longitudeLabel: UILabel!
    @IBOutlet weak var activitiesTableView: UITableView!
    @IBOutlet weak var activitiesButton: UIButton!

    lazy var api : APIController = APIController(delegate: self, user:user)
    
    required init(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        if let mount = self.mountain {
            self.title = mount.name
            self.heightFeetLabel.text = mount.height_feet
            self.heightMetersLabel.text = mount.height_meters
            self.latitudeLabel.text = mount.latitude
            self.longitudeLabel.text = mount.longitude
            api.getActivitiesByMountain(mount.id)
        }
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if let id = segue.identifier {
            if id == "New Activity" {
                var newActivityViewController: NewActivityViewController = segue.destinationViewController as NewActivityViewController
                newActivityViewController.mountain = self.mountain
            } else if id == "Show Activity" {
                var showActivityViewController: ActivityViewController = segue.destinationViewController as ActivityViewController
                let selectedIndex = self.activitiesTableView.indexPathForCell(sender as UITableViewCell)
                showActivityViewController.activity = activities[selectedIndex!.row]
            }
        }
    }
    
    // MARK: UITableViewDataSource
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return activities.count
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("ActivityCell") as ActivityCell
        let activity = activities[indexPath.row]
        if activity.pictureBase64 != "" {
            let decodedData = NSData(base64EncodedString: activity.pictureBase64, options: NSDataBase64DecodingOptions(rawValue: 0))
            var decodedimage = UIImage(data: decodedData!)!
            cell.imagePreview.image = decodedimage as UIImage
        }
        cell.descriptionLabel.text = activity.description
        return cell
    }
    
    func tableView(tableView: UITableView, willDisplayCell cell: UITableViewCell, forRowAtIndexPath indexPath: NSIndexPath) {
        cell.layer.transform = CATransform3DMakeScale(0.1,0.1,1)
        UIView.animateWithDuration(0.25, animations: {
            cell.layer.transform = CATransform3DMakeScale(1,1,1)
        })
    }
    
    // MARK: APIControllerProtocol
    func didReceiveAPIResults(results: NSDictionary) {
        var resultsArr: NSArray = results["activities"] as NSArray
        dispatch_async(dispatch_get_main_queue(), {
            self.activities = Activity.activitiesWithJSON(resultsArr)
            self.activitiesTableView.reloadData()
            UIApplication.sharedApplication().networkActivityIndicatorVisible = false
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

}
