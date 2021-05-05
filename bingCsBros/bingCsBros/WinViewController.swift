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

    var score: Int?
    var level: Int?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationController?.isNavigationBarHidden = true
        UIDevice.current.setValue(UIInterfaceOrientation.portrait.rawValue, forKey: "orientation")
        //TODO: set finalScoreLabel to contain actual score
        currentScoreLabel.text = "Current Score: " + String(self.score ?? 0)
        currentLevelLabel.text = "You passed level " + String(self.level ?? 0) + "!"
        startNextLevelButton.titleLabel?.font = UIFont(descriptor: UIFontDescriptor.init(name: "Times New Roman Bold", size: CGFloat(30)), size: CGFloat(30))
        startNextLevelButton.setTitleColor(UIColor.white, for: .normal)
        startNextLevelButton.setTitle( "Start level " + String((self.level ?? 0) + 1), for: .normal)
        
        // Do any additional setup after loading the view.
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        AppUtility.lockOrientation(.portrait, andRotateTo: .portrait)
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
