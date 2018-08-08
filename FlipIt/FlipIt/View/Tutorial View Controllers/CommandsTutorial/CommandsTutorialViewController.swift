//
//  CommandsTutorialViewController.swift
//  UIforHouseApp2
//
//  Created by Esraa Abdelmotteleb on 7/24/18.
//  Copyright © 2018 Esraa Abdelmotteleb. All rights reserved.
//

import UIKit

class CommandsTutorialViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var label: UILabel!
    
    let commands = String()
//    for
    let descbribtions = ["responded to your email with a long text", "wants to buy your house with monoploy money"]
    let images = [#imageLiteral(resourceName: "iphone-6-drawing-65"), #imageLiteral(resourceName: "iphone-6-drawing-65")]
    
    // MARK: - View Controller
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = "My Commands"
        setTableView(cellName: "CommandsTutorialCell")
        label.text = "Below is an illustration of what the phone's orientation should be like after each command"
        // Do any additional setup after loading the view.®
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    // MARK: - Table view setup
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return descbribtions.count
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "CommandsTutorialCell", for: indexPath) as! CommandsTutorialCell
        cell.selectionStyle = .none
        
        //commandDiscribtionLabel
        cell.commandDiscribtionLabel.numberOfLines = 3
        cell.commandDiscribtionLabel.text = descbribtions[indexPath.item]
        
        //Image:
        cell.commandImage.image = images[indexPath.item]
        

        return cell
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 332
    }
    
    // MARK: - UIMethods
    func setTableView(cellName: String) {
        let NibName = UINib(nibName: cellName, bundle: nil)
        tableView.register(NibName, forCellReuseIdentifier: cellName)
        tableView.delegate = self
//        tableView.separatorStyle = .none
    }
}
