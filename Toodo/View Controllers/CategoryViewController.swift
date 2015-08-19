//
//  CategoryViewController.swift
//  Toodo
//
//  Created by Reginald Suh on 2015-07-14.
//  Copyright (c) 2015 ReginaldSuh. All rights reserved.
//

import UIKit
import RealmSwift
import FontAwesomeKit
import SCLAlertView

class CategoryViewController: UIViewController {
    
    //@IBOutlet weak var editButton: UIBarButtonItem!
    @IBOutlet weak var categoryTableView: SBGestureTableView!
    @IBOutlet var addImage: UIImageView!
    @IBOutlet weak var fadedIconImage: UIImageView!
    @IBOutlet weak var displayNoCategories: UILabel!
    
    // Initialize Realm
    let realm = Realm()
    
    // Reloads the categories everytime the page loads.
    var categories: Results<Category>! {
        didSet {
            categoryTableView?.reloadData()
        }
    }
    
    // Category variable to see the taskCount
    var category: Category?
    
    var addButtonColor = ""
    //var taskCount = 0
    
    // A array for deleting
    var selectedRow: NSMutableArray = []
    
    // For adding, flag is true, for deleting, flag is false
    var flagForAddOrDelete: Bool = true
    
    var editR = 1.0
    var editB = 1.0
    var editG = 1.0
    
    // Icons
    var deleteIcon = FAKIonIcons.iosTrashIconWithSize(30)
    let editIcon = FAKIonIcons.androidCreateIconWithSize(30)
    let completeIcon = FAKIonIcons.androidDoneIconWithSize(30)
    let backToListIcon = FAKIonIcons.naviconIconWithSize(30)
    
    // Colors
    let greenColor = UIColor(red: 48.0/255, green: 220.0/255, blue: 107.0/255, alpha: 80)
    let redColor = UIColor(red: 231.0/255, green: 76.0/255, blue: 60.0/255, alpha: 100)
    let yellowColor = UIColor(red: 241.0/255, green: 196.0/255, blue: 15.0/255, alpha: 100)
    
    // Variable to removeCellBlock
    var removeCellBlock: ((SBGestureTableView, SBGestureTableViewCell) -> Void)!
    
    // Variable to replaceCell
    var replaceCell: ((SBGestureTableView, SBGestureTableViewCell) -> Void)!
    
    // Variable to fullswipcell
    var fullSwipeCell: ((SBGestureTableView, SBGestureTableViewCell) -> Void)!
    
    let categorySortDescriptors = [SortDescriptor(property: "taskCount", ascending: false), SortDescriptor(property: "categoryTitle", ascending: true)]
    
    // Sets up the icons on initialization, add all customization here
    func setupIcons() {
        // Custom white color
        deleteIcon.addAttribute(NSForegroundColorAttributeName, value: UIColor.whiteColor())
        editIcon.addAttribute(NSForegroundColorAttributeName, value: UIColor.whiteColor())
        completeIcon.addAttribute(NSForegroundColorAttributeName, value: UIColor.whiteColor())
        backToListIcon.addAttribute(NSForegroundColorAttributeName, value: UIColor.whiteColor())
    }
    
    @IBAction func backToCategoryFromAddingList(segue: UIStoryboardSegue) {
        if let identifier = segue.identifier {
            switch identifier {
            case "exitToCategoryFromAdd":
                println("exit to category from add")
                
            case "saveToCategoryFromAdd":
                println("save to category from add")
                
                let saveSourceFromAdd = segue.sourceViewController as! AddNewCategoryViewController
                realm.write() {
                    // Adds a newList
                    self.realm.add(saveSourceFromAdd.addNewCategory!)
                }
                
                // Sets the rgb value from other VC to self.VC
                //                saveSourceFromAdd.R = self.editR
                //                saveSourceFromAdd.G = self.editG
                //                saveSourceFromAdd.B = self.editB
                
                self.editR = saveSourceFromAdd.R
                self.editG = saveSourceFromAdd.G
                self.editB = saveSourceFromAdd.B
                
                println(self.editR)
                println(self.editG)
                println(self.editB)
                
            default:
                println("failed")
                
                // Sort by number of tasks, able to sort by count.
                categories = realm.objects(Category).sorted(categorySortDescriptors)
            }
        }
    }
    
    @IBAction func backToCategoryFromSettings(segue: UIStoryboardSegue) {
        if let identifier = segue.identifier {
            switch identifier {
            case "exitToCategoryFromSettings":
                println("exitToCategoryFromSettings")
                
            default:
                println("failed")
            }
        }
    }
    
