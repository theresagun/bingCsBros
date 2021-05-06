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
