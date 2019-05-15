//
//  Waypoints+CoreDataProperties.swift
//  Trip Planner
//
//  Created by Ramon Geronimo on 5/7/19.
//  Copyright © 2019 Ramon Geronimo. All rights reserved.
//
//

import Foundation
import CoreData


extension Waypoints {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Waypoints> {
        let request = NSFetchRequest<Waypoints>(entityName: "Waypoints")
        request.sortDescriptors = [NSSortDescriptor(key: "waypoint", ascending: true)]
        return request
    }

    @NSManaged public var waypoint: String?
    @NSManaged public var trip: Trips?

}
