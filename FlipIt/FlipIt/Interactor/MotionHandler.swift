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
    var motionName: String {
        return possibleMotion!.motionName
    }
    var motionDescribtion: String {
        return possibleMotion!.motionDescribtion
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
        disableProximityDetection()
        audioSession.removeObserver(self, forKeyPath: "outputVolume")
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
    private func detectMotion(updateInterval:Double) {
        let queue = OperationQueue.main
        detectProximity(true)
        motionManager.startAccelerometerUpdates(to: queue) { (accelerometerData, error) in
            if let data = accelerometerData {
                if data.acceleration.x < -0.8 && data.acceleration.x > -1.2 {
                    self.motionsPerformed.append(PossibleMotions.faceLeft.rawValue)
                }
                if data.acceleration.x > 0.8 && data.acceleration.x < 1.2 {
                    self.motionsPerformed.append(PossibleMotions.faceRight.rawValue)
                }
                if data.acceleration.z < -0.8 && data.acceleration.z > -1.2 {
                    self.motionsPerformed.append(PossibleMotions.faceUp.rawValue)
                }
                if data.acceleration.z > 0.8 && data.acceleration.z < 1.2 {
                    self.motionsPerformed.append(PossibleMotions.faceDown.rawValue)
                }
                if data.acceleration.y < -0.8 && data.acceleration.y > -1.2 {
                    self.motionsPerformed.append(PossibleMotions.turnTowardsFace.rawValue)
                }
                if self.motionsPerformed.count == 4 {
                    self.motionsPerformed.remove(at: 0)
                }
            }
        }
    }
    //MARK:- Proximity
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
    private func disableProximityDetection() {
        NotificationCenter.default.removeObserver(self)
        
        let device = UIDevice.current
        device.isProximityMonitoringEnabled = false
    }
    
    //MARK:- Volume:
    private func detectVolume () {
        adjustVolume()
        audioSession.addObserver (self, forKeyPath: "outputVolume", options: NSKeyValueObservingOptions.new, context: nil)
    }
    override func observeValue(forKeyPath keyPath: String?, of object: Any?, change: [NSKeyValueChangeKey : Any]?, context: UnsafeMutableRawPointer?) {
        guard let key = keyPath else { return }
        switch key {
        case "outputVolume":
            volumePressed = true
            
            if CommandAndFeedbackHandler.sharedInstance.randomNumber == PossibleMotions.pressVolume.rawValue {
                if let dictionary = change, let newValue = dictionary[.newKey] as? Float, newValue != CommandAndFeedbackHandler.sharedInstance.originalVolume {
                    MotionHandler.sharedInstance.manageVolumeSliderView(setVolume: true, newVolume: CommandAndFeedbackHandler.sharedInstance.originalVolume)
                }
            }
            adjustVolume()
        default:
            break
        }
    }
    private func manageVolumeSliderView(setVolume: Bool, newVolume: Float) {
        let volumeView = MPVolumeView().subviews.first { (aView) -> Bool in
            return NSStringFromClass(aView.classForCoder) == "MPVolumeSlider" ? true : false
            } as? UISlider
        guard volumeView != nil else { return }
        
        if setVolume {
            volumeView?.setValue(newVolume, animated: false)
        }
        volumeView?.isHidden = true
    }
    private func adjustVolume() {
        do { try audioSession.setActive(true) }
        catch { print("ERROR: \(error)") }
        
        let originalVolume = AVAudioSession.sharedInstance().outputVolume
        if originalVolume == 1 {
            self.manageVolumeSliderView(setVolume: true, newVolume: 0.9375)
        } else if originalVolume == 0 {
            self.manageVolumeSliderView(setVolume: true, newVolume: 0.125)
        }
    }
    private func countCommands() {
        var count = 0
        while PossibleMotions(rawValue: count) != nil {
            count += 1
        }
        numberOfPossibleMotions = count
    }
}

