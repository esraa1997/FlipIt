//
//  GameViewController.swift
//  FlipIt
//
//  Created by Esraa Abdelmotteleb on 8/5/18.
//  Copyright © 2018 Esraa Abdelmotteleb. All rights reserved.
//

import UIKit
import MediaPlayer

class GameViewController: UIViewController {
    //MARK:-Variables
    var commandTimer = Timer()
    
    //MARK:- Outlets
    @IBOutlet weak var commandLabel: UILabel!
    
    //MARK:- Standard UI functions
    override func viewDidLoad() {
        super.viewDidLoad()
        hideVolumeView()
        self.becomeFirstResponder()
        MusicHelper.sharedHelper.playBackgroundMusic()
        CommandAndFeedbackHandler.sharedInstance.initialize()
        let (_, commandText) = CommandAndFeedbackHandler.sharedInstance.giveCommand()
		self.commandLabel.text = commandText
        commandTimer = Timer.scheduledTimer(timeInterval: CommandAndFeedbackHandler.sharedInstance.timeInterval, target: self, selector: #selector(manageGame), userInfo: nil, repeats: true)
        
    }
    
    override var canBecomeFirstResponder: Bool {
            return true
    }
    
    override func motionEnded(_ motion: UIEventSubtype, with event: UIEvent?) {
        if motion == .motionShake {
            MotionHandler.sharedInstance.respondToShake()
        }
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    //MARK:- UI Functions
    @objc func manageGame() {
	
        let actionValid = CommandAndFeedbackHandler.sharedInstance.validateCommand()
        if actionValid {
            let (commandNumber, commandText) = CommandAndFeedbackHandler.sharedInstance.giveCommand()
			commandLabel.text = ""
			DispatchQueue.main.asyncAfter(deadline: .now() + 0.2) {
				self.commandLabel.text = commandText
			}
			
            if commandNumber == PossibleMotions.coverScreen.rawValue && CommandAndFeedbackHandler.sharedInstance.timeInterval < 2.0 {
                CommandAndFeedbackHandler.sharedInstance.oldTimeInterval = CommandAndFeedbackHandler.sharedInstance.timeInterval
                CommandAndFeedbackHandler.sharedInstance.timeInterval = 2.5
            }
            if commandNumber == PossibleMotions.shake.rawValue && CommandAndFeedbackHandler.sharedInstance.timeInterval < 1.5 {
                CommandAndFeedbackHandler.sharedInstance.oldTimeInterval = CommandAndFeedbackHandler.sharedInstance.timeInterval
                CommandAndFeedbackHandler.sharedInstance.timeInterval = 1.5
			
            }
			
        } else {
            CommandAndFeedbackHandler.sharedInstance.endGame()
            commandTimer.invalidate()
            let gameOverViewController = GameOverViewController()
            self.present(gameOverViewController, animated: false)
            return
        }
        if CommandAndFeedbackHandler.sharedInstance.randomNumber != -1 {
            commandTimer.invalidate()
        }
		
        commandTimer = Timer.scheduledTimer(timeInterval: CommandAndFeedbackHandler.sharedInstance.timeInterval, target: self, selector: #selector(manageGame), userInfo: nil, repeats: true)
    }
    
    func hideVolumeView() {
        let volumeView = MPVolumeView(frame: .zero)
        volumeView.clipsToBounds = true
        view.addSubview(volumeView)
    }
    
    
}