    @IBAction func backToCategoryFromEdit(segue: UIStoryboardSegue) {
        if let identifier = segue.identifier {
            switch identifier {
            case "exitToCategoryFromEdit":
                println("exit to category from edit")
                
            case "saveToCategoryFromEdit":
                println("save to Category from edit")
                
                let saveSourceFromEdit = segue.sourceViewController as! EditCategoryViewController
                
            default:
                println("failed")
                
                
                // Sorts by number of tasks, able to sort by count.
                categories = realm.objects(Category).sorted(categorySortDescriptors)
            }
            
        }
    }
    
    @IBAction func backToCategoryFromTasks(segue: UIStoryboardSegue) {
        if let identifier = segue.identifier {
            switch identifier {
            case "backToCategoryFromTask":
                println("Back to Category from tasks")
                let displayTaskVC = segue.sourceViewController as! TaskViewController
                
                
                
            default:
                println("nothing")
                
                // Sorts by number of tasks, able to sort by count.
                categories = realm.objects(Category).sorted(categorySortDescriptors)
            }
            
            
        }
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if (segue.identifier == "categoryToTask") {
            let titleVC = segue.destinationViewController as! TaskViewController
            
            // Sets the category for the task to be the selectedCategory which the user pressed on the tableview.
            
            
            // Set the editedCategory as selectedCategory
            let selectedIndexPath = categoryTableView.indexPathForSelectedRow()!
            let selectedCategory = categories[selectedIndexPath.row]
            
            println(selectedCategory.taskCount)
            
            titleVC.category = selectedCategory
            //titleVC.category?.taskCount =
            
            // Sets the nav bar color to the color of whatever the cell color was in the previous VC
            // Purple Theme
            if ((selectedCategory.R == 0.81) &&
                (selectedCategory.G == 0.59) &&
                (selectedCategory.B == 0.93 )) {
                    println("Chose purple category")
                    titleVC.addButtonColor = "addPurple"
                    
            } else if ((selectedCategory.R == 0.15) &&
                (selectedCategory.G == 0.85) &&
                (selectedCategory.B == 0.70)) {
                    
                    println("Chose turquoise category")
                    titleVC.addButtonColor = "addTurquoise"
            } else if ((selectedCategory.R == 1.00) &&
                (selectedCategory.G == 0.45) &&
                (selectedCategory.B == 0.45)) {
                    
                    println("Chose red category")
                    titleVC.addButtonColor = "addRed"
            } else if ((selectedCategory.R == 0.40) &&
                (selectedCategory.G == 0.60) &&
                (selectedCategory.B == 1.00)) {
                    
                    println("chose blue category")
                    titleVC.addButtonColor = "addBlue"
            }
            
            // Sets the category title in the next VC to be the selected category's title
            if (selectedCategory.categoryTitle != "") {
                titleVC.categoryTitleForNavBar = selectedCategory.categoryTitle
            } else if (selectedCategory.categoryTitle == "") {
                titleVC.categoryTitleForNavBar = ""
            }
        } else if (segue.identifier == "addCategory") {
            let targetVC = segue.destinationViewController as! AddNewCategoryViewController
            
            targetVC.addButtonColor = self.addButtonColor
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        for fontFamilyName in UIFont.familyNames() {
            println("-- \(fontFamilyName) --")
            
            for fontName in UIFont.fontNamesForFamilyName(fontFamilyName as! String) {
                //println(fontName)
            }
            
            println(" ")
        }
        
        // self.categoryTableView.reloadData()
        println("tableview reloadeD")
        
        fadedIconImage.hidden = true
        displayNoCategories.hidden = true
        
        self.navigationController?.navigationBar.translucent = false
        
        // Disables the interaction with the image so that the image is basically transparent
        addImage.userInteractionEnabled = false
        
        // Intializes the add button
        addImage.image = UIImage(named: "addButtonWhite")
        
        categoryTableView.delegate = self
        categoryTableView.dataSource = self
        
        // Calls setupIcons method
        setupIcons()
        
        // The fullSwipeCell function
        fullSwipeCell = {(tableView: SBGestureTableView, cell: SBGestureTableViewCell) -> Void in
            
            // Sets the indexpath
            var indexPath = tableView.indexPathForCell(cell)
            
            // Create a category to delete, before the animation is run
            let category = self.categories[indexPath!.row] as Category
            
            println(category.tasksWithinCategory.count)
            
            //            // If the taskCount is 3 or larger
            if (category.tasksWithinCategory.count >= 1) {
                
                tableView.fullSwipeCell(cell, duration: 0.3, completion: nil)
                
                // Show a popup alert!
                let popUpAlertView = SCLAlertView()
                
                // The delete button
                popUpAlertView.addButton("Delete") {
                    println("Delete has been tapped")
                    // Deletes the category
                    self.realm.write() {
                        self.realm.delete(category)
                    }
                    
                    // Closes the alertView
                    popUpAlertView.close()
                    
                    // The animation to remove the Cell
                    tableView.removeCell(cell, duration: 0.2, completion: nil)
                }
                
                // The cancel button
                popUpAlertView.addButton("Cancel") {
                    println("Cancel has been tapped")
                    
                    // Closes the alertView
                    popUpAlertView.close()
                    
                    // The animation to replace the cell
                    tableView.replaceCell(cell, duration: 0.2, bounce: 0.2, completion: nil)
                }
                
                popUpAlertView.showWarning("Are you sure?", subTitle: "This will delete the list and all its tasks")
                
                
            } else {
                
                self.realm.write() {
                    self.realm.delete(category)
                    
                    tableView.removeCell(cell, duration: 0.3, completion: {
                        self.categories = self.realm.objects(Category).sorted(self.categorySortDescriptors)
                        //                        self.categories = self.realm.objects(Category).sorted("categoryTitle", ascending: true).sorted("taskCount", ascending: false)
                    })
                    
                }
                
                // The original animation before the alert is displayed
                tableView.fullSwipeCell(cell, duration: 0.3, completion: nil)
            }
        }
        
        // The replace cell function
        replaceCell = {(tableView: SBGestureTableView, cell: SBGestureTableViewCell) -> Void in
            
            let indexPath = tableView.indexPathForCell(cell)
            
            let selectedCategory = self.categories[indexPath!.row]
            //cell.backgroundColor = UIColor.lightGrayColor()
            //cell.tintColor = UIColor.lightGrayColor()
            tableView.replaceCell(cell, duration: 0.3, bounce: 0.2, completion: nil)
            
            let size = CGSizeMake(30, 30)
            
            if let cell = cell as? CategoryTableViewCell {
                
                if selectedCategory.complete == true {
                    
                    
                    cell.categoryTitle.attributedText = NSAttributedString(string: cell.categoryTitle.text!, attributes: nil)
                    
                    //cell.backgroundColor = UIColor(red:0.11, green:0.78, blue:0.35, alpha:1.0)
                    
                    cell.firstLeftAction = SBGestureTableViewCellAction(icon: self.completeIcon.imageWithSize(size), color: self.greenColor, fraction: 0, didTriggerBlock: self.replaceCell)
                    
                    cell.chevronRight.hidden = false
                    
                    println("turning nothing to completed")
                    self.realm.write() {
                        selectedCategory.complete = false
                        //                        selectedCategory.R = self.editR
                        //                        selectedCategory.G = self.editG
                        //                        selectedCategory.B = self.editB
                    }
                    println(selectedCategory.R)
                    println(selectedCategory.G)
                    println(selectedCategory.B)
                    
                    
                } else if (selectedCategory.complete == false){
                    
                    // Does the strikethrough of the text
                    let attributes = [NSStrikethroughStyleAttributeName: NSUnderlineStyle.StyleSingle.rawValue]
                    cell.categoryTitle.attributedText = NSAttributedString(string: cell.categoryTitle.text!, attributes: attributes)
                    
                    //cell.backgroundColor = UIColor(red: CGFloat(selectedCategory.R), green: CGFloat(selectedCategory.G), blue: CGFloat(selectedCategory.B), alpha: 1.0)
                    
                    cell.firstLeftAction = SBGestureTableViewCellAction(icon: self.backToListIcon.imageWithSize(size), color: self.yellowColor, fraction: 0, didTriggerBlock: self.replaceCell)
                    
                    cell.chevronRight.hidden = true
                    
                    println("turning from completed to nothing")
                    
                    self.realm.write() {
                        selectedCategory.complete = true
                        
                        //                        selectedCategory.R = 0.11
                        //                        selectedCategory.G = 0.78
                        //                        selectedCategory.B = 0.35
                        
                    }
                    
                    //cell.backgroundColor = UIColor(red: CGFloat(selectedCategory.R), green: CGFloat(selectedCategory.G), blue: CGFloat(selectedCategory.B), alpha: 1.0)
                    println(selectedCategory.R)
                    println(selectedCategory.G)
                    println(selectedCategory.B)
                    
                    println("Should be default colors")
                }
                
                
                
            }
            
            
        }
        
        // The remove block function
        removeCellBlock = {(tableView: SBGestureTableView, cell: SBGestureTableViewCell) -> Void in
            println("remove run")
            // indexPath = int, sets up indexPath
            let indexPath = tableView.indexPathForCell(cell)
            
            // let category = the category object at indexPath.row AS AN OBJECT
            let category = self.categories[indexPath!.row] as Category
            
            // Pass the object we just created to delete
            self.realm.write() {
                self.realm.delete(category)
                
                // The animation to delete (manditory/ needed)
                tableView.removeCell(cell, duration: 0.3, completion: nil)
                
                // To prevent the duplication
                //            tableView.reloadData()
            }
            
            
        }
        
        // Sets up the lists cells by the modificationDate
        categories = realm.objects(Category).sorted(categorySortDescriptors)
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        //println(self.category.taskCount)
        
        // Sorts the realm objects by taskCount
        categories = realm.objects(Category).sorted(categorySortDescriptors)
        
        // Changes Nav bar color to dark Theme
        var navigation = self.navigationController?.navigationBar
        navigation?.barTintColor = UIColor(red:0.23, green:0.26, blue:0.33, alpha:1.0)
        
        // Changes the title of the navbar
        let font = UIFont(name: "Avenir-Medium", size: 20)
        navigation?.titleTextAttributes = [NSFontAttributeName: font!, NSForegroundColorAttributeName: UIColor.whiteColor()]
        //UINavigationBar.appearance().titleTextAttributes = [NSFontAttributeName: font, NSForegroundColorAttributeName: UIColor.whiteColor()]
        
    }
    
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)
        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
}

