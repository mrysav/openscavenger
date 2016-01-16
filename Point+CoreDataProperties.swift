//
//  Point+CoreDataProperties.swift
//  MirandApp
//
//  Created by Mitchell Rysavy on 1/16/16.
//  Copyright © 2016 Mitchell Rysavy. All rights reserved.
//
//  Choose "Create NSManagedObject Subclass…" from the Core Data editor menu
//  to delete and recreate this implementation file for your updated model.
//

import Foundation
import CoreData

extension Point {

    @NSManaged var latitude: String?
    @NSManaged var longitude: String?
    @NSManaged var name: String?
    @NSManaged var hint: String?
    @NSManaged var password: String?
    @NSManaged var message: String?
    @NSManaged var action: String?
    @NSManaged var next: String?

}
