//
//  ScoreboardDatabase.swift
//  bingCsBros
//
//  Created by Kate Baumstein on 5/6/21.
//

import Foundation
import CoreData
import UIKit


class LeaderboardDatabase{
    

    static func fetchLeaderboard() -> [NSManagedObject]{
        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else {
          return []
        }
        
        let managedContext = appDelegate.persistentContainer.viewContext
        
        let fetchRequest = NSFetchRequest<NSManagedObject>(entityName: "Leaderboard")
        

        do {
          let leaderboard = try managedContext.fetch(fetchRequest)
          return leaderboard
        } catch let error as NSError {
          print("Could not fetch. \(error), \(error.userInfo)")
        }
        return []
      }
    
    
    static func updateTop5(newList: String, newNames: String, leaderboardToUpdate: Leaderboard) {
        //pass in sorted list
        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else {
          return
        }
        
        let context = appDelegate.persistentContainer.viewContext
        
        do {
          
          
            print("UPDATING")
            leaderboardToUpdate.setValue(newList, forKey: "top5Scores")
            leaderboardToUpdate.setValue(newNames, forKey: "topNames")
            print("UPDATED")
          
          do {
            try context.save()
            print("saved!")
          } catch let error as NSError  {
            print("Could not save \(error), \(error.userInfo)")
          } catch {
            
          }
          
        } catch {
          print("Error with request: \(error)")
        }
      }
    
    static func saveFirstLeaderboard() -> [NSManagedObject] {
        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else {
          return []
        }
        
        let managedContext = appDelegate.persistentContainer.viewContext
        
        let entity = NSEntityDescription.entity(forEntityName: "Leaderboard",
                                                in: managedContext)!
        
    
        let leaderboard = NSManagedObject(entity: entity,
                                     insertInto: managedContext)
        
        leaderboard.setValue("0,0,0,0,0,0,0,0,0,0", forKeyPath: "top5Scores")
        leaderboard.setValue("NA,NA,NA,NA,NA,NA,NA,NA,NA,NA", forKeyPath: "topNames")

        
        do {
          try managedContext.save()
        } catch let error as NSError {
          print("Could not save. \(error), \(error.userInfo)")
        }
        
        return [leaderboard]
      }
    
    
    static func deleteRecords() -> Void {
        let moc = getContext()
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "Leaderboard")

         let result = try? moc.fetch(fetchRequest)
            let resultData = result as! [Leaderboard]

            for object in resultData {
                moc.delete(object)
            }

//            do {
//                try moc.save()
//                print("saved!")
//            } catch let error as NSError  {
//                print("Could not save \(error), \(error.userInfo)")
//            } catch {
//
//            }

    }

    // MARK: Get Context

    static func getContext () -> NSManagedObjectContext {
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        return appDelegate.persistentContainer.viewContext
    }
    
    
}
