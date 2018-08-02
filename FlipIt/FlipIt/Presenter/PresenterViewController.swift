//
//  PresenterViewController.swift
//  FlipIt
//
//  Created by Esraa Abdelmotteleb on 8/1/18.
//  Copyright © 2018 Esraa Abdelmotteleb. All rights reserved.
//

import UIKit
import CoreMotion
import AVFoundation
import MediaPlayer

class PresenterViewController: UIViewController {
    
    //MARK:- IBOutlets
    @IBOutlet weak var colorView: UIView!
    @IBOutlet weak var countDownLabel: UILabel!
    @IBOutlet weak var start: UIButton!
    @IBOutlet weak var myScores: UIButton!
    
    //MARK:- IBActiona
    @IBAction func start(_ sender: Any) {
        start.isHidden = true
//        MotionHandler.sharedInstance.startDetecting(updateInterval: 0.02, proximitySensorEnabled: true)
        MotionHandler.sharedInstance.startDetection(updateInterval: 0.02, proximitySensorEnabled: true, observer: self)
		countdownLabelTimer = Timer.scheduledTimer(timeInterval: 1, target: self, selector: #selector(updateTimer), userInfo: nil, repeats: true)
    }
    @IBAction func myScores(_ sender: Any) {
    }
    
    //MARK:- Variables
    static let sharedInstance = PresenterViewController()
    var counter = 4
    var countdownLabelTimer = Timer()
    
    //MARK:- UI Standard Functions
    override func viewWillAppear(_ animated: Bool) {
        
        //Start button:
        start.frame = CGRect(x: view.frame.midX - view.frame.width * 0.213, y: view.frame.midY , width: view.frame.width * 0.387, height: view.frame.width * 0.387)
        start.layer.cornerRadius = 0.5 * start.bounds.size.width
        start.clipsToBounds = true
        
        //myscores button
        myScores.frame = CGRect(x: start.frame.minX + 0.25 * start.frame.width , y: 1.25 * start.frame.maxY , width: start.frame.width * 0.5, height: start.frame.width * 0.5)
        myScores.layer.cornerRadius = 0.5 * myScores.bounds.size.width
        myScores.clipsToBounds = true
        myScores.layer.borderWidth = 1.0
        myScores.layer.borderColor = UIColor.black.cgColor
        countDownLabel.isHidden = true
    }
    override func viewDidLoad() {
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    
    //MARK:- UI Functions
    func speak (text: String) {
        let mySynthesizer = AVSpeechSynthesizer()
        let myUtterence = AVSpeechUtterance(string:text)
        myUtterence.rate = 0.3
        myUtterence.voice = AVSpeechSynthesisVoice(language: "en-au")
        myUtterence.pitchMultiplier = 1.0 //between 0.5 and 2.0. Default is 1.0.
        mySynthesizer.speak(myUtterence)
    }
    func speakCommand (commandNumber: Int) {
        MotionHandler.sharedInstance.possibleMotion = possibleMotions(rawValue: commandNumber)
        speak(text: MotionHandler.sharedInstance.action)
    }
    @objc func updateTimer() {
        countDownLabel.isHidden = false
        counter -= 1
        countDownLabel.text = String(counter)
        if counter == 0 {
            countdownLabelTimer.invalidate()
            countDownLabel.text = ""
            CommandHandler.sharedInstance.updateCommandTimer()
        }
    }
    override func observeValue(forKeyPath keyPath: String?, of object: Any?, change: [NSKeyValueChangeKey : Any]?, context: UnsafeMutableRawPointer?) {
        guard let key = keyPath else { return }
        switch key {
        case "outputVolume":
            guard let dict = change, let temp = dict[NSKeyValueChangeKey.newKey] as? Float, temp != 0.5 else { return }
            // set the volume to half point
            PresenterViewController.sharedInstance.manageSliderView()
            MotionHandler.sharedInstance.motionsPerformed.append(possibleMotions.pressVolume.rawValue)
        default:
            break
        }
    }
    
    func manageSliderView() {
        let systemSlider = MPVolumeView().subviews.first { (aView) -> Bool in
            return NSStringFromClass(aView.classForCoder) == "MPVolumeSlider" ? true : false
            } as? UISlider
        systemSlider?.setValue(0.5, animated: false)
        systemSlider?.isHidden = true
        guard systemSlider != nil else { return }
    }
//    func gameOver(score: Int) {
//        countDownLabel.text = "Your score is: " + String(score)
//    }
}

//TODO: with volume, use contains
//score
