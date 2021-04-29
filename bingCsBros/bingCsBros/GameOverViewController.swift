//
//  GameOverViewController.swift
//  bingCsBros
//
//  Created by Kate Baumstein on 4/29/21.
//

import UIKit

class GameOverViewController: UIViewController {

    @IBOutlet var finalScoreLabel: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        //TODO: set finalScoreLabel to contain actual score
        finalScoreLabel.text = "Final Score: " + String(0)
    
        // Do any additional setup after loading the view.
    }

    @IBAction func clickPlayAgainButton(sender: UIButton){
            //TODO: set score back to 0
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
