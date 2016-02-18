//
//  Point+CoreDataProperties.swift
//  OpenScavenger
//
//  Created by Mitchell Rysavy on 1/22/16.
//  Copyright © 2016 Mitchell Rysavy. All rights reserved.
//
//  Choose "Create NSManagedObject Subclass…" from the Core Data editor menu
//  to delete and recreate this implementation file for your updated model.
//

import Foundation
import CoreData

extension Point {

    @NSManaged var id: String?
    @NSManaged var latitude: String?
    @NSManaged var longitude: String?
    @NSManaged var message: String?
    @NSManaged var action: String?
    @NSManaged var completed: NSNumber?

}
