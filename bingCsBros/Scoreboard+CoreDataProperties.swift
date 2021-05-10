//
//  Scoreboard+CoreDataProperties.swift
//  bingCsBros
//
//  Created by Kate Baumstein on 5/6/21.
//
//

import Foundation
import CoreData


extension Scoreboard {

    @nonobjc public class func scoreboardFetchRequest() -> NSFetchRequest<Scoreboard> {
        return NSFetchRequest<Scoreboard>(entityName: "Scoreboard")
    }

    @NSManaged public var level: Int64
    @NSManaged public var lives: Int64
    @NSManaged public var score: Int64

}

extension Scoreboard : Identifiable {

}

//can have array of the top 5 and then put in new value, sort it, and use index of new value to determine new place
