//
//  Point.swift
//  MirandApp
//
//  Created by Mitchell Rysavy on 1/22/16.
//  Copyright © 2016 Mitchell Rysavy. All rights reserved.
//

import Foundation
import CoreData
import CoreLocation

class Point: NSManagedObject {

// Insert code here to add functionality to your managed object subclass
    
    func location2D() -> CLLocationCoordinate2D {
        let location = CLLocationCoordinate2D(latitude:CLLocationDegrees(latitude!)!, longitude: CLLocationDegrees(longitude!)!)
        return location
    }

}
