//
//  GameViewController.swift
//  bingCsBros
//
//  Created by Theresa Gundel on 4/12/21.
//

import UIKit
import SpriteKit
import GameplayKit

class GameViewController: UIViewController {
    
    var score: Int?
    var level: Int?
    var characterImage: UIImage?

    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationController?.isNavigationBarHidden = true

        if let view = self.view as! SKView? {
            // Load the SKScene from 'GameScene.sks'
            if let scene = SKScene(fileNamed: "GameScene") {
                (scene as! GameScene).viewCtrl = self
                // Set the scale mode to scale to fit the window
                scene.scaleMode = .aspectFill
                // Present the scene
                view.presentScene(scene)
            }
            
            view.ignoresSiblingOrder = true
            
            view.showsFPS = true
            view.showsNodeCount = true
        }
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        AppUtility.lockOrientation(.landscape, andRotateTo: .landscapeLeft)
        
    }


    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if(segue.identifier == "gameToWin"){
            let win: WinViewController = segue.destination as! WinViewController
            win.score = self.score
            win.level = self.level
            win.characterImage = self.characterImage
        }
        if(segue.identifier == "gameToLose"){
            let lose: GameOverViewController = segue.destination as! GameOverViewController
            //lose.score = self.score
            //lose.level = self.level
        }
//        if(segue.identifier == "gameToCompleted"){
//            let complete: GameOverViewController = segue.destination as! GameOverViewController
//            complete.characterImage = self.characterImage
//            //lose.score = self.score
//            //lose.level = self.level
//        }
    
        
    }
    
    


}
