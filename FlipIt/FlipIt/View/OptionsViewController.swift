//
//  OptionsViewController.swift
//  FlipIt
//
//  Created by Esraa Abdelmotteleb on 8/9/18.
//  Copyright © 2018 Esraa Abdelmotteleb. All rights reserved.
//

import UIKit

class OptionsViewController: UIViewController {
    
    @IBAction func viewTutorial(_ sender: Any) {
            let tutorialViewController = TutorialViewController()
            self.navigationController?.pushViewController(tutorialViewController, animated: true)
    }
    @IBAction func resetHighScore(_ sender: Any) {
        
        let alert = UIAlertController(title: "Are you sure?", message: "if you click ok. The high score will be set to zero", preferredStyle: UIAlertControllerStyle.alert)
        
        alert.addAction(UIAlertAction(title: "Yes. I'm sure", style: UIAlertActionStyle.default, handler: { _ in
            alert.dismiss(animated: true, completion: nil)
            UserDefaults.standard.set(0, forKey: "highScore")
            
        }))
        alert.addAction(UIAlertAction(title: "No", style: UIAlertActionStyle.default, handler: { _ in
            alert.dismiss(animated: true, completion: nil)
        }))
        
        self.present(alert, animated: true, completion: nil)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = "Options"

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
}
