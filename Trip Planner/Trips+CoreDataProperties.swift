//
//  Trips+CoreDataProperties.swift
//  Trip Planner
//
//  Created by Ramon Geronimo on 5/7/19.
//  Copyright © 2019 Ramon Geronimo. All rights reserved.
//
//

import Foundation
import CoreData


extension Trips {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Trips> {
        let request = NSFetchRequest<Trips>(entityName: "Trips")
        request.sortDescriptors = [NSSortDescriptor(key: "trip", ascending: true)]
        return request
    }

    @NSManaged public var hasWaypoint: Bool
    @NSManaged public var trip: String
    @NSManaged public var waypoint: NSSet?

}

// MARK: Generated accessors for waypoint
extension Trips {

    @objc(addWaypointObject:)
    @NSManaged public func addToWaypoint(_ value: Waypoints)

    @objc(removeWaypointObject:)
    @NSManaged public func removeFromWaypoint(_ value: Waypoints)

    @objc(addWaypoint:)
    @NSManaged public func addToWaypoint(_ values: NSSet)

    @objc(removeWaypoint:)
    @NSManaged public func removeFromWaypoint(_ values: NSSet)

}
