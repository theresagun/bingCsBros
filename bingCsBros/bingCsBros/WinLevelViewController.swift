//
//  WinViewController.swift
//  bingCsBros
//
//  Created by Theresa Gundel on 4/27/21.
//

import UIKit

class WinViewController: UIViewController {

    @IBOutlet var currentScoreLabel: UILabel!
    @IBOutlet var currentLevelLabel: UILabel!
    @IBOutlet var startNextLevelButton: UIButton!


    
    override func viewDidLoad() {
        super.viewDidLoad()
        UIDevice.current.setValue(UIInterfaceOrientation.portrait.rawValue, forKey: "orientation")
        self.navigationController?.isNavigationBarHidden = true
        //TODO: set finalScoreLabel to contain actual score
        currentScoreLabel.text = "Current Score: " + String(0)
        currentLevelLabel.text = "You passed level " + String(0) + "!"
        startNextLevelButton.setTitle( "Start level " + String(0), for: .normal)
        
        // Do any additional setup after loading the view.
    }

    
    override var shouldAutorotate: Bool {
        return true
    }

    override var supportedInterfaceOrientations: UIInterfaceOrientationMask {
        //can only run game portion in lanscape mode not portrait
        return .portrait
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
