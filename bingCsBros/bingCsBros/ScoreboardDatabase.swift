//
//  ScoreboardDatabase.swift
//  bingCsBros
//
//  Created by Kate Baumstein on 5/6/21.
//

import Foundation
import CoreData
import UIKit


class ScoreboardDatabase{
    

    static func fetchScoreboard() -> [NSManagedObject]{
        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else {
          return []
        }
        
        let managedContext = appDelegate.persistentContainer.viewContext
        
        let fetchRequest = NSFetchRequest<NSManagedObject>(entityName: "Scoreboard")
        

        do {
          let scoreboard = try managedContext.fetch(fetchRequest)
          return scoreboard
        } catch let error as NSError {
          print("Could not fetch. \(error), \(error.userInfo)")
        }
        return []
      }
    
    
    static func updateLives(newLives: Int64, scoreboardToUpdate: Scoreboard) {
        
        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else {
          return
        }
        
        let context = appDelegate.persistentContainer.viewContext
        
        do {
          
          
            print("UPDATING")
            scoreboardToUpdate.setValue(newLives, forKey: "lives")
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
    
    static func saveFirstScoreboard() -> [NSManagedObject] {
        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else {
          return []
        }
        
        let managedContext = appDelegate.persistentContainer.viewContext
        
        let entity = NSEntityDescription.entity(forEntityName: "Scoreboard",
                                                in: managedContext)!
        
    
        let scoreboard = NSManagedObject(entity: entity,
                                     insertInto: managedContext)
        
        scoreboard.setValue(0, forKeyPath: "score")
        scoreboard.setValue(1, forKeyPath: "level")
        scoreboard.setValue(3, forKeyPath: "lives")
        
        do {
          try managedContext.save()
        } catch let error as NSError {
          print("Could not save. \(error), \(error.userInfo)")
        }
        
        return [scoreboard]
      }
    
    //only update score once level is complete
    static func updateScore(newScore: Int64, scoreboardToUpdate: Scoreboard) {
        
        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else {
          return
        }
        
        let context = appDelegate.persistentContainer.viewContext
        
        do {
          
          
            print("UPDATING")
            scoreboardToUpdate.setValue(newScore, forKey: "score")
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
    
    static func updateLevel(newLevel: Int64, scoreboardToUpdate: Scoreboard) {
        
        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else {
          return
        }
        
        let context = appDelegate.persistentContainer.viewContext
        
        do {
          
          
            print("UPDATING")
            scoreboardToUpdate.setValue(newLevel, forKey: "level")
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
    
//    static func save(score:Int, level: Int, lives: Int) {
//        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else {
//          return
//        }
//
//        let managedContext = appDelegate.persistentContainer.viewContext
//
//        let entity = NSEntityDescription.entity(forEntityName: "Scoreboard",
//                                                in: managedContext)!
//
//
//        let scoreboard = NSManagedObject(entity: entity,
//                                     insertInto: managedContext)
//
//        scoreboard.setValue(Int64(0), forKeyPath: "score")
//        scoreboard.setValue(Int64(1), forKeyPath: "level")
//        scoreboard.setValue(Int64(3), forKeyPath: "lives")
//
//
//
//        do {
//          try managedContext.save()
//        } catch let error as NSError {
//          print("Could not save. \(error), \(error.userInfo)")
//        }
//      }
    
    
    
    
    
    
}
