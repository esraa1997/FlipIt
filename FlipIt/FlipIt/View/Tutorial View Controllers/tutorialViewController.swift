//
//  tutorialViewController.swift
//  FlipIt
//
//  Created by Esraa Abdelmotteleb on 8/7/18.
//  Copyright © 2018 Esraa Abdelmotteleb. All rights reserved.
//

import UIKit

class tutorialViewController: UIViewController {
    @IBOutlet weak var instructionsLabel: UILabel!
    
    @IBAction func seeCommands(_ sender: Any) {
        let commandsTutorialViewController =  CommandsTutorialViewController(nibName: "CommandsTutorialViewController", bundle: nil)
        self.navigationController?.pushViewController(commandsTutorialViewController, animated: true)
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = "Train Me"
        instructionsLabel.text = "Flip It is a challenging concentration and speed game. When you hear or see a command on the screen, you have to perform it before the next command is given. \n\nThe commands will keep coming at you faster and faster and you will be getting more and more points."
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    
}
