//
//  ViewController.swift
//  MirandApp
//
//  Created by Mitchell Rysavy on 1/16/16.
//  Copyright © 2016 Mitchell Rysavy. All rights reserved.
//

import UIKit
import Alamofire
import MagicalRecord
import SwiftyJSON
import CoreLocation

class ViewController: UIViewController, CLLocationManagerDelegate {
    
    let locationManager = CLLocationManager()
    var manager = Alamofire.Manager()
    var currentPoint = [String: AnyObject]()
    var lastDistance: Double = 0
    
    @IBOutlet weak var directionLabel: UILabel!
    @IBOutlet weak var tempLabel: UILabel!
    @IBOutlet weak var messageBox: UITextView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let configuration = NSURLSessionConfiguration.defaultSessionConfiguration()
        configuration.requestCachePolicy = .ReloadIgnoringLocalCacheData
        manager = Alamofire.Manager(configuration: configuration)
        
        manager.request(.GET, "https://rysavys.me/miranda/points.json")
            .responseJSON { response in
                
                let localContext = NSManagedObjectContext.MR_context()
                
                switch response.result {
                case .Success:
                    if let value = response.result.value {
                        let json = JSON(value)
                        // print("JSON: \(json)")
                        for point in json["points"].array! {
                            
                            var localPoint: Point
                            
                            // We already have a point stored for the given id
                            if let cdPoints = Point.MR_findByAttribute("id", withValue: point["id"].number!, inContext: localContext) {
                                if cdPoints.count > 0 {
                                    if cdPoints.count > 1 {
                                        print("There was a problem -- more than one point stored for id " + point["id"].string!)
                                    }
                                    localPoint = cdPoints[0] as! Point
                                } else {
                                    localPoint = Point.MR_createEntityInContext(localContext)!
                                    localPoint.setValue(point["id"].stringValue, forKey: "id")
                                    localPoint.setValue(false, forKey: "completed")
                                }
                                
                                localPoint.setValue(point["latitude"].string!, forKey: "latitude")
                                localPoint.setValue(point["longitude"].string!, forKey: "longitude")
                                localPoint.setValue(point["message"].string!, forKey: "message")
                                localPoint.setValue(point["action"].string!, forKey: "action")
                            }
                        }
                        
                        localContext.MR_saveToPersistentStoreAndWait()
                        self.loadCurrentPoint(localContext)
                    }
                case .Failure(let error):
                    print(error)
                }
        }
        
        self.locationManager.delegate = self
        self.locationManager.desiredAccuracy = kCLLocationAccuracyBest
        self.locationManager.requestWhenInUseAuthorization()
        self.locationManager.startUpdatingLocation()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func locationManager(manager: CLLocationManager, didUpdateToLocation newLocation: CLLocation, fromLocation oldLocation: CLLocation) {
        
        if !self.currentPoint.keys.contains("id") {
            return
        }
        
        let destLocation = CLLocation(
            latitude: CLLocationDegrees(self.currentPoint["latitude"]! as! String)!,
            longitude: CLLocationDegrees(self.currentPoint["longitude"]! as! String)!)
        
        var dir = ""
        if(destLocation.coordinate.latitude < newLocation.coordinate.latitude) {
            dir = "S"
        } else {
            dir = "N"
        }
        if(destLocation.coordinate.longitude < newLocation.coordinate.longitude) {
            dir = dir + "W"
        } else {
            dir = dir + "E"
        }
        self.directionLabel.text = dir
        
        let dist = newLocation.distanceFromLocation(destLocation)
        let distInMiles = dist * 0.000621371
        let roundedDist = round(100 * distInMiles) / 100
        
        self.tempLabel.text = roundedDist.description + " miles away."
        
        if(dist < 10) {
            self.tempLabel.text = "You're there!"
            moveToNextPoint()
        }
        
        self.lastDistance = dist
    }
    
    func locationManager(manager: CLLocationManager, didFailWithError error: NSError) {
        print("Error:" + error.localizedDescription)
    }
    
    func loadCurrentPoint() {
        return loadCurrentPoint(NSManagedObjectContext.MR_context())
    }
    
    func loadCurrentPoint(localContext: NSManagedObjectContext) {
        var allComplete = true;
        if let points = Point.MR_findAllSortedBy("id", ascending: true, inContext: localContext) {
            for point in points {
                let completed = point.valueForKey("completed")!.boolValue!
                let id = point.valueForKey("id")!.integerValue! + 1
                // print(point)
                let lat = point.valueForKey("latitude")!
                let long = point.valueForKey("longitude")!
                let message = point.valueForKey("message")!
                let action = point.valueForKey("action")!

                allComplete = allComplete && completed
                if completed == true {
                    print(id.description + " is true!")
                } else {
                    self.currentPoint["latitude"] = lat
                    self.currentPoint["longitude"] = long
                    self.currentPoint["id"] = id
                    self.currentPoint["message"] = message
                    self.currentPoint["action"] = action
                    print(currentPoint["id"]!.description! + " is the current point!")
                    // self.messageBox.text = currentPoint["message"] as! String
                    break
                }
            }
        }
        
        if(allComplete) {
            print("")
        }
    }
    
    func moveToNextPoint() {
        self.messageBox.text = self.currentPoint["message"] as! String
        
        let context = NSManagedObjectContext.MR_context()
        
        if let point = Point.MR_findFirstByAttribute("id", withValue: self.currentPoint["id"]!, inContext: context) {
            point.completed = true
            context.MR_saveToPersistentStoreAndWait()
            loadCurrentPoint(context)
        }
    }
}

