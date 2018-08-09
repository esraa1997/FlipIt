//
//  StartPageViewController.swift
//  FlipIt
//
//  Created by Esraa Abdelmotteleb on 8/1/18.
//  Copyright © 2018 Esraa Abdelmotteleb. All rights reserved.
//

import UIKit
import Mute

class StartPageViewController: UIViewController {
    //MARK:- Variables
    static let sharedInstance = StartPageViewController()
    var isMuted = false
    
    //MARK:- IBOutlets
    @IBOutlet weak var start: UIButton!
    @IBOutlet weak var options: UIButton!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var highScoreImageView: UIImageView!
    @IBOutlet weak var highScoreLabel: UILabel!
    
    //MARK:- IBActions
    @IBAction func start(_ sender: Any) {
        let isMuted = Mute.shared.isMute
        if isMuted {
            alertToMutedPhone()
        } else {
            MotionHandler.sharedInstance.startDetection(updateInterval: 0.1, proximitySensorEnabled: true)
            let countDownViewController = CountDownViewController()
            self.navigationController?.pushViewController(countDownViewController, animated: false)
        }
    }
    @IBAction func options(_ sender: Any) {
        let optionsViewController = OptionsViewController()
        self.navigationController?.pushViewController(optionsViewController, animated: true)
    }
    
    //MARK:- UI Standard Functions
    override func viewWillAppear(_ animated: Bool) {

        //Start button:
        start.frame = CGRect(x: view.frame.midX - view.frame.width * 0.175, y: view.frame.maxY - start.frame.width * 0.55 - 50 - view.frame.width * 0.35, width: view.frame.width * 0.35, height: view.frame.width * 0.35)
        start.layer.cornerRadius = 0.5 * start.bounds.size.width
        start.clipsToBounds = true
        
        //Options button
        options.frame = CGRect(x: start.frame.minX + 0.25 * start.frame.width , y: start.frame.maxY + 20 , width: start.frame.width * 0.55, height: start.frame.width * 0.55)
        options.layer.cornerRadius = 0.5 * options.bounds.size.width
        options.clipsToBounds = true
        options.layer.borderWidth = 2.0
        options.layer.borderColor = UIColor.white.cgColor
        
        //Others
        highScoreLabel.text = String(UserDefaults.standard.integer(forKey: "highScore"))
        self.navigationController?.isNavigationBarHidden = true
    }
    override func viewDidLoad() {
        Mute.shared.checkInterval = 0.5
        Mute.shared.alwaysNotify = true
        Mute.shared.notify = { [weak self] state in
            self?.isMuted = state
            Mute.shared.isPaused = true
        }
        highScoreImageView.image = #imageLiteral(resourceName: "crown-1")
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    //MARK:- UI Functions
    func alertToMutedPhone() {
        let alert = UIAlertController(title: "It looks like your phone is on silent", message: "This game is so much more fun with the volume on", preferredStyle: UIAlertControllerStyle.alert)
        
        alert.addAction(UIAlertAction(title: "I will unmute it", style: UIAlertActionStyle.default, handler: { _ in
            alert.dismiss(animated: true, completion: nil)
            
            MotionHandler.sharedInstance.startDetection(updateInterval: 0.1, proximitySensorEnabled: true)
            let countDownViewController = CountDownViewController()
            self.navigationController?.pushViewController(countDownViewController, animated: false)
            
        }))
        alert.addAction(UIAlertAction(title: "I want to keep it muted", style: UIAlertActionStyle.default, handler: { _ in
            alert.dismiss(animated: true, completion: nil)
            MotionHandler.sharedInstance.startDetection(updateInterval: 0.1, proximitySensorEnabled: true)
            let countDownViewController = CountDownViewController()
            self.navigationController?.pushViewController(countDownViewController, animated: false)
            
        }))

        self.present(alert, animated: true, completion: nil)
    }
}
