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
        let countdownViewController = CountDownViewController()
        self.present(countdownViewController,animated: true)
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        //button
        startNewGame.layer.borderColor = UIColor.black.cgColor
        startNewGame.layer.borderWidth = 2.0
        
        
        //else
        newHighScoreLabel.isHidden = true
        let score = CommandHandler.sharedInstance.score
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
