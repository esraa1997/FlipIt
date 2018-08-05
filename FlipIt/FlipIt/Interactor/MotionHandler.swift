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

class MotionHandler: UIViewController {
    //MARK:- Variables
    static let sharedInstance = MotionHandler()
	var screenCovered = false
    
    var motionManager = CMMotionManager()
    
    var possibleMotion: possibleMotions? = .none
    var action: String {
        return possibleMotion!.action
    }
    
    var numberOfPossibleMotions = 7 //TODO: change it as Sandra adds her stuff
    var motionsPerformed = [Int]()
    
    let audioSession = AVAudioSession.sharedInstance()
    var originalVolume:Float = 0
    
    //MARK:- Public Functions
    func startDetection(updateInterval:Double , proximitySensorEnabled:Bool) {
        detectMotion(updateInterval: updateInterval)
        detectProximity(proximitySensorEnabled)
        
        //Volume Control
        let audioSession = AVAudioSession.sharedInstance()
        originalVolume = audioSession.outputVolume
        //TODO: make volume = original volume at the end
        audioSession.addObserver (self, forKeyPath: "outputVolume", options: NSKeyValueObservingOptions.new, context: nil)
        do { try audioSession.setActive(true) }
        catch { print("\(error)") }
    }
    func stopDetecting() {
        motionManager.stopDeviceMotionUpdates()
    }
    
    //MARK:- Private Functions
    
	private func detectMotion(updateInterval:Double) {
		let queue = OperationQueue()
		detectProximity(true)
		motionManager.startAccelerometerUpdates(to: queue) { (accelerometerData, error) in
			if let data = accelerometerData {
				if data.acceleration.x < -0.8 && data.acceleration.x > -1.2 {
					self.motionsPerformed.append(possibleMotions.faceLeft.rawValue)
                    print("left")
				}
				if data.acceleration.x > 0.8 && data.acceleration.x < 1.2 {
					self.motionsPerformed.append(possibleMotions.faceRight.rawValue)
                    print("right")
				}
				if data.acceleration.z < -0.8 && data.acceleration.z > -1.2 {
					self.motionsPerformed.append(possibleMotions.faceUp.rawValue)
                    print("Up")
				}
				if data.acceleration.z > 0.8 && data.acceleration.z < 1.2 {
					self.motionsPerformed.append(possibleMotions.faceDown.rawValue)
                    print("Down")
				}
				if data.acceleration.y < -0.8 && data.acceleration.y > -1.2 {
					self.motionsPerformed.append(possibleMotions.turnTowardsFace.rawValue)
                    print("Face")
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
    

    @objc private func proximityChanged() {
        motionsPerformed.append(possibleMotions.coverScreen.rawValue)
		screenCovered = !screenCovered
    }
    
    override func observeValue(forKeyPath keyPath: String?, of object: Any?, change: [NSKeyValueChangeKey : Any]?, context: UnsafeMutableRawPointer?) {
        guard let key = keyPath else { return }
        switch key {
        case "outputVolume":
            //TODO: set the volume to half point
            StartPageViewController.sharedInstance.manageSliderView()
            MotionHandler.sharedInstance.motionsPerformed.append(possibleMotions.pressVolume.rawValue)
        default:
            break
        }
    }
    
    //e
}

//TODO: When it starts with cover screen, it says I lost
