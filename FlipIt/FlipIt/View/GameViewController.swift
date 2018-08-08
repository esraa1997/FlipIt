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
        let (_, commandText) = CommandHandler.sharedInstance.giveCommand()
        commandLabel.text = commandText
        
        commandTimer = Timer.scheduledTimer(timeInterval: CommandHandler.sharedInstance.timeInterval, target: self, selector: #selector(manageGame), userInfo: nil, repeats: true)
		MusicHelper.sharedHelper.playBackgroundMusic()
        // Do any additional setup after loading the view.
    }
    
    
    
    
    @objc func manageGame() {
        let actionValid = CommandHandler.sharedInstance.validateCommand()
        if actionValid {
            let (commandNumber, commandText) = CommandHandler.sharedInstance.giveCommand()
            commandLabel.text = commandText
            if commandNumber == PossibleMotions.coverScreen.rawValue && CommandHandler.sharedInstance.timeInterval < 2 {
                CommandHandler.sharedInstance.oldTimeInterval = CommandHandler.sharedInstance.timeInterval
                CommandHandler.sharedInstance.timeInterval = 2.5
            }
        } else {
            CommandHandler.sharedInstance.endGame()
            commandTimer.invalidate()
            let gameOverViewController = GameOverViewController()
            self.present(gameOverViewController, animated: false)
            return
        }
        CommandHandler.sharedInstance.manageSpeedAndLevel()
		
        
        if CommandHandler.sharedInstance.randomNumber != -1 {
            commandTimer.invalidate()
        }
        commandTimer = Timer.scheduledTimer(timeInterval: CommandHandler.sharedInstance.timeInterval, target: self, selector: #selector(manageGame), userInfo: nil, repeats: true)
    }
    

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
}
