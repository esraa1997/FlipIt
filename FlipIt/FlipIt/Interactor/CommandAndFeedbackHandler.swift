//
//  CommandAndFeedbackHandler.swift
//  FlipIt
//
//  Created by Esraa Abdelmotteleb on 8/1/18.
//  Copyright © 2018 Esraa Abdelmotteleb. All rights reserved.
//

import UIKit
import AVFoundation
import MediaPlayer
import AudioToolbox

class CommandAndFeedbackHandler {
    
    //MARK:-Variables
	
    static let sharedInstance = CommandAndFeedbackHandler()
    var commandTimer = Timer()
    var timeInterval:Double = 3.0
    var oldTimeInterval:Double = 4.0
    
    var randomNumber: Int = -1
    var numberOfCommandsGiven = 0
    var numberOfCommandsPerformedCorrectly = 0
    
    var score = 0
    var scoreIncrement = 1
    var level = 1
    var originalVolume: Float = 0
    
    //MaARK:- Public Functions
    func updateTimer(multiplier: Double)  {
        if randomNumber != -1 {
            commandTimer.invalidate()
        }
        commandTimer = Timer.scheduledTimer(timeInterval: timeInterval, target: self, selector: #selector(validateCommand), userInfo: nil, repeats: true)
    }
    func giveCommand () -> (Int, String) {
        MotionHandler.sharedInstance.volumePressed = false
        //This is the old raw value of the command previosly spoken
        if randomNumber == PossibleMotions.coverScreen.rawValue {
            timeInterval = oldTimeInterval
        }
        if randomNumber == PossibleMotions.shake.rawValue {
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
    
    @objc func validateCommand() -> Bool {
        let commandIsPressVolume = (randomNumber == PossibleMotions.pressVolume.rawValue)
        let commandIsCoverScreen = (randomNumber == PossibleMotions.coverScreen.rawValue)
        let commandIsShake = (randomNumber == PossibleMotions.shake.rawValue)
            if MotionHandler.sharedInstance.motionsPerformed.contains(randomNumber)  {
                handleSuccess()
                MotionHandler.sharedInstance.screenCovered = false
                return true
            } else if commandIsCoverScreen && MotionHandler.sharedInstance.screenCovered == true {
                handleSuccess()
                return true
            } else if commandIsPressVolume && MotionHandler.sharedInstance.volumePressed == true {
                handleSuccess()
                MotionHandler.sharedInstance.volumePressed = false
                MotionHandler.sharedInstance.screenCovered = false
                
                MotionHandler.sharedInstance.motionsPerformed.removeAll()
                return true
            } else if commandIsShake && MotionHandler.sharedInstance.phoneShoken {
                handleSuccess()
                MotionHandler.sharedInstance.phoneShoken = false
                MotionHandler.sharedInstance.screenCovered = false
                return true
            } else {
                MotionHandler.sharedInstance.motionsPerformed.removeAll()
                return false
            }
    }
    
    func endGame () {
        MotionHandler.sharedInstance.stopDetecting()
        vibrate(motionValid: false)
        speak(text: "You lost. Hahahahaha!")
    }
    func initialize()  {
        timeInterval = 3
        oldTimeInterval = 3.0
        
        randomNumber = -1
        numberOfCommandsGiven = 0
        numberOfCommandsPerformedCorrectly = 0
        
        score = 0
        scoreIncrement = 1
        level = 1
        
        originalVolume = 0
    }
    
    //MaARK:- Private Functions
    private func generateRandomNumber(max: Int) -> Int {
        let generatedNumber = Int(arc4random_uniform(UInt32(max)))
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
        MotionHandler.sharedInstance.possibleMotion = PossibleMotions(rawValue: commandNumber)
        speak(text: MotionHandler.sharedInstance.motion)
    }
    private func handleSuccess () {
        vibrate(motionValid: true)
        score += scoreIncrement
        numberOfCommandsPerformedCorrectly += 1
        
        if numberOfCommandsPerformedCorrectly % 3 == 0 {
            scoreIncrement += 1
             timeInterval *= 0.8
        }
        if numberOfCommandsPerformedCorrectly % 9 == 0 {
            level += 1
        }
        MotionHandler.sharedInstance.motionsPerformed.removeAll()
    }
    
    private func vibrate(motionValid: Bool) {
        if let device = UIDevice.current.value(forKey: "_feedbackSupportLevel") as! Int? {
            
            if device == 0 {
                if motionValid {
                   return
                } else {
                    AudioServicesPlaySystemSound(SystemSoundID(kSystemSoundID_Vibrate))
                }
            }
            
            if device == 1 {
                if motionValid {
                    AudioServicesPlaySystemSound(1520)
                } else {
                    AudioServicesPlaySystemSound(SystemSoundID(kSystemSoundID_Vibrate))
                }
            }
            
            if device == 2 {
                if motionValid {
                    if #available(iOS 10,*) {
                        let generator = UINotificationFeedbackGenerator()
                        generator.notificationOccurred(.success)
                    }
                } else {
                    if #available( iOS 10, *) {
                        let generator = UINotificationFeedbackGenerator()
                        generator.notificationOccurred(.error)
                    }
                }
            }
            
        } else {
            print("couldn't detect the Feedback Support Level")
            if motionValid {
                return
            } else {
                AudioServicesPlaySystemSound(SystemSoundID(kSystemSoundID_Vibrate))
            }
        }
    }
}
