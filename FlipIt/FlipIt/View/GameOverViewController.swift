//
//  GameOverViewController.swift
//  FlipIt
//
//  Created by Esraa Abdelmotteleb on 8/5/18.
//  Copyright © 2018 Esraa Abdelmotteleb. All rights reserved.
//

import UIKit

class GameOverViewController: UIViewController {

    @IBOutlet weak var scoreLabel: UILabel!
    @IBOutlet weak var newHighScoreLabel: UILabel!
    @IBOutlet weak var startNewGame: UIButton!
    
    @IBAction func startNewGame(_ sender: Any) {
        MotionHandler.sharedInstance.startDetection(updateInterval: 0.1, proximitySensorEnabled: true)
        CommandAndFeedbackHandler.sharedInstance.initialize()
        MotionHandler.sharedInstance.initialize()
        let countdownViewController = CountDownViewController()
        self.present(countdownViewController,animated: true)
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        newHighScoreLabel.isHidden = true
        let score = CommandAndFeedbackHandler.sharedInstance.score
        scoreLabel.text = String(score)
        let defaults = UserDefaults.standard
        let highestScore =  defaults.integer(forKey: "highestScore")
        if score > highestScore {
            defaults.set(score, forKey: "highestScore")
            newHighScoreLabel.isHidden = false
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
}
