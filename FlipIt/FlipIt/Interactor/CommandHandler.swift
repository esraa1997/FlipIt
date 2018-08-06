//
//  CommandHandler.swift
//  FlipIt
//
//  Created by Esraa Abdelmotteleb on 8/1/18.
//  Copyright © 2018 Esraa Abdelmotteleb. All rights reserved.
//

import UIKit
import AVFoundation
import MediaPlayer

class CommandHandler {
    
    //MARK:-Variables
	
    static let sharedInstance = CommandHandler()
    var commandTimer = Timer()
    var timeInterval = 4.0
    var oldTimeInterval = 4.0
    
    var randomNumber: Int = -1
    var numberOfCommandsGiven = 0
    var numberOfCommandsPerformedCorrectly = 0
    
    var score = 0
    var scoreIncrement = 1
    var level = 1
    var originalVolume: Float = 0
    
    //MaARK:- Public Functions
    func timerManager(multiplier: Double)  {//TODO: rename to update timer
       
        if randomNumber != -1 {
            commandTimer.invalidate()
        }
        commandTimer = Timer.scheduledTimer(timeInterval: timeInterval, target: self, selector: #selector(validateCommand), userInfo: nil, repeats: true)
    }
    
    @objc func validateCommand() -> Bool {
        let commandIsPressVolume = (randomNumber == PossibleMotions.pressVolume.rawValue)
        let commandIsCoverScreen = (randomNumber == PossibleMotions.coverScreen.rawValue)
        
            if MotionHandler.sharedInstance.motionsPerformed.contains(randomNumber)  {
                manageSpeedAndLevelAndScore()
                MotionHandler.sharedInstance.motionsPerformed.removeAll()
                MotionHandler.sharedInstance.screenCovered = false
                return true
            } else if commandIsCoverScreen && MotionHandler.sharedInstance.screenCovered == true {
                manageSpeedAndLevelAndScore()
                MotionHandler.sharedInstance.motionsPerformed.removeAll()
                return true
            } else if commandIsPressVolume && MotionHandler.sharedInstance.volumePressed == true {
                manageSpeedAndLevelAndScore()
                MotionHandler.sharedInstance.volumePressed = false
                MotionHandler.sharedInstance.screenCovered = false
                
                MotionHandler.sharedInstance.motionsPerformed.removeAll()
                return true
            } else {
                return false
            }
    }
    func giveCommand () -> (Int, String) {
        MotionHandler.sharedInstance.volumePressed = false
        //This is the old raw value of the command previosly spoken
        if randomNumber == PossibleMotions.coverScreen.rawValue {
            timeInterval = oldTimeInterval
        }
        
        randomNumber = generateRandomNumber(max: MotionHandler.sharedInstance.numberOfPossibleMotions)
        if randomNumber == PossibleMotions.pressVolume.rawValue {
            originalVolume = MotionHandler.sharedInstance.getCurrentVolume()
        }
        speakCommand(commandNumber: randomNumber)
        numberOfCommandsGiven += 1
        MotionHandler.sharedInstance.possibleMotion = PossibleMotions(rawValue: randomNumber)
        return (randomNumber, MotionHandler.sharedInstance.motion)
    }
    
    //MaARK:- Private Functions
    private func generateRandomNumber(max: Int) -> Int {
        let generatedNumber = Int(arc4random_uniform(UInt32(max)))
        return 6
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
        MotionHandler.sharedInstance.possibleMotion = PossibleMotions(rawValue: commandNumber)
        speak(text: MotionHandler.sharedInstance.motion)
    }
    func endGame () {
        speak(text: "You lost. Hahahahaha!")
        MotionHandler.sharedInstance.stopDetecting()
        initialize()
    }
    func manageSpeedAndLevelAndScore () {
        score += scoreIncrement
        numberOfCommandsPerformedCorrectly += 1
        
        if numberOfCommandsPerformedCorrectly % 3 == 0 {
            scoreIncrement += 1
             timeInterval *= 0.8
        }
        if numberOfCommandsPerformedCorrectly % 9 == 0 {
            level += 1
        }
    }
    func initialize()  {
        timeInterval = 4.0
        oldTimeInterval = 4.0
        
        randomNumber = -1
        numberOfCommandsGiven = 0
        numberOfCommandsPerformedCorrectly = 0
        
        score = 0
        scoreIncrement = 1
        level = 1
        
        originalVolume = 0
    }


}
