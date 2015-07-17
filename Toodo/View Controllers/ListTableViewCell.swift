//
//  ListTableViewCell.swift
//  Toodo
//
//  Created by Reginald Suh on 2015-07-14.
//  Copyright (c) 2015 ReginaldSuh. All rights reserved.
//

import UIKit
import RealmSwift

class ListTableViewCell: UITableViewCell {

    @IBOutlet weak var badgeImage: UIImageView!
    @IBOutlet weak var taskCount: UILabel!
    @IBOutlet weak var listTitle: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    var list: List? {
        didSet {
            if let list = list, listTitle = listTitle, taskCount = taskCount {
                listTitle.text = list.listTitle
                badgeImage.image = UIImage(named: arrayConstants.cellImagesUnselected[list.badge])
                //badgeImage.image = UIImage(named: "badgeWork")
            }
        }
    }
}
