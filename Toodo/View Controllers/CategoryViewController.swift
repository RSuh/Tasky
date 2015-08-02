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
    @IBOutlet var buttonImage: UIImageView!
    
    // Initialize Realm
    let realm = Realm()
    
    // Reloads the categories everytime the page loads.
    var categories: Results<Category>! {
        didSet {
            categoryTableView?.reloadData()
        }
    }
    
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
    
    // Sets up the icons on initialization, add all customization here
    func setupIcons() {
        // Custom white color
        deleteIcon.addAttribute(NSForegroundColorAttributeName, value: UIColor.whiteColor())
        editIcon.addAttribute(NSForegroundColorAttributeName, value: UIColor.whiteColor())
        completeIcon.addAttribute(NSForegroundColorAttributeName, value: UIColor.whiteColor())
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
                    println(saveSourceFromAdd.R)
                    println(saveSourceFromAdd.G)
                    println(saveSourceFromAdd.B)
                }
                
                
                // Sets the rgb value from other VC to self.VC
                saveSourceFromAdd.R = self.editR
                saveSourceFromAdd.G = self.editG
                saveSourceFromAdd.B = self.editB
                
            default:
                println("failed")
                
                // Sort by number of tasks, able to sort by count.
                categories = realm.objects(Category).sorted("taskCount", ascending: false)
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
                categories = realm.objects(Category).sorted("taskCount", ascending: false)
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
            
            titleVC.category = selectedCategory
            
            // Sets the nav bar color to the color of whatever the cell color was in the previous VC
            // Purple Theme
            if ((selectedCategory.R == 0.81) &&
                (selectedCategory.G == 0.59) &&
                (selectedCategory.B == 0.93 )) {
                    println("Chose purple category")
                    titleVC.addButtonColor = "addPurple"
                    
                    // TODO: Change navbar color
                    
                    //titleVC.navbarColor =
                    //navigation?.barTintColor = UIColor(red: 48/255, green: 220/255, blue: 107/255, alpha: 80)
            }
            
            // Sets the category title in the next VC to be the selected category's title
            if (selectedCategory.categoryTitle != "") {
                titleVC.categoryTitleForNavBar = selectedCategory.categoryTitle
            } else if (selectedCategory.categoryTitle == "") {
                titleVC.categoryTitleForNavBar = ""
            }
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //self.navigationController?.navigationBar = UIColor.whiteColor()
        
        // Disables the interaction with the image so that the image is basically transparent
        buttonImage.userInteractionEnabled = false
        
        // Intializes the add button
        buttonImage.image = UIImage(named: "addButton")
        
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
            
            // If the taskCount is 3 or larger
            if (category.tasksWithinCategory.count >= 3) {
                
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
                }
                
                tableView.removeCell(cell, duration: 0.3, completion: nil)
            }
            
            // The original animation before the alert is displayed
            tableView.fullSwipeCell(cell, duration: 0.3, completion: nil)
        }
        
        // The replace cell function
        replaceCell = {(tableView: SBGestureTableView, cell: SBGestureTableViewCell) -> Void in
            
            let indexPath = tableView.indexPathForCell(cell)
            cell.backgroundColor = UIColor.lightGrayColor()
            
            tableView.replaceCell(cell, duration: 0.3, bounce: 0.2, completion: nil)
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
            }
            
            // The animation to delete (manditory/ needed)
            tableView.removeCell(cell, duration: 0.3, completion: nil)
        }
        
        // Sets up the lists cells by the modificationDate
        categories = realm.objects(Category).sorted("taskCount", ascending: false)
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        
        // Sorts the realm objects by taskCount
        categories = realm.objects(Category).sorted("taskCount", ascending: false)
    }
    
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)
        
        // Changes Nav bar color to green theme
        //var navigation = self.navigationController?.navigationBar
        //navigation?.barTintColor = UIColor(red: 48/255, green: 220/255, blue: 107/255, alpha: 80)
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
        
        let size = CGSizeMake(30, 30)
        
        cell.firstRightAction = SBGestureTableViewCellAction(icon: deleteIcon.imageWithSize(size), color: redColor, fraction: 0.3, didTriggerBlock: fullSwipeCell)
        
        cell.firstLeftAction = SBGestureTableViewCellAction(icon: completeIcon.imageWithSize(size), color: greenColor, fraction: 0.3, didTriggerBlock: removeCellBlock)
        
        // Set up cell
        let row = indexPath.row
        let category = categories[row] as Category
        cell.category = category
        
        // Sets custom separators between cells on viewDidLoad
        //        categoryTableView.separatorInset = UIEdgeInsetsZero
        //        categoryTableView.layoutMargins = UIEdgeInsetsZero
        
        //cell.accessoryView?.tintColor = UIColor.blackColor()
        // Custom separator lines between cells
        //cell.layoutMargins = UIEdgeInsetsZero
        
        return cell
    }
    
    // How many rows are in the tableView
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
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