//
//  CommandsTutorialCell.swift
//  UIforHouseApp2
//
//  Created by Esraa Abdelmotteleb on 7/24/18.
//  Copyright © 2018 Esraa Abdelmotteleb. All rights reserved.
//

import UIKit

class CommandsTutorialCell: UITableViewCell {

    @IBOutlet weak var commandImage: UIImageView!
    @IBOutlet weak var commandNameLabel: UILabel!
    @IBOutlet weak var commandDiscribtionLabel: UILabel!
    override func awakeFromNib() {
        super.awakeFromNib()
        
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
