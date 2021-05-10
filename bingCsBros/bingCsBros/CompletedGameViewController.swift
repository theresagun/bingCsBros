//
//  CompletedGameViewController.swift
//  bingCsBros
//
//  Created by Kate Baumstein on 4/29/21.
//

import UIKit
import CoreData

class CompletedGameViewController: UIViewController {

    @IBOutlet var finalScoreLabel: UILabel!
    @IBOutlet var nameTextField: UITextField!
    @IBOutlet var submitButton: UIButton!
    @IBOutlet var madeToLeaderboard: UILabel!


    var scoreDB: Int?
    var levelDB: Int?
    var scoreboard: [NSManagedObject]?
    var leaderboard: [NSManagedObject]?
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        //TODO: set finalScoreLabel to contain actual score
        scoreboard = ScoreboardDatabase.fetchScoreboard()
        leaderboard = LeaderboardDatabase.fetchLeaderboard()
        if(scoreboard!.count == 0 ){
            print("SAVING SCOREBOARD 1ST TIME")
            scoreboard = ScoreboardDatabase.saveFirstScoreboard()
        }
        else{
            scoreDB = scoreboard?[0].value(forKey: "score") as! Int
        }
        finalScoreLabel.text = "Final Score: " + String(scoreDB!)
        let onLeaderboard = checkIfNewScoreOnLeaderboard()
        if(onLeaderboard) {
            submitButton.isHidden = false
            nameTextField.isHidden = false
            madeToLeaderboard.isHidden = false
        }
        

        // Do any additional setup after loading the view.
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        AppUtility.lockOrientation(.portrait, andRotateTo: .portrait)
    }
    
    

    func checkIfNewScoreOnLeaderboard() -> Bool{
        
        let scoresString = leaderboard![0].value(forKey: "top5Scores") as! String
        var scores = scoresString.components(separatedBy: ",")
        let scoresInt =  scores.map { Int($0)!}
        var indexOfNewScore = -1
        for i in stride(from: scoresInt.count - 1, to: 0, by: -1) {
            if(scoreDB! > scoresInt[i] ){
                indexOfNewScore = i
            }
        }
        
        if(indexOfNewScore != -1 ){
            return true
        }
        
        return false
        
       
        
    }
    
    func addNewScoreOnLeaderboard(){
        
        let scoresString = leaderboard![0].value(forKey: "top5Scores") as! String
        var scores = scoresString.components(separatedBy: ",")
        let scoresInt =  scores.map { Int($0)!}
        var indexOfNewScore = -1
        for i in stride(from: scoresInt.count - 1, to: 0, by: -1) {
            if(scoreDB! > scoresInt[i] ){
                indexOfNewScore = i
            }
        }
        
        if(indexOfNewScore != -1 ){
            print("new high score!")
            scores.insert(String(scoreDB!) + " - " + nameTextField.text!, at: indexOfNewScore)
            scores.removeLast()
            let scoreStringUpdated = (scores.map{String($0)}).joined(separator: ",")
            
            //insert new value at i and remove last value
            LeaderboardDatabase.updateTop5(newList: scoreStringUpdated , leaderboardToUpdate: leaderboard![0] as! Leaderboard)
        }
                
       
        
    }
    
    @IBAction func submitName(sender: UIButton){
            //TODO: set score back to 0
        addNewScoreOnLeaderboard()
        nameTextField.text = ""
        }
    

    @IBAction func clickPlayAgainButton(sender: UIButton){
            //TODO: set score back to 0
        ScoreboardDatabase.updateLevel(newLevel: 1, scoreboardToUpdate: scoreboard![0] as! Scoreboard)
        ScoreboardDatabase.updateScore(newScore: 0, scoreboardToUpdate: scoreboard![0] as! Scoreboard)
        }
    /*
     /!/ MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */
    
    
    

}
