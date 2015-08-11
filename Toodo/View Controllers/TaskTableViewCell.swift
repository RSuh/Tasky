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
    
    static var presentDate: NSDateFormatter {
       var formatter = NSDateFormatter()
        // Can set custom dates, refer to http://www.codingexplorer.com/swiftly-getting-human-readable-date-nsdateformatter/
        formatter.dateFormat = "EEEE, MMMM dd"
        return formatter
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        
        // Hides the crossOutLabel on load
        self.crossOutTask.hidden = true
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
                badgeImage.image = UIImage(named: arrayConstants.cellImagesUnselected[task.badge])
                //chevronRight.image = UIImage(named: "chevronRight")
            }
        }
    }
}