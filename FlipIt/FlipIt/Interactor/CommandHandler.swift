//
//  CommandHandler.swift
//  FlipIt
//
//  Created by Esraa Abdelmotteleb on 8/1/18.
//  Copyright © 2018 Esraa Abdelmotteleb. All rights reserved.
//

import UIKit
import AVFoundation

class CommandHandler {
    
    //MARK:-Variables
	
    static let sharedInstance = CommandHandler()
    var commandTimer = Timer()
    var timeInterval = 2.0
    
    var randomNumber: Int = -1
    var numberOfCommandsGiven = 0
    var numberOfCommandsPerformedCorrectly = 0
    
    var score = 0
    var scoreIncrement = 1
    
    var level = 1
    
    //MaARK:- Public Functions
    func speedManager(multiplier: Double)  {
        timeInterval *= multiplier
        if randomNumber != -1 {
            commandTimer.invalidate()
        }
        commandTimer = Timer.scheduledTimer(timeInterval: timeInterval, target: self, selector: #selector(updateCommandTimer), userInfo: nil, repeats: true)
    }
    
    @objc func updateCommandTimer()  {
        // Test whether given command is performed correctly
            if randomNumber != possibleMotions.pressVolume.rawValue {
              //  MotionHandler.sharedInstance.motionsPerformed.removeFirst(Int(MotionHandler.sharedInstance.motionsPerformed.count * 8 / 10 ) )
            }
            if MotionHandler.sharedInstance.motionsPerformed.contains(randomNumber)  {
   				if randomNumber == possibleMotions.coverScreen.rawValue  {
					MotionHandler.sharedInstance.screenCovered = true
				} else {
					MotionHandler.sharedInstance.screenCovered = false
					score += scoreIncrement
					print(score)
					numberOfCommandsPerformedCorrectly += 1
					if numberOfCommandsPerformedCorrectly % 3 == 0 {
						scoreIncrement += 1
						speedManager(multiplier: 0.8)
					}
					if numberOfCommandsPerformedCorrectly % 9 == 0 {
						level += 1
					}
					MotionHandler.sharedInstance.screenCovered = false
				}
//                StartPageViewController.sharedInstance.colorView.backgroundColor = UIColor.green
            } else {
                gameOver()
            }
        MotionHandler.sharedInstance.motionsPerformed.removeAll()
        
        giveCommand ()
    }
    func giveCommand () {
        randomNumber = generateRandomNumber(max: MotionHandler.sharedInstance.numberOfPossibleMotions)
        speakCommand(commandNumber: randomNumber)
        numberOfCommandsGiven += 1
    }
    
    //MaARK:- Private Functions
    private func generateRandomNumber(max: Int) -> Int {
        let generatedNumber = Int (arc4random_uniform(UInt32(max)))
        return generatedNumber
    }
    private func speak (text: String) {
        let mySynthesizer = AVSpeechSynthesizer()
        let myUtterence = AVSpeechUtterance(string:text)
        myUtterence.rate = 0.5
        myUtterence.voice = AVSpeechSynthesisVoice(language: "en-au")
        myUtterence.pitchMultiplier = 1.0 //between 0.5 and 2.0. Default is 1.0.
        mySynthesizer.speak(myUtterence)
    }
    private func speakCommand (commandNumber: Int) {
        MotionHandler.sharedInstance.possibleMotion = possibleMotions(rawValue: commandNumber)
        speak(text: MotionHandler.sharedInstance.action)
    }
    private func gameOver () {
        print("wrong")
        speak(text: "You lost. Hahahahaha!")
        MotionHandler.sharedInstance.stopDetecting()
        commandTimer.invalidate()
        //                StartPageViewController.sharedInstance.colorView.backgroundColor = UIColor.red
        //                StartPageViewController.sharedInstance.gameOver(score:score)
        let defaults = UserDefaults.standard
        let highestScore =  defaults.integer(forKey: "highestScore")
        if score > highestScore {
            defaults.set(score, forKey: "highestScore")
        }
        print ("Highest Score = \(highestScore)")
        return
    }


}
