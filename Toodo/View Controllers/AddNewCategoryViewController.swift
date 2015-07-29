//
//  AddNewCategoryViewController.swift
//  Toodo
//
//  Created by Reginald Suh on 2015-07-10.
//  Copyright (c) 2015 ReginaldSuh. All rights reserved.
//

import UIKit
import RealmSwift

class AddNewCategoryViewController: UIViewController {
    
    @IBOutlet weak var purpleTheme: UIButton!
    @IBOutlet weak var turquoiseTheme: UIButton!
    @IBOutlet weak var categoryTitle: UITextField!
    
    var colorString: String = ""
    
    var addNewCategory: Category? {
        didSet {
            displayNewCategory(addNewCategory)
            displayCellColor(addNewCategory)
        }
    }
    
    // Displays the new Category
    func displayNewCategory(category: Category?) {
        if let category = category, categoryTitle = categoryTitle {
            addNewCategory!.categoryTitle = category.categoryTitle
        }
    }
    
    // Displays the badge Color
    func displayCellColor(category: Category?) {
        if let category = category {
            // Sets the newly added category's imageName to be equal to category.imageName
            addNewCategory!.imageName = category.imageName
        }
    }
    
    // Saves the task
    func saveCategory() {
        if let addNewCategory = addNewCategory {
            let realm = Realm()
            realm.write() {
                if ((addNewCategory.categoryTitle != self.categoryTitle.text) ||
                    (addNewCategory.imageName != self.colorString)) {
                        addNewCategory.categoryTitle = self.categoryTitle.text
                        
                        // Sets the new category's imageName to be the string to colorString
                        addNewCategory.imageName = self.colorString
                        println("changes are saved")
                } else {
                    println("nothing to save")
                }
            }
        }
    }
    
    @IBAction func tapPurpleTheme(sender: AnyObject) {
        println("tapped purple")
        colorString = "rectanglePurple"
    }
    
    @IBAction func tapTurquoiseTheme(sender: AnyObject) {
        println("tapped turquoise")
        colorString = "rectangleTurqoise"
    }
    
    // Passing category object to Home View Controller
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        let realm = Realm()
        addNewCategory = Category()
        //println(addNewCategory!.tasksWithinCategory)
        //addNewCategory?.tasksWithinCategory =
        println("category object is created")
        saveCategory()
        println(addNewCategory!.imageName)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Placeholder text for textfield in Add
        categoryTitle.placeholder = "Title of your Category..."
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
}
