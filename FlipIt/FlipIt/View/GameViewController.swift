//
//  GameViewController.swift
//  FlipIt
//
//  Created by Esraa Abdelmotteleb on 8/5/18.
//  Copyright © 2018 Esraa Abdelmotteleb. All rights reserved.
//

import UIKit
import AVFoundation

class GameViewController: UIViewController {
    //MARK:-Variables
    

    var commandTimer = Timer()
    
    @IBOutlet weak var commandLabel: UILabel!
    override func viewDidLoad() {
        super.viewDidLoad()
        let (_, commandText) = CommandAndFeedbackHandler.sharedInstance.giveCommand()
        commandLabel.text = commandText
        
        commandTimer = Timer.scheduledTimer(timeInterval: CommandAndFeedbackHandler.sharedInstance.timeInterval, target: self, selector: #selector(manageGame), userInfo: nil, repeats: true)
		MusicHelper.sharedHelper.playBackgroundMusic()
        // Do any additional setup after loading the view.
    }
    
    
    
    
    @objc func manageGame() {
        let actionValid = CommandAndFeedbackHandler.sharedInstance.validateCommand()
        if actionValid {
            let (commandNumber, commandText) = CommandAndFeedbackHandler.sharedInstance.giveCommand()
            commandLabel.text = commandText
            if commandNumber == PossibleMotions.coverScreen.rawValue && CommandAndFeedbackHandler.sharedInstance.timeInterval < 2 {
                CommandAndFeedbackHandler.sharedInstance.oldTimeInterval = CommandAndFeedbackHandler.sharedInstance.timeInterval
                CommandAndFeedbackHandler.sharedInstance.timeInterval = 2.5
            }
        } else {
            CommandAndFeedbackHandler.sharedInstance.endGame()
            commandTimer.invalidate()
            let gameOverViewController = GameOverViewController()
            self.present(gameOverViewController, animated: false)
            return
        }
        CommandAndFeedbackHandler.sharedInstance.manageSpeedAndLevel()
		
        
        if CommandAndFeedbackHandler.sharedInstance.randomNumber != -1 {
            commandTimer.invalidate()
        }
        commandTimer = Timer.scheduledTimer(timeInterval: CommandAndFeedbackHandler.sharedInstance.timeInterval, target: self, selector: #selector(manageGame), userInfo: nil, repeats: true)
    }
    

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
}
