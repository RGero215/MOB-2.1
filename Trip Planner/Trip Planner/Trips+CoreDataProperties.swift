//
//  Trips+CoreDataProperties.swift
//  Trip Planner
//
//  Created by Ramon Geronimo on 5/5/19.
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

}