extension CategoryViewController: UITableViewDataSource {
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
        // Initialize cell
        let cell = categoryTableView.dequeueReusableCellWithIdentifier("categoryCell", forIndexPath: indexPath) as! CategoryTableViewCell
        let completedCategory = self.categories[indexPath.row]
        
        println(completedCategory.taskCount)
        
        //        let categoryForCount = self.categories[indexPath.row]
        //
        //        println("HELLOOOO")
        
        // Shows the onboarding image, etc
        //        if (categoryForCount.tasksWithinCategory.count == 0) {
        //            displayNoCategories.hidden = false
        //            fadedIconImage.hidden = false
        //            println("labels and stuff should be shown")
        //        } else {
        //            displayNoCategories.hidden = true
        //            fadedIconImage.hidden = true
        //            println("labels are hidden")
        //        }
        
        let size = CGSizeMake(30, 30)
        
        //if completedCategory.complete == true {
        
        //cell.firstLeftAction = SBGestureTableViewCellAction(icon: backToListIcon.imageWithSize(size), color: yellowColor, fraction: 0, didTriggerBlock: replaceCell)
        //cell.firstLeftAction = SBGestureTableViewCellAction(icon: deleteIcon.imageWithSize(size), color: redColor, fraction: 0, didTriggerBlock: fullSwipeCell)
        cell.firstRightAction = SBGestureTableViewCellAction(icon: deleteIcon.imageWithSize(size), color: redColor, fraction: 0, didTriggerBlock: fullSwipeCell)
        
        
        //} else {
        
