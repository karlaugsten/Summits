//
//  FirstViewController.swift
//  Summits
//
//  Created by Karl Augsten on 2014-10-26.
//  Copyright (c) 2014 Summits LLC. All rights reserved.
//

import UIKit

class FirstViewController: UIViewController, UITableViewDataSource, UISearchBarDelegate, UISearchDisplayDelegate, UITableViewDelegate, APIControllerProtocol {
    
    @IBOutlet var mountainsTableView : UITableView?
    var mountains = [Mountain]()
    var filteredMountains = [Mountain]()
    var api : APIController?
    let kCellIdentifier: String = "MountainCell"
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = "Mountains"
        api = APIController(delegate: self, username: user.username, password: user.password)
        UIApplication.sharedApplication().networkActivityIndicatorVisible = true
        api!.getMountains()
        // Do any additional setup after loading the view, typically from a nib.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    // search
    func filterContentForSearchText(searchText: String) {
        // Filter the array using the filter method
        self.filteredMountains = self.mountains.filter({( mountain: Mountain) -> Bool in
            let stringMatch = mountain.name.lowercaseString.rangeOfString(searchText)
            return (stringMatch != nil)
        })
    }
    
    func searchDisplayController(controller: UISearchDisplayController!, shouldReloadTableForSearchString searchString: String!) -> Bool {
        self.filterContentForSearchText(searchString)
        return true
    }
    
    func searchDisplayController(controller: UISearchDisplayController!, shouldReloadTableForSearchScope searchOption: Int) -> Bool {
        self.filterContentForSearchText(self.searchDisplayController!.searchBar.text)
        return true
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if tableView == self.searchDisplayController!.searchResultsTableView {
            return self.filteredMountains.count
        } else {
            return self.mountains.count
        }
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        var cell:UITableViewCell? = tableView.dequeueReusableCellWithIdentifier(kCellIdentifier) as UITableViewCell?
        // TODO: fix this, temporary fix
        if var mycell = cell {
            var mountain : Mountain
            if tableView == self.searchDisplayController!.searchResultsTableView {
                mountain = filteredMountains[indexPath.row]
            } else {
                mountain = mountains[indexPath.row]
            }
            mycell.textLabel.text = mountain.name
            return mycell
            
        } else {
            var mycell = UITableViewCell()
            var mountain : Mountain
            if tableView == self.searchDisplayController!.searchResultsTableView {
                mountain = filteredMountains[indexPath.row]
            } else {
                mountain = mountains[indexPath.row]
            }
            mycell.textLabel.text = mountain.name
            return mycell
        }
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        var mountainViewController: MountainViewController = segue.destinationViewController as MountainViewController
        var mountainIndex = mountainsTableView!.indexPathForSelectedRow()!.row
        var selectedMountain :Mountain
        selectedMountain = self.mountains[mountainIndex]
        mountainViewController.mountain = selectedMountain
    }
    
    func didReceiveAPIResults(results: NSDictionary) {
        var resultsArr: NSArray = results["mountains"] as NSArray
        dispatch_async(dispatch_get_main_queue(), {
            self.mountains = Mountain.mountainsWithJSON(resultsArr)
            self.mountainsTableView!.reloadData()
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

