//
//  Leaderboard+CoreDataProperties.swift
//  bingCsBros
//
//  Created by Kate Baumstein on 5/9/21.
//
//

import Foundation
import CoreData


extension Leaderboard {

    @nonobjc public class func leaderboardFetchRequest() -> NSFetchRequest<Leaderboard> {
        return NSFetchRequest<Leaderboard>(entityName: "Leaderboard")
    }

    @NSManaged public var top5Scores: String

}

extension Leaderboard : Identifiable {

}
