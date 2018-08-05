//
//  CountDownViewController.swift
//  FlipIt
//
//  Created by Esraa Abdelmotteleb on 8/5/18.
//  Copyright © 2018 Esraa Abdelmotteleb. All rights reserved.
//

import UIKit

class CountDownViewController: UIViewController {
    
    //MARK:- Outlets:
    @IBOutlet weak var countdownLabel: UILabel!
    
    //MARK:- Variables
    var countdownTimer = Timer()
    var counter = 3
    
    //MARK:- Stadards functions
    override func viewDidLoad() {
        super.viewDidLoad()
        countdownLabel.text = String(counter)
        countdownTimer = Timer.scheduledTimer(timeInterval: 1, target: self, selector: #selector(updateTimer), userInfo: nil, repeats: true)
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    //MARK:- UI Functions
    @objc func updateTimer() {
        counter -= 1
        
        if counter > 0 {
            countdownLabel.text = String(counter)
        } else if counter == 0 {
            countdownLabel.text = "GO"
        } else {
            countdownTimer.invalidate()
            
            let gameViewController = GameViewController()
            self.present(gameViewController, animated: false)
            
            CommandHandler.sharedInstance.updateCommandTimer()
        }
    }

}
