//
//  Plant+CoreDataProperties.swift
//  plants
//
//  Created by Ramon Geronimo on 4/22/19.
//  Copyright © 2019 Adriana González Martínez. All rights reserved.
//
//

import Foundation
import CoreData


extension Plant {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Plant> {
        return NSFetchRequest<Plant>(entityName: "Plant")
    }

    @NSManaged public var species: String?
    @NSManaged public var waterDates: NSMutableOrderedSet?

}

// MARK: Generated accessors for waterDates
extension Plant {

    @objc(addWaterDatesObject:)
    @NSManaged public func addToWaterDates(_ value: WaterDate)

    @objc(removeWaterDatesObject:)
    @NSManaged public func removeFromWaterDates(_ value: WaterDate)

    @objc(addWaterDates:)
    @NSManaged public func addToWaterDates(_ values: NSSet)

    @objc(removeWaterDates:)
    @NSManaged public func removeFromWaterDates(_ values: NSSet)

}
