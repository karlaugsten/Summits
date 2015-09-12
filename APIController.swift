//
//  APIController.swift
//  Summits
//
//  Created by Karl Augsten on 2014-11-18.
//  Copyright (c) 2014 Summits LLC. All rights reserved.
//

import Foundation

var serverUrl = "http://localhost:5000/api/v1.0/"
var appId = "secret123"

protocol APIControllerProtocol {
    
    func didReceiveAPIResults(results: NSDictionary)
    func didReceiveError()
    
}
class APIController {
    
    var delegate: APIControllerProtocol
    
    var password: NSString
    var username: NSString
    var config: NSURLSessionConfiguration
    
    init(delegate: APIControllerProtocol, username: NSString, password: NSString) {
        self.delegate = delegate
        self.username = username
        self.password = password
        var strAuth = "\(self.username):\(self.password)"
        let utf8strAuth = strAuth.dataUsingEncoding(NSUTF8StringEncoding)!
        let base64Auth = utf8strAuth.base64EncodedStringWithOptions(NSDataBase64EncodingOptions.Encoding64CharacterLineLength)
        let authString = "Basic \(base64Auth)"
        self.config = NSURLSessionConfiguration.defaultSessionConfiguration();
        self.config.HTTPAdditionalHeaders = ["Authorization" : authString]
    }
    
    init(delegate: APIControllerProtocol, user: User) {
        self.delegate = delegate
        self.username = user.username
        self.password = user.password
        var strAuth = "\(self.username):\(self.password)"
        let utf8strAuth = strAuth.dataUsingEncoding(NSUTF8StringEncoding)!
        let base64Auth = utf8strAuth.base64EncodedStringWithOptions(NSDataBase64EncodingOptions.Encoding64CharacterLineLength)
        let authString = "Basic \(base64Auth)"
        self.config = NSURLSessionConfiguration.defaultSessionConfiguration();
        self.config.HTTPAdditionalHeaders = ["Authorization" : authString]
    }

    
    func get(path: String) {
        let url = NSURL(string: path)!
        let session = NSURLSession(configuration: self.config)
        let task = session.dataTaskWithURL(url, completionHandler: {data, response, error -> Void in
            println("Task completed")
            
            if(error != nil) {
                // If there is an error in the web request, print it to the console
                println(error.localizedDescription)
                self.delegate.didReceiveError()
                return
            }
            let resp = response! as NSHTTPURLResponse
            if(resp.statusCode != 200){
                self.delegate.didReceiveError()
                return
            }
            var err: NSError?
            var jsonResult = NSJSONSerialization.JSONObjectWithData(data, options: NSJSONReadingOptions.MutableContainers, error: &err) as NSDictionary
            if(err != nil) {
                // If there is an error parsing JSON, print it to the console
                println("JSON Error \(err!.localizedDescription)")
                self.delegate.didReceiveError()
                return
            }
            
            self.delegate.didReceiveAPIResults(jsonResult)
        })
        task.resume()
    }
    
    func post(path:String, data:NSDictionary) {
        let url = NSURL(string: path)!
        let request = NSMutableURLRequest(URL: url)
        let session = NSURLSession(configuration: self.config)
        
        request.HTTPMethod = "POST"
        var err: NSError?
        var dataString = NSJSONSerialization.dataWithJSONObject(data, options:NSJSONWritingOptions.PrettyPrinted, error: &err)!
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        request.addValue("application/json", forHTTPHeaderField: "Accept")
        
        request.HTTPBody = dataString;
        
        let task = session.dataTaskWithRequest(request, completionHandler: {data, response, error -> Void in
            println("Task completed")
            
            if(error != nil) {
                // If there is an error in the web request, print it to the console
                println(error.localizedDescription)
                self.delegate.didReceiveError()
                return
            }
            let resp = response! as NSHTTPURLResponse
            if(resp.statusCode != 201){
                self.delegate.didReceiveError()
                return
            }
            var err: NSError?
            var jsonResult = NSJSONSerialization.JSONObjectWithData(data, options: NSJSONReadingOptions.MutableContainers, error: &err) as NSDictionary
            if(err != nil) {
                // If there is an error parsing JSON, print it to the console
                println("JSON Error \(err!.localizedDescription)")
                self.delegate.didReceiveError()
                return
            }
            
            self.delegate.didReceiveAPIResults(jsonResult)
        })
        task.resume()
    }

    
    func verifyCredentials() {
            let urlPath = "\(serverUrl)users/login?app_id=\(appId)"
            get(urlPath)
    }
    
    func getMountains() {
        let urlPath = "\(serverUrl)mountains?app_id=\(appId)"
        get(urlPath)
    }
    
    func createUser(username:String, password:String) {
        self.createUser(username, password: password, profilePicture:"")
    }
    
    func createUser(username:String, password:String, profilePicture:String) {
        let urlPath = "\(serverUrl)users?app_id=\(appId)"
        let userData = ["username": username, "password":password, "profile_picture":profilePicture]
        user.username = username
        user.password = password
        self.post(urlPath, data:userData)
    }
    
    func createActivity(userId:String, mountainId:String, description:String, picture:String) {
        let urlPath = "\(serverUrl)activities?app_id=\(appId)"
        let activityData = ["user_id": userId, "mountain_id":mountainId, "description":description, "picture":picture]
        self.post(urlPath, data:activityData)
    }
    
    func getActivitiesByMountain(mountainId:String) {
        let urlPath = "\(serverUrl)mountains/\(mountainId)/activities?app_id=\(appId)"
        get(urlPath)
    }
    
    func getActivitiesByUser(userId:String) {
        let urlPath = "\(serverUrl)users/\(userId)/activities?app_id=\(appId)"
        get(urlPath)
    }
    
}