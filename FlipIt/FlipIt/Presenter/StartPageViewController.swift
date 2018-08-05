//
//  StartPageViewController.swift
//  FlipIt
//
//  Created by Esraa Abdelmotteleb on 8/1/18.
//  Copyright © 2018 Esraa Abdelmotteleb. All rights reserved.
//

import UIKit
import MediaPlayer

class StartPageViewController: UIViewController {
    
    //MARK:- IBOutlets
    @IBOutlet weak var start: UIButton!
    @IBOutlet weak var myScores: UIButton!
    @IBOutlet weak var titleLabel: UILabel!
    
    //MARK:- IBActions
    @IBAction func start(_ sender: Any) {
        MotionHandler.sharedInstance.startDetection(updateInterval: 0.02, proximitySensorEnabled: true)
        let countDownViewController = CountDownViewController()
        self.present(countDownViewController, animated: false)
    }
    @IBAction func myScores(_ sender: Any) {
    }
    
    //MARK:- Variables
    static let sharedInstance = StartPageViewController()
    
    //MARK:- UI Standard Functions
    override func viewWillAppear(_ animated: Bool) {
        
        //Start button:
        start.frame = CGRect(x: view.frame.midX - view.frame.width * 0.25, y: view.frame.midY , width: view.frame.width * 0.5, height: view.frame.width * 0.5)
        
        start.layer.cornerRadius = 0.5 * start.bounds.size.width
        start.clipsToBounds = true
        
        //myscores button
        myScores.frame = CGRect(x: start.frame.minX + 0.25 * start.frame.width , y: start.frame.maxY + 20 , width: start.frame.width * 0.55, height: start.frame.width * 0.55)
        myScores.layer.cornerRadius = 0.5 * myScores.bounds.size.width
        myScores.clipsToBounds = true
        myScores.layer.borderWidth = 2.0
        myScores.layer.borderColor = UIColor.white.cgColor
    }
    override func viewDidLoad() {
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    
    //MARK:- UI Functions
    
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
