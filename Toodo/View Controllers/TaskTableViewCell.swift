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
                
                dateLabel.text! = task.modificationDate
                taskLabel.text = task.taskTitle as String
                
                if (task.complete == true) {
                    badgeImage.image = UIImage(named: "badgeComplete")
                    // Does the strikethrough of the text
                    let attributes = [NSStrikethroughStyleAttributeName : NSUnderlineStyle.StyleSingle.rawValue]
                    taskLabel.attributedText = NSAttributedString(string: taskLabel.text!, attributes: attributes)
                } else {
                    badgeImage.image = UIImage(named: arrayConstants.cellImagesUnselected[task.badge])
                    // UnDoes the strikethrough of the text
                    taskLabel.attributedText = NSAttributedString(string: taskLabel.text!, attributes: nil)
                }
            }
        }
    }
}