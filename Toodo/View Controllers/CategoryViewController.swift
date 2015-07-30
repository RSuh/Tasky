//
//  CategoryViewController.swift
//  Toodo
//
//  Created by Reginald Suh on 2015-07-14.
//  Copyright (c) 2015 ReginaldSuh. All rights reserved.
//

import UIKit
import RealmSwift

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
    
    var editR = 0.0
    var editB = 0.0
    var editG = 0.0
    
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
    
    // A var of type category which indicates the selectedList
//    var selectedCategory: Category?
    
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
    
    @IBAction func addOrDeleteButton(sender: AnyObject) {
        if (flagForAddOrDelete == false) {
            
            realm.write() {
                // Goes through each row and deletes all the selected ones
                for (var index = 0; index <= self.selectedRow.count - 1; index++) {
                    // TODO: Get rows to animate and delete 1 by 1.
                    //self.categoryTableView.deleteRowsAtIndexPaths(<#indexPaths: [AnyObject]#>, withRowAnimation: <#UITableViewRowAnimation#>)
                    self.realm.delete(self.selectedRow[index] as! Object)
                }
            }
            
            println("item successfully deleted")
            
            // Updates categories in real time when we delete, so that they disappear immediately.
            categories = realm.objects(Category).sorted("taskCount", ascending: false)
        } else {
            
            // Segues to addVC
            performSegueWithIdentifier("addCategory", sender: sender)
            println("segue has been performed")
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
    
    override func setEditing(editing: Bool, animated: Bool) {
        super.setEditing(editing, animated: animated)
        
        // Sets edit mode for the tableview
        self.categoryTableView.setEditing(editing, animated: true)
        if (editing == true) {
            let toImage = UIImage(named: "Garbage")
            UIView.transitionWithView(self.buttonImage,
                duration: 0.35,
                options: UIViewAnimationOptions.TransitionFlipFromBottom,
                animations: { self.buttonImage.image = toImage },
                completion: nil)
            flagForAddOrDelete = false
            println(flagForAddOrDelete)
        } else if (editing == false) {
            let backImage = UIImage(named: "addButton")
            UIView.transitionWithView(self.buttonImage,
                duration: 0.35,
                options: UIViewAnimationOptions.TransitionFlipFromTop,
                animations: { self.buttonImage.image = backImage },
                completion: nil)
            flagForAddOrDelete = true
            println(flagForAddOrDelete)
        }
        
        // Reloads the data for the tableView for cellforrowatindexpath function so enabling the edit can be turned off and on
        self.categoryTableView.reloadData()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Disables the interaction with the image so that the image is basically transparent
        buttonImage.userInteractionEnabled = false
        
        // Intializes the add button
        buttonImage.image = UIImage(named: "addButton")
        
        // Sets the multiple editing feature
        self.categoryTableView.allowsMultipleSelectionDuringEditing = true
        self.navigationItem.rightBarButtonItem = self.editButtonItem()
        self.navigationItem.rightBarButtonItem?.tintColor = UIColor.blackColor()
        
        categoryTableView.delegate = self
        categoryTableView.dataSource = self
        
        // Calls setupIcons method
        setupIcons()
        
        // The replace cell function
        replaceCell = {(tableView: SBGestureTableView, cell: SBGestureTableViewCell) -> Void in
            
            let indexPath = tableView.indexPathForCell(cell)
//            self.selectedCategory = self.categories[indexPath!.row]
            cell.backgroundColor = UIColor.lightGrayColor()
            
            tableView.replaceCell(cell, duration: 0.3, bounce: 0.2, completion: nil)
        }
        
        // The remove block function
        removeCellBlock = {(tableView: SBGestureTableView, cell: SBGestureTableViewCell) -> Void in
            
            // indexPath = int, sets up indexPath
            let indexPath = tableView.indexPathForCell(cell)
            
            // let category = the category object at indexPath.row AS AN OBJECT
            let category = self.categories[indexPath!.row] as Object
            
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
        var navigation = self.navigationController?.navigationBar
        navigation?.barTintColor = UIColor(red: 48/255, green: 220/255, blue: 107/255, alpha: 80)
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
        
        //        categoryTableView.backgroundColor = UIColor.lightGrayColor()
        //        cell.backgroundColor = UIColor.lightGrayColor()
        
//        if (cell.backgroundView == nil) {
//            cell.backgroundView = UIView()
//            println("cell.backgroundView is nil")
//        }
//    
//        cell.backgroundView?.backgroundColor = UIColor.redColor()
//    
        //cell.backgroundView?.backgroundColor = UIColor(red: CGFloat(editR), green: CGFloat(editG), blue: CGFloat(editB), alpha: 1.0)
        
        let size = CGSizeMake(30, 30)
        
        // If editing is on, dont let the user swipe to delete or complete tasks. Vice Versa.
        if (editing == false) {
            cell.firstRightAction = SBGestureTableViewCellAction(icon: deleteIcon.imageWithSize(size), color: redColor, fraction: 0.3, didTriggerBlock: removeCellBlock)
            cell.firstLeftAction = SBGestureTableViewCellAction(icon: completeIcon.imageWithSize(size), color: greenColor, fraction: 0.3, didTriggerBlock: removeCellBlock)
            
            // A bool to see if the editing is enabled
            categoryTableView.isEnabled = true
        } else if (editing == true) {
            
            // A bool to see if the editing is enabled
            categoryTableView.isEnabled = false
        }
        
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
        
        // Sets the selectedCategory to be the category at indexPath.row
        let selectedCategory = categories[indexPath.row]
        println("hi")
        if (editing == true) {
            // If its in the selectedRow array, then remove, else add. Fixes problem with overlapping objects in the array
            if (selectedRow.containsObject(selectedCategory)) {
                println("It's in the array already!")
                selectedRow.removeObject(selectedCategory)
            } else {
                // Use a "set"
                selectedRow.addObject(selectedCategory)
                println("Its not in the array")
//                println(selectedRow)
            }
        } else {
            // Performs a segue "categoryToTask"
            self.performSegueWithIdentifier("categoryToTask", sender: self)
            
            // Deselects the row when they were tapped
            categoryTableView.deselectRowAtIndexPath(indexPath, animated: true)
        }
    }
    
    func tableView(tableView: UITableView, canMoveRowAtIndexPath indexPath: NSIndexPath) -> Bool {
        return true
    }
}

