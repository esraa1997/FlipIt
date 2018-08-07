//
//  ViewController.swift
//  FlipIt
//
//  Created by Esraa Abdelmotteleb on 7/31/18.
//  Copyright © 2018 Esraa Abdelmotteleb. All rights reserved.
//
//resource: https://nshipster.com/cmdevicemotion/

import UIKit
import CoreMotion
import AVFoundation
import MediaPlayer

class MotionHandler: UIViewController {
    //MARK:- Variables
    static let sharedInstance = MotionHandler()
	var screenCovered = false
    var volumePressed = false
    var phoneShoken = false
    
    var motionManager = CMMotionManager()
    
    var possibleMotion: PossibleMotions? = .none
    var motion: String {
        return possibleMotion!.motions
    }
    
    var numberOfPossibleMotions = 8 //TODO: change it as Sandra adds her stuff
    var motionsPerformed = [0,0,0,0]
    
    let audioSession = AVAudioSession.sharedInstance()
    
    //MARK:- Public Functions
    func startDetection(updateInterval:Double , proximitySensorEnabled:Bool){
        detectMotion(updateInterval: updateInterval)
        detectProximity(proximitySensorEnabled)
        detectVolume()
    }
    func stopDetecting() {
        motionManager.stopDeviceMotionUpdates()
    }
    
    func getCurrentVolume () -> Float{
        do { try audioSession.setActive(true) }
        catch { print("\(error)") }
        
        return AVAudioSession.sharedInstance().outputVolume
    }
    
    func respondToShake() {
        phoneShoken = true
    }
    func initialize () {
        screenCovered = false
        volumePressed = false
        phoneShoken = false
    }
    
    //MARK:- Private Functions
    private func manageSliderView(setVolume: Bool, newVolume: Float) {
        let systemSlider = MPVolumeView().subviews.first { (aView) -> Bool in
            return NSStringFromClass(aView.classForCoder) == "MPVolumeSlider" ? true : false
            } as? UISlider
        guard systemSlider != nil else { return }
        
        if setVolume {
            systemSlider?.setValue(newVolume, animated: false)
        }
        systemSlider?.isHidden = true
    }
	private func detectMotion(updateInterval:Double) {
		let queue = OperationQueue.main
		detectProximity(true)
		motionManager.startAccelerometerUpdates(to: queue) { (accelerometerData, error) in
			if let data = accelerometerData {
				if data.acceleration.x < -0.8 && data.acceleration.x > -1.2 {
					self.motionsPerformed.append(PossibleMotions.faceLeft.rawValue)
//                    print("left")
				}
				if data.acceleration.x > 0.8 && data.acceleration.x < 1.2 {
					self.motionsPerformed.append(PossibleMotions.faceRight.rawValue)
//                    print("right")
				}
				if data.acceleration.z < -0.8 && data.acceleration.z > -1.2 {
					self.motionsPerformed.append(PossibleMotions.faceUp.rawValue)
//                    print("Up")
				}
				if data.acceleration.z > 0.8 && data.acceleration.z < 1.2 {
					self.motionsPerformed.append(PossibleMotions.faceDown.rawValue)
//                    print("Down")
				}
				if data.acceleration.y < -0.8 && data.acceleration.y > -1.2 {
					self.motionsPerformed.append(PossibleMotions.turnTowardsFace.rawValue)
//                    print("Face")
				}
                if self.motionsPerformed.count == 4 {
                    self.motionsPerformed.remove(at: 0)
                }
			}
		}
	}
    private func detectProximity(_ enabled: Bool) {
        let device = UIDevice.current
        device.isProximityMonitoringEnabled = enabled
        if device.isProximityMonitoringEnabled {
            NotificationCenter.default.addObserver(self, selector: #selector(proximityChanged), name: .UIDeviceProximityStateDidChange, object: device)
        }
        else {
            print("proximity sensor not enabled")
        }
    }
    private func detectVolume () {
        adjustVolume()
        
        audioSession.addObserver (self, forKeyPath: "outputVolume", options: NSKeyValueObservingOptions.new, context: nil)
    }
    private func adjustVolume() {
        do { try audioSession.setActive(true) }
        catch { print("ERROR: \(error)") }
        
        let originalVolume = AVAudioSession.sharedInstance().outputVolume
        if originalVolume == 1 {
            self.manageSliderView(setVolume: true, newVolume: 0.9375)
        } else if originalVolume == 0 {
            self.manageSliderView(setVolume: true, newVolume: 0.125)
        }
    }
    @objc private func proximityChanged() {
		screenCovered = true
    }
    
    override func observeValue(forKeyPath keyPath: String?, of object: Any?, change: [NSKeyValueChangeKey : Any]?, context: UnsafeMutableRawPointer?) {
        guard let key = keyPath else { return }
        switch key {
        case "outputVolume":
            volumePressed = true

            if CommandAndFeedbackHandler.sharedInstance.randomNumber == PossibleMotions.pressVolume.rawValue {
                
                if let dictionary = change, let newValue = dictionary[.newKey] as? Float, newValue != CommandAndFeedbackHandler.sharedInstance.originalVolume {
                    MotionHandler.sharedInstance.manageSliderView(setVolume: true, newVolume: CommandAndFeedbackHandler.sharedInstance.originalVolume)
                }
                adjustVolume()
            }
            
        default:
            break
        }
    }
    
}

