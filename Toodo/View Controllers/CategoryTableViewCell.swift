//
//  CategoryTableViewCell.swift
//  Toodo
//
//  Created by Reginald Suh on 2015-07-14.
//  Copyright (c) 2015 ReginaldSuh. All rights reserved.
//

import UIKit
import RealmSwift

class CategoryTableViewCell: SBGestureTableViewCell {

    // Initialize realm
    let realm = Realm()

    @IBOutlet weak var taskCount: UILabel!
    @IBOutlet weak var categoryTitle: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    var category: Category? {
        didSet {
            if let category = category, categoryTitle = categoryTitle {
                
                // Set the text of the categoryTitle to the category title of the category
                categoryTitle.text = category.categoryTitle
            }
        }
    }
}   
