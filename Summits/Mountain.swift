//
//  Mountain.swift
//  Summits
//
//  Created by Karl Augsten on 2014-11-25.
//  Copyright (c) 2014 Summits LLC. All rights reserved.
//

import Foundation

class Mountain {
    var name:String
    var latitude:String
    var longitude:String
    var height_meters:String
    var height_feet:String
    var id:String
    
    
    init(name: String, latitude: String, longitude: String, height_meters: String, height_feet: String, id: String)  {
        self.name = name
        self.latitude = latitude
        self.longitude = longitude
        self.height_meters = height_meters
        self.height_feet = height_feet
        self.id = id
    }
    
    class func mountainsWithJSON(allResults: NSArray) -> [Mountain] {
        
        // Create an empty array of Mountain to append to from this list
        var mountains = [Mountain]()
        
        // Store the results in our table data array
        if allResults.count>0 {
            
            // Sometimes iTunes returns a collection, not a track, so we check both for the 'name'
            for result in allResults {
                
                var name = result["name"] as? String ?? ""
            
                var latitude = result["latitide"] as? String ?? ""
                
                let longitude = result["longitude"] as? String ?? ""
                let height_meters = result["height_meters"] as? String ?? ""
                let height_feet = result["height_feet"] as? String ?? ""
                
                var id = result["_id"] as? String ?? ""
            
                var newMountain = Mountain(name: name, latitude: latitude, longitude: longitude, height_meters: height_meters, height_feet: height_feet, id: id)
                mountains.append(newMountain)
                
            }
        }
        return mountains
    }
    
}