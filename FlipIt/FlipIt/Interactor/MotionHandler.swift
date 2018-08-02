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

class MotionHandler: UIViewController {
    //MARK:- Variables
    static let sharedInstance = MotionHandler()
    
    var motionManager = CMMotionManager()
    var pitches = [Double]()
    var rolls = [Double]()
    let queue = OperationQueue()
    
    var possibleMotion: possibleMotions? = .none
    var action: String {
        return possibleMotion!.action
    }
    var numberOfPossibleMotions = 5 //TODO: change it as Sandra adds her stuff
    var motionsPerformed = [Int]()
    
    //MARK:- Public Functions
    func startDetecting(updateInterval:Double , proximitySensorEnabled:Bool) {
        startDetectingRotation(updateInterval: updateInterval)
        startDetectingProximity(proximitySensorEnabled)
    }
    func getDetectionResults () {
       // didDetect()
        proximityChanged()
    }
    func stopDetecting() {
        motionManager.stopDeviceMotionUpdates()
    }
    
    //MARK:- Private Functions
    private func startDetectingRotation(updateInterval:Double)  {
        motionManager = CMMotionManager()
        if motionManager.isDeviceMotionAvailable == true {
            motionManager.deviceMotionUpdateInterval = updateInterval;
            motionManager.startDeviceMotionUpdates(to: queue, withHandler: { [weak self] (data, error) -> Void in
                if let attitude = data?.attitude {
                    self?.pitches.append(attitude.pitch * 180.0/Double.pi)
                    self?.rolls.append(attitude.roll * 180.0/Double.pi)
                }
            })
            //TODO: play sound that plays when I start
        }
        else {
            print("motion sensors aren't available")
        }
    }
    
	func startDetectingMotion(updateInterval:Double) {
		let queue = OperationQueue()
		startDetectingProximity(true)
		motionManager.startAccelerometerUpdates(to: queue) { (accelerometerData, error) in
			if let data = accelerometerData {
				if data.acceleration.x < -0.8 && data.acceleration.x > -1.2 {
					self.motionsPerformed.append(possibleMotions.tiltedToTheLeft.rawValue)
					print("turn left")
				}
				if data.acceleration.x > 0.8 && data.acceleration.x < 1.2 {
					self.motionsPerformed.append(possibleMotions.tiltedToTheRight.rawValue)
					print("turn right")
				}
				if data.acceleration.x < -0.8 && data.acceleration.x > -1.2 {
					self.motionsPerformed.append(possibleMotions.up.rawValue)
					print("Up")
				}
				if data.acceleration.z > 0.8 && data.acceleration.z < 1.2 {
					self.motionsPerformed.append(possibleMotions.down.rawValue)
					print("Down")
				}
				if data.acceleration.y < -0.8 && data.acceleration.y > -1.2 {
					self.motionsPerformed.append(possibleMotions.tiltedTowardsFace.rawValue)
					print("Face")
				}
			}
			
			
		}
	}
    
    private func startDetectingProximity(_ enabled: Bool) {
        let device = UIDevice.current
        device.isProximityMonitoringEnabled = enabled
        if device.isProximityMonitoringEnabled {
            NotificationCenter.default.addObserver(self, selector: #selector(proximityChanged), name: .UIDeviceProximityStateDidChange, object: device)
        }
        else {
            print("proximity sensor not enabled")
        }
    }
    
//    private func didDetect()  {
//        if pitches.first == nil {
//            print ("pitches.first == nil")
//        }
//        if pitches.last == nil {
//            print ("pitches.last == nil")
//        }
//        let pitchDiffrence = pitches.first! - pitches.last!
//        let rollDiffrence = rolls.first! - rolls.last!
//
//        if pitchDiffrence > 3 {
//            motionsPerformed.append(possibleMotions.tiltedAwayFromFace.rawValue)
//        }
//        if pitchDiffrence < -3  {
//            motionsPerformed.append(possibleMotions.tiltedTowardsFace.rawValue)
//        }
//        if rollDiffrence > 3 {
//            motionsPerformed.append(possibleMotions.tiltedToTheLeft.rawValue)
//        }
//         if rollDiffrence < -3  {
//            motionsPerformed.append(possibleMotions.tiltedToTheRight.rawValue)
//        }
//
//        pitches.removeAll()
//        rolls.removeAll()
//    }
//
    @objc private func proximityChanged() {
        motionsPerformed.append(possibleMotions.touchedScreen.rawValue)
    }
}


