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
    
    var addNewCategory: Category? {
        didSet {
            displayNewCategory(addNewCategory)
        }
    }
    
    func displayNewCategory(category: Category?) {
        if let category = category, categoryTitle = categoryTitle {
            addNewCategory!.categoryTitle = category.categoryTitle
        }
    }
    
    // Saves the task
    func saveCategory() {
        if let addNewCategory = addNewCategory {
            let realm = Realm()
            realm.write() {
                if (addNewCategory.categoryTitle != self.categoryTitle.text) {
                    addNewCategory.categoryTitle = self.categoryTitle.text
                    println("changes are saved")
                } else {
                    println("nothing to save")
                }
            }
        }
    }
    
    @IBAction func tapPurpleTheme(sender: AnyObject) {
        println("tapped purple")
    }
    
    @IBAction func tapTurquoiseTheme(sender: AnyObject) {
        println("tapped turquoise")
    }
    
    // Passing category object to Home View Controller
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        let realm = Realm()
        addNewCategory = Category()
        //println(addNewCategory!.tasksWithinCategory)
        //addNewCategory?.tasksWithinCategory =
        println("category object is created")
        saveCategory()
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
