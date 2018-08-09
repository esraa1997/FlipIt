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
    @IBOutlet weak var highScoreLabel: UILabel!
    
    @IBAction func startNewGame(_ sender: Any) {
        
        let startPageViewController = StartPageViewController()
        self.present(startPageViewController,animated: true)
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        
        newHighScoreLabel.isHidden = true
        let score = CommandAndFeedbackHandler.sharedInstance.score
        scoreLabel.text = String(score)
        let defaults = UserDefaults.standard
        let highScore =  defaults.integer(forKey: "highScore")
        if score > highScore {
            defaults.set(score, forKey: "highScore")
            newHighScoreLabel.isHidden = false
        }
        highScoreLabel.text = String(highScore)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
}
