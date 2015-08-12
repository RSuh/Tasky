    //
//  TaskTableViewCell.swift
//  Toodo
//
//  Created by Reginald Suh on 2015-07-10.
//  Copyright (c) 2015 ReginaldSuh. All rights reserved.
//

import UIKit
import RealmSwift

class TaskTableViewCell: SBGestureTableViewCell {

    @IBOutlet weak var taskLabel: UILabel!
    @IBOutlet weak var badgeImage: UIImageView!
    @IBOutlet weak var dateLabel: UILabel!
    @IBOutlet weak var chevronRight: UIImageView!
    @IBOutlet weak var crossOutTask: UIImageView!
    
    var complete: Bool?
    
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    // didSet updates everytime task is changed
    var task: Task? {
        didSet {
            if let task = task, taskLabel = taskLabel, dateLabel = dateLabel {
                dateLabel.text = task.modificationDate
                taskLabel.text = task.taskTitle as String
                
                if (task.badge == 12) {
                    println("hi")
                    badgeImage.image = UIImage(named: "badgeComplete")
                } else {
                    badgeImage.image = UIImage(named: arrayConstants.cellImagesUnselected[task.badge])
                }
            }
        }
    }
}