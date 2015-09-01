//
//  AddNewCategoryViewController.swift
//  Toodo
//
//  Created by Reginald Suh on 2015-07-10.
//  Copyright (c) 2015 ReginaldSuh. All rights reserved.
//

import UIKit
import RealmSwift
import SCLAlertView

class AddNewCategoryViewController: UIViewController, UITextFieldDelegate, UICollectionViewDataSource, UICollectionViewDelegate {
    
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
    
    var addButtonColor = ""
    
    var colorIndex = 0
    
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
    
    func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return arrayConstants.colorImagesUnselected.count
        
    }
    
    func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCellWithReuseIdentifier("colorCell", forIndexPath: indexPath) as! ColorCollectionViewCell
        cell.colorPickerCell.image = UIImage(named: arrayConstants.colorImagesUnselected[indexPath.row])
        
        // If indexpath is 0
        if(indexPath.row==0) {
            
            println("You have selected cell \(indexPath.row)")
            
            cell.selected = true
            
            colorIndex = indexPath.row
            
            cell.colorPickerCell.image = UIImage(named: arrayConstants.colorImagesSelected[0])
            //println(colorIndex)
            
            //            if (colorIndex == 0) {
            //                themeColor = UIColor(red:1.00, green:1.00, blue:1.00, alpha:1.00)
            //                R = 1.00
            //                G = 1.00
            //                B = 1.00
            //                println("\(R)\(G)\(B)")
            
            if (colorIndex == 0) {
                themeColor = UIColor(red:0.81, green:0.59, blue:0.93, alpha:1.0)
                R = 0.81
                G = 0.59
                B = 0.93
                //println("\(R)\(G)\(B)")
                
            } else if (colorIndex == 1) {
                themeColor = UIColor(red:0.15, green:0.85, blue:0.70, alpha:1.0)
                R = 0.15
                G = 0.85
                B = 0.70
                //println("\(R)\(G)\(B)")
                
            } else if (colorIndex == 2) {
                themeColor = UIColor(red:1.00, green:0.45, blue:0.45, alpha:1.0)
                R = 1.00
                G = 0.45
                B = 0.45
                //println("\(R)\(G)\(B)")
                
            } else if (colorIndex == 3) {
                themeColor = UIColor(red:0.40, green:0.60, blue:1.00, alpha:1.0)
                R = 0.40
                G = 0.60
                B = 1.00
                //println("\(R)\(G)\(B)")
                
            }
            
        }
        return cell
    }
    
    func collectionView(collectionView: UICollectionView, didSelectItemAtIndexPath indexPath: NSIndexPath) {
        println("You have selected cell \(indexPath.row)")
        colorIndex = indexPath.row
        let cell = collectionView.cellForItemAtIndexPath(indexPath) as! ColorCollectionViewCell
        if (colorIndex > 0) {
            // Sets index path for cell 0
            let ip = NSIndexPath(forRow: 0, inSection: 0)
            
            // Sets image at collectionCell 0
            (collectionView.cellForItemAtIndexPath(ip) as! ColorCollectionViewCell).colorPickerCell.image = UIImage(named: arrayConstants.colorImagesUnselected[0])
        }
        
        //        if (colorIndex == 0) {
        //            themeColor = UIColor(red:1.00, green:1.00, blue:1.00, alpha:1.00)
        //            R = 1.00
        //            G = 1.00
        //            B = 1.00
        //            println("\(R)\(G)\(B)")
        
        if (colorIndex == 0) {
            themeColor = UIColor(red:0.81, green:0.59, blue:0.93, alpha:1.0)
            R = 0.81
            G = 0.59
            B = 0.93
            //println("\(R)\(G)\(B)")
        } else if (colorIndex == 1) {
            themeColor = UIColor(red:0.15, green:0.85, blue:0.70, alpha:1.0)
            R = 0.15
            G = 0.85
            B = 0.70
            //println("\(R)\(G)\(B)")
            
        } else if (colorIndex == 2) {
            themeColor = UIColor(red:1.00, green:0.45, blue:0.45, alpha:1.0)
            R = 1.00
            G = 0.45
            B = 0.45
            //println("\(R)\(G)\(B)")
            
        } else if (colorIndex == 3) {
            themeColor = UIColor(red:0.40, green:0.60, blue:1.00, alpha:1.0)
            R = 0.40
            G = 0.60
            B = 1.00
            //println("\(R)\(G)\(B)")
            
        }
        
        cell.colorPickerCell.image = UIImage(named: arrayConstants.colorImagesSelected[indexPath.row])
        
        
        //println(colorIndex)
        
    }
    
    func collectionView(collectionView: UICollectionView, didDeselectItemAtIndexPath indexPath: NSIndexPath) {
        let cell = collectionView.cellForItemAtIndexPath(indexPath) as! ColorCollectionViewCell
        
        cell.colorPickerCell.image = UIImage(named: arrayConstants.colorImagesUnselected[indexPath.row])
    }
    
    override func shouldPerformSegueWithIdentifier(identifier: String?, sender: AnyObject?) -> Bool {
        if identifier == "saveToCategoryFromAdd" {
            
            categoryTitle.resignFirstResponder()
            
            if (categoryTitle.text.isEmpty) {
                
                // Show a popup alert!
                let emptyTextFieldAlertView = SCLAlertView()
                
                // The ok button
                emptyTextFieldAlertView.addButton("Ok") {
                    
                    // Closes the alertView
                    emptyTextFieldAlertView.close()
                    
                    self.categoryTitle.becomeFirstResponder()
                }
                
                // This is what the type of popup the alert will show
                emptyTextFieldAlertView.showError("No Text", subTitle: "Please Enter Text In The Field")
                
                return false
            }
                
            else {
                return true
            }
        }
        
        // by default, transition
        return true
    }
    
    // Passing category object to Home View Controller
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        //let realm = Realm()
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
        
        
        
        categoryTitle.delegate = self
        categoryTitle.returnKeyType = UIReturnKeyType.Done
        //
        //        if (self.categoryTitle.text.isEmpty) {
        //            println("text is empty")
        //        } else {
        //            println("its not empty")
        //        }
        
        // Initialize the bar button items
        let leftNavigation = self.navigationItem.leftBarButtonItem
        let rightNavigation = self.navigationItem.rightBarButtonItem
        
        if (addButtonColor == "") {
            leftNavigation?.tintColor = UIColor.whiteColor()
            rightNavigation?.tintColor = UIColor.whiteColor()
        }
        
    }
    
    override func viewWillAppear(animated: Bool) {
        categoryTitle.becomeFirstResponder()
    }
    
    //Called when 'return' key pressed. return NO to ignore.
    func textFieldShouldReturn(textField: UITextField) -> Bool {
        
        categoryTitle.resignFirstResponder()
        
        if (categoryTitle.text.isEmpty) {
            
            // Show a popup alert!
            let emptyTextFieldAlertView = SCLAlertView()
            
            // The ok button
            emptyTextFieldAlertView.addButton("Ok") {
                
                // Closes the alertView
                emptyTextFieldAlertView.close()
                
                self.categoryTitle.becomeFirstResponder()
            }
            
            // This is what the type of popup the alert will show
            emptyTextFieldAlertView.showError("No Text", subTitle: "Please Enter Text In The Field")
        } else {
            
            performSegueWithIdentifier("saveToCategoryFromAdd", sender: self)
            
            // Creates a new category
            //let realm = Realm()
            addNewCategory = Category()
            //println(addNewCategory!.tasksWithinCategory)
            //addNewCategory?.tasksWithinCategory =
            println("category object is created")
            saveCategory()
        }
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

