//
//  CommandHandler.swift
//  FlipIt
//
//  Created by Esraa Abdelmotteleb on 8/1/18.
//  Copyright © 2018 Esraa Abdelmotteleb. All rights reserved.
//

import Foundation
import UIKit

class CommandHandler {
    
    //MARK:-Variables
	
    static let sharedInstance = CommandHandler()
    var commandTimer = Timer()
    var timeInterval = 5.0
    
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
    
    //MaARK:- Private Functions
    @objc func updateCommandTimer()  {
        if randomNumber == -1 {
            speedManager(multiplier: 1)
        }
        MotionHandler.sharedInstance.getDetectionResults()

        if numberOfCommandsGiven > 0 {
            print("randomnumber: \(randomNumber), last: \(MotionHandler.sharedInstance.motionsPerformed.last)")
            if randomNumber != possibleMotions.pressVolume.rawValue {
                MotionHandler.sharedInstance.motionsPerformed.removeFirst(Int(MotionHandler.sharedInstance.motionsPerformed.count * 8 / 10 ) )
            }
            if MotionHandler.sharedInstance.motionsPerformed.contains(randomNumber) || keptHandOnScreen() || randomNumber == 3 {
				if randomNumber == possibleMotions.coverScreen.rawValue  && MotionHandler.sharedInstance.detector == false  {
					print("wrong")
					PresenterViewController.sharedInstance.speak(text: "You lost. Hahahahaha!")
					MotionHandler.sharedInstance.stopDetecting()
					commandTimer.invalidate()
					//                PresenterViewController.sharedInstance.colorView.backgroundColor = UIColor.red
					//                PresenterViewController.sharedInstance.gameOver(score:score)
					
					let defaults = UserDefaults.standard
					let highestScore =  defaults.integer(forKey: "highestScore")
					if score > highestScore {
						defaults.set(score, forKey: "highestScore")
					}
					print ("Highest Score = \(highestScore)")
					return
				
				} else {
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
					MotionHandler.sharedInstance.detector = false
				}
//                PresenterViewController.sharedInstance.colorView.backgroundColor = UIColor.green
            } else {
                print("wrong")
                PresenterViewController.sharedInstance.speak(text: "You lost. Hahahahaha!")
                MotionHandler.sharedInstance.stopDetecting()
                commandTimer.invalidate()
//                PresenterViewController.sharedInstance.colorView.backgroundColor = UIColor.red
//                PresenterViewController.sharedInstance.gameOver(score:score)
                
                let defaults = UserDefaults.standard
                let highestScore =  defaults.integer(forKey: "highestScore")
                if score > highestScore {
                    defaults.set(score, forKey: "highestScore")
                }
                print ("Highest Score = \(highestScore)")
                return
            }
        }
        MotionHandler.sharedInstance.motionsPerformed.removeAll()
        randomNumber = generateRandomNumber(max: MotionHandler.sharedInstance.numberOfPossibleMotions)
        PresenterViewController.sharedInstance.speakCommand(commandNumber: randomNumber)
        numberOfCommandsGiven += 1
    }
    
    private func keptHandOnScreen () -> Bool{
         return randomNumber == 4 && MotionHandler.sharedInstance.motionsPerformed.isEmpty
    }
    private func generateRandomNumber(max: Int) -> Int {
        let generatedNumber = Int (arc4random_uniform(UInt32(max)))
        return generatedNumber
    }
    


}