        //            cell.firstRightAction = SBGestureTableViewCellAction(icon: deleteIcon.imageWithSize(size), color: redColor, fraction: 0.3, didTriggerBlock: fullSwipeCell)
        //            cell.firstLeftAction = SBGestureTableViewCellAction(icon: completeIcon.imageWithSize(size), color: greenColor, fraction: 0, didTriggerBlock: replaceCell)
        
        
        
        
        // Sorts by number of tasks, able to sort by count.
        //categories = realm.objects(Category).sorted("taskCount", ascending: false)
        
        // Set up cell
        let row = indexPath.row
        let category = categories[row] as Category
        cell.category = category
        
        return cell
    }
    
    // How many rows are in the tableView
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        //println(categories!.count)
        if (categories!.count == 0) {
            
            displayNoCategories.hidden = false
            fadedIconImage.hidden = false
        } else {
            
            displayNoCategories.hidden = true
            fadedIconImage.hidden = true
            
        }
        return Int(categories?.count ?? 0)
        
    }
    
    func tableView(tableView: UITableView, willDisplayCell cell: UITableViewCell, forRowAtIndexPath indexPath: NSIndexPath) {
        cell.separatorInset = UIEdgeInsetsZero
    }
}


extension CategoryViewController: UITableViewDelegate {
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        
        // Performs a segue "categoryToTask"
        self.performSegueWithIdentifier("categoryToTask", sender: self)
        
        
        // Deselects the row when they were tapped
        categoryTableView.deselectRowAtIndexPath(indexPath, animated: true)
    }
    
    func tableView(tableView: UITableView, canMoveRowAtIndexPath indexPath: NSIndexPath) -> Bool {
        return true
    }
}