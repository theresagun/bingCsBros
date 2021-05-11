//
//  ViewController.swift
//  bingCsBros
//
//  Created by Jack Curtin on 4/25/21.
//

import UIKit
import CoreData
//Leaderboard
class ViewController: UIViewController {
    
    @IBOutlet var tableView : UITableView!
    

    //var sortedNames = sorted(scores, <)

    //let scores: Set = [14, 12, 17, 2, 36]

    var scores: [String] = []
    var names: [String] = []
    var leaderboard: [NSManagedObject]?
    

    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.delegate = self
        tableView.dataSource = self
        
        //LeaderboardDatabase.deleteRecords()

        
        leaderboard = LeaderboardDatabase.fetchLeaderboard()
        
        if(leaderboard!.count == 0 ){
            print("SAVING LEADERBOARD 1ST TIME")
            leaderboard = LeaderboardDatabase.saveFirstLeaderboard()
        }
        else{
            let scoresString = leaderboard?[0].value(forKey: "top5Scores") as! String
            let namesString = leaderboard?[0].value(forKey: "topNames") as! String

            scores = scoresString.components(separatedBy: ",")
            names = namesString.components(separatedBy: ",")
            print(scores)
            print(names)
            
        }
        
        
        
        // Do any additional setup after loading the view.
        self.navigationController?.isNavigationBarHidden = false
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}

extension ViewController: UITableViewDelegate {
    
}
extension ViewController: UITableViewDataSource{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int{
        return scores.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell{
       // let descendingStudents = scores.sorted(by: >)
        let descendingStudents = scores
                
        var stringArray = descendingStudents.map { String($0) }
        
        print(scores)
        print(names)
        print("Scores=: " + stringArray[indexPath.row])
        print("Name: " + names[indexPath.row])

        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
        cell.textLabel?.text = stringArray[indexPath.row] + " - " + names[indexPath.row]
        cell.textLabel?.font = UIFont(name:"Avenir", size:22)
//        cell.textLabel?.textColor = UIColor.white

    
        return cell
    }

}

