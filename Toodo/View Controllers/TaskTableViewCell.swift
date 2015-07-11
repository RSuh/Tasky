//
//  TaskTableViewCell.swift
//  Toodo
//
//  Created by Reginald Suh on 2015-07-10.
//  Copyright (c) 2015 ReginaldSuh. All rights reserved.
//

import UIKit

class TaskTableViewCell: UITableViewCell {

    @IBOutlet weak var taskLabel: UILabel!
    @IBOutlet weak var badgeImage: UIImageView!
    @IBOutlet weak var chevronRight: UIImageView!
    @IBOutlet weak var dateLabel: UILabel!
    
    static var presentDate: NSDateFormatter {
       var formatter = NSDateFormatter()
        formatter.dateFormat = "dd-MM-yyyy"
        return formatter
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    // didSet updates everytime it is refreshed
    var task: Task? {
        didSet {
            if let task = task, taskLabel = taskLabel, dateLabel = dateLabel {
                taskLabel.text = task.taskTitle
                dateLabel.text = TaskTableViewCell.presentDate.stringFromDate(task.modificationDate)
            }
        }
    }
}