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
    
    var complete: Bool?
    
    @IBOutlet weak var categoryCellColor: UIView!
    @IBOutlet weak var taskCount: UILabel!
    @IBOutlet weak var categoryTitle: UILabel!
    @IBOutlet weak var chevronRight: UIImageView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    
    var category: Category? {
        didSet {
            if let category = category, categoryTitle = categoryTitle, taskCount = taskCount, categoryCellColor = categoryCellColor {
                // Sets the text of how many tasks are in a category
                taskCount.text = "\(category.tasksWithinCategory.count) Items"
                
                // Set the text of the categoryTitle to the category title of the category
                categoryTitle.text = category.categoryTitle
                
                categoryCellColor.backgroundColor = UIColor(red: CGFloat(category.R), green: CGFloat(category.G), blue: CGFloat(category.B), alpha: 1.0)

                
                if (category.complete == true) {
                    //categoryCellColor.backgroundColor = UIColor(red:0.11, green:0.78, blue:0.35, alpha:1.0)
                    //println(categoryCellColor.backgroundColor)
                    println("category should be green")
                    chevronRight.hidden = true
                    let attributes = [NSStrikethroughStyleAttributeName : NSUnderlineStyle.StyleSingle.rawValue]
                    categoryTitle.attributedText = NSAttributedString(string: categoryTitle.text!, attributes: attributes)
                    
                } else {
                    println("category should be regular")
                    // Sets the cell color image to a UIImage named the category.imageName
                    //categoryCellColor.backgroundColor = UIColor(red: CGFloat(category.R), green: CGFloat(category.G), blue: CGFloat(category.B), alpha: 1.0)
                    //println(categoryCellColor.backgroundColor)
                    chevronRight.hidden = false
                    categoryTitle.attributedText = NSAttributedString(string: categoryTitle.text!, attributes: nil)
                }
                
            }
        }
    }
}
