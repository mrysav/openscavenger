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
import CoreLocation

class ViewController: UIViewController, CLLocationManagerDelegate {

    let locationManager = CLLocationManager()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        Alamofire.request(.GET, "https://rysavys.me/miranda/points.json")
            .responseJSON { response in
                if let JSON = response.result.value {
                    // print("\(JSON)")
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
        print("Updating location")
    }
    
    func locationManager(manager: CLLocationManager, didFailWithError error: NSError) {
        print("Error:" + error.localizedDescription)
    }
    
    @IBAction func printLocation(sender: AnyObject) {
        print("\(self.locationManager.location?.coordinate.latitude), \(self.locationManager.location?.coordinate.longitude)")
    }
}

