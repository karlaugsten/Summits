//
//  Activity.swift
//  Summits
//
//  Created by Karl Augsten on 2014-11-28.
//  Copyright (c) 2014 Summits LLC. All rights reserved.
//

import Foundation

class Activity {
    var mountain:String
    var description:String
    var pictureBase64:String
    var id:String
    var user:String
    
    init(mountain: String, description: String, id: String, picture: String, user: String)  {
        self.mountain = mountain
        self.description = description
        self.pictureBase64 = picture
        self.id = id
        self.user = user
    }
    
    class func activitiesWithJSON(allResults: NSArray) -> [Activity] {
        
        // Create an empty array of Activity to append to from this list
        var activities = [Activity]()
        
        // Store the results in our table data array
        if allResults.count>0 {
            
            // Sometimes iTunes returns a collection, not a track, so we check both for the 'name'
            for result in allResults {
                
                var mountain = result["mountain_id"] as? String ?? ""
                
                var description = result["description"] as? String ?? ""
                
                var pictureBase64 = result["picture"] as? String ?? ""
                
                var id = result["_id"] as? String ?? ""
                
                var user = result["user_id"] as? String ?? ""
                
                var newActivity = Activity(mountain: mountain, description: description, id: id, picture: pictureBase64, user: user)
                activities.append(newActivity)
                
            }
        }
        return activities
    }
    
}