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
    var volumePressed = false
    
    var motionManager = CMMotionManager()
    
    var possibleMotion: PossibleMotions? = .none
    var motion: String {
        return possibleMotion!.motions
    }
    
    var numberOfPossibleMotions = 7 //TODO: change it as Sandra adds her stuff
    var motionsPerformed = [0,0,0,0]
    
    let audioSession = AVAudioSession.sharedInstance()
    var originalVolume:Float = 0
    
    //MARK:- Public Functions
    func startDetection(updateInterval:Double , proximitySensorEnabled:Bool){
        detectMotion(updateInterval: updateInterval)
        detectProximity(proximitySensorEnabled)
        
        //Volume Control
        let audioSession = AVAudioSession.sharedInstance()
        originalVolume = audioSession.outputVolume
        if originalVolume == 1 {
            originalVolume = 0.99
        }
        audioSession.addObserver (self, forKeyPath: "outputVolume", options: NSKeyValueObservingOptions.new, context: nil)
        do { try audioSession.setActive(true) }
        catch { print("\(error)") }
    }
    func stopDetecting() {
        motionManager.stopDeviceMotionUpdates()
    }
    
    //MARK:- Private Functions
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
    

    @objc private func proximityChanged() {
		screenCovered = true
    }
    
    override func observeValue(forKeyPath keyPath: String?, of object: Any?, change: [NSKeyValueChangeKey : Any]?, context: UnsafeMutableRawPointer?) {
        guard let key = keyPath else { return }
        switch key {
        case "outputVolume":
            volumePressed = true
            
        default:
            break
        }
    }
    
}

