//
//  AddNewCategoryViewController.swift
//  Toodo
//
//  Created by Reginald Suh on 2015-07-10.
//  Copyright (c) 2015 ReginaldSuh. All rights reserved.
//

import UIKit
import RealmSwift

class AddNewCategoryViewController: UIViewController, UITextFieldDelegate {
    
    @IBOutlet weak var purpleTheme: UIButton!
    @IBOutlet weak var turquoiseTheme: UIButton!
    @IBOutlet weak var categoryTitle: UITextField!
    
    var themeColor: UIColor = UIColor.whiteColor()
    var R: Double = 1.0
    var G: Double = 1.0
    var B: Double = 1.0
    
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
            addNewCategory?.R = R
            addNewCategory?.G = G
            addNewCategory?.B = B
        }
    }
    
    // Saves the task
    func saveCategory() {
        if let addNewCategory = addNewCategory {
            let realm = Realm()
            realm.write() {
                if (addNewCategory.categoryTitle != self.categoryTitle.text) {
                    addNewCategory.categoryTitle = self.categoryTitle.text
                    
                    // Sets the new category's imageName to be the string to colorString
                    addNewCategory.R = self.R
                    addNewCategory.G = self.G
                    addNewCategory.B = self.B
                    println("changes are saved")
                } else {
                    println("nothing to save")
                }
            }
        }
    }
    
    @IBAction func tapPurpleTheme(sender: AnyObject) {
        println("tapped purple")
        themeColor = UIColor(red:0.81, green:0.59, blue:0.93, alpha:1.0)
        R = 0.81
        G = 0.59
        B = 0.93
        println("\(R)\(G)\(B)")
    }
    
    @IBAction func tapTurquoiseTheme(sender: AnyObject) {
        println("tapped turquoise")
        themeColor = UIColor(red:0.15, green:0.85, blue:0.70, alpha:1.0)
        R = 0.15
        G = 0.85
        B = 0.70
        println("\(R)\(G)\(B)")
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
        
        purpleTheme.backgroundColor = UIColor(red:0.81, green:0.59, blue:0.93, alpha:1.0)
        purpleTheme.layer.cornerRadius = 11
        
        turquoiseTheme.backgroundColor = UIColor(red:0.15, green:0.85, blue:0.70, alpha:1.0)
        turquoiseTheme.layer.cornerRadius = 11
        
        categoryTitle.delegate = self
        categoryTitle.returnKeyType = UIReturnKeyType.Done
        
    }
    
    override func viewDidAppear(animated: Bool) {
        categoryTitle.becomeFirstResponder()
    }
    
    //Called when 'return' key pressed. return NO to ignore.
    func textFieldShouldReturn(textField: UITextField) -> Bool {
        categoryTitle.resignFirstResponder()
        return true
    }
    
    // Hides keyboard whenever you tap outside the keyboard
    override func touchesBegan(touches: Set<NSObject>, withEvent event: UIEvent) {
        self.view.endEditing(true)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
}

