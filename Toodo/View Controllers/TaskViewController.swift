//
//  ViewController.swift
//  Toodo
//
//  Created by Reginald Suh on 2015-07-10.
//  Copyright (c) 2015 ReginaldSuh. All rights reserved.
//

import UIKit
import RealmSwift
import FontAwesomeKit
import SCLAlertView

class TaskViewController: UIViewController {
    
    // REMEMBER TO CONNECT THE OUTLET IN STORYBOARD
    @IBOutlet weak var taskHomeTableView: SBGestureTableView!
    @IBOutlet weak var addImage: UIImageView!
    @IBOutlet weak var taskStreakNum: UILabel!
    @IBOutlet weak var addBackgroundButton: UIButton!
    @IBOutlet weak var fadedIconImage: UIImageView!
    @IBOutlet weak var noTaskLabel: UILabel!
    @IBOutlet weak var smileyImage: UIImageView!
    
    // The variable for the navbar color of this view controller. We need this variable to transfer the color from the previous VC using a segue
    var navbarColor: UIColor = UIColor(red: 0/255, green: 0/255, blue: 0/255, alpha: 0)
    
    // Initialize Realm
    let realm = Realm()
    
    // Variable category of type Category for separating the tasks
    var category : Category?
    
    // Updates tableView whenever tasks update
    var tasks: Results<Task>! {
        didSet {
            taskHomeTableView?.reloadData()
        }
    }
    
    var toImage: UIImage?
    var addButtonColor: String = ""
    var deleteAlreadyPressed: Bool = false
    var orderingDate: NSDate?
    
    // Icons
    var deleteIcon = FAKIonIcons.iosTrashIconWithSize(30)
    let editIcon = FAKIonIcons.androidCreateIconWithSize(30)
    let completeIcon = FAKIonIcons.androidDoneIconWithSize(30)
    
    // A array for deleting
    var selectedRows = [Task]()
    
    // For adding, flag is true, for deleting, flag is false
    var flagForAddOrDelete: Bool = true
    
    // Colors
    let greenColor = UIColor(red: 48.0/255, green: 220.0/255, blue: 107.0/255, alpha: 80)
    //let redColor = UIColor(red: 231.0/255, green: 76.0/255, blue: 60.0/255, alpha: 100)
    let yellowColor = UIColor(red: 241.0/255, green: 196.0/255, blue: 15.0/255, alpha: 100)
    let purpleColor = UIColor(red: 0.81, green: 0.59, blue: 0.93, alpha: 1.0)
    let turquoiseColor = UIColor(red: 0.15, green: 0.85, blue: 0.70, alpha: 1.0)
    let redColor = UIColor(red:1.00, green:0.45, blue:0.45, alpha:1.0)
    let blueColor = UIColor(red:0.40, green:0.60, blue:1.00, alpha:1.0)
    let darkColor = UIColor(red:0.23, green:0.26, blue:0.33, alpha:1.0)
    
    // Variable to removeCellBlock
    var removeCellBlock: ((SBGestureTableView, SBGestureTableViewCell) -> Void)!
    // Variable to replaceCell
    var replaceCell: ((SBGestureTableView, SBGestureTableViewCell) -> Void)!
    
    // The task which is currently selected
    //    var selectedTask: Task?
    
    // The title of the nav bar
    var categoryTitleForNavBar: String = ""
    
    // Sets up the icons on initialization, add all customization here
    func setupIcons() {
        // Custom white color
        deleteIcon.addAttribute(NSForegroundColorAttributeName, value: UIColor.whiteColor())
        editIcon.addAttribute(NSForegroundColorAttributeName, value: UIColor.whiteColor())
        completeIcon.addAttribute(NSForegroundColorAttributeName, value: UIColor.whiteColor())
    }
    
    // When a cell is pressed, then the user can save, or exit without saving.
    @IBAction func backToTaskFromEdit(segue: UIStoryboardSegue) {
        if let identifier = segue.identifier {
            switch identifier {
                // If the Save button is pressed from Edit
            case "saveFromEdit":
                println("Save from Edit")
                
                let saveFromEditTask = segue.sourceViewController as! EditTaskViewController
                
                // Calls save task which saves the task from the edit section
                saveFromEditTask.saveTask()
                
                // If the Exit button is pressed
            case "exitFromEdit":
                println("Exit from Edit")
                
                // Else
            default:
                println("Nothing from edit \(identifier)")
            }
            
            // Adds new tasks in real-time
            tasks = category?.tasksWithinCategory.sorted("orderingDate", ascending: true)
            
        }
    }
    
    @IBAction func addOrDeleteButton(sender: AnyObject) {
        if (flagForAddOrDelete == false) {
            
            // If the number of selected rows to delete is 3 or greater
            if (selectedRows.count >= 3) {
                // Show a popup alert!
                let deleteThreeOrMoreTasksAlertView = SCLAlertView()
                
                // The ok button
                deleteThreeOrMoreTasksAlertView.addButton("Ok") {
                    println(self.selectedRows.count)
                    self.realm.write() {
                        // Goes through each row and deletes all the selected ones
                        for (var index = 0; index <= self.selectedRows.count - 1; index++) {
                            // TODO: Get rows to animate and delete 1 by 1.
                            
                            self.realm.delete(self.selectedRows[index])
                        }
                        
                        self.selectedRows.removeAll(keepCapacity: false)
                    }
                    
                    // Refreshes the tasks and updates
                    self.tasks = self.category?.tasksWithinCategory.sorted("orderingDate", ascending: true)
                    
                    // Closes the alertView
                    deleteThreeOrMoreTasksAlertView.close()
                    
                    // Disables edit after done is pressed
                    if (self.navigationItem.rightBarButtonItem?.enabled == false) {
                        self.navigationItem.rightBarButtonItem?.enabled = true
                        self.deleteAlreadyPressed = true
                    }
                }
                
                // The cancel button
                deleteThreeOrMoreTasksAlertView.addButton("Cancel") {
                    
                    // Closes the alertVIew
                    deleteThreeOrMoreTasksAlertView.close()
                    
                    // Deselect the items which were previously selected
                }
                
                // This is what the type of popup the alert will show
                deleteThreeOrMoreTasksAlertView.showWarning("Are you sure?", subTitle: "This will delete \(selectedRows.count) items permanently")
                
            } else {
                
                // If the number of tasks is less than 3, then just delete them with no warning
                self.realm.write() {
                    // Goes through each row and deletes all the selected ones
                    for (var index = 0; index <= self.selectedRows.count - 1; index++) {
                        // TODO: Get rows to animate and delete 1 by 1.
                        
                        self.realm.delete(self.selectedRows[index])
                    }
                    
                    self.selectedRows.removeAll(keepCapacity: false)
                }
                
                // Refreshes the tasks and updates
                self.tasks = self.category?.tasksWithinCategory.sorted("orderingDate", ascending: true)
                
                // Disables edit after done is pressed
                if (self.navigationItem.rightBarButtonItem?.enabled == false) {
                    self.navigationItem.rightBarButtonItem?.enabled = true
                    deleteAlreadyPressed = true
                }
            }
            
            
            
        }   else {
            println("segue has been performed")
            performSegueWithIdentifier("addTask", sender: self)
        }
        
    }
    
    @IBAction func backToTaskFromAdd(segue: UIStoryboardSegue) {
        if let identifier = segue.identifier {
            switch identifier {
                // If the Save button is pressed from New
            case "saveFromAdd":
                println("Save from add!")
                
                let newSource = segue.sourceViewController as! AddNewTaskViewController
                let indexPath = taskHomeTableView.indexPathForSelectedRow()
                
                realm.write() {
                    // Creates a newTask
                    self.realm.add(newSource.newTask!)
                    //println("added \(newSource.newTask!)")
                    
                    //println(self.category!.tasksWithinCategory.append(newSource.newTask!))
                }
                
                // If the exit button is pressed from New
            case "exitFromAdd":
                println("Exit from add!")
                
                // Else
            default:
                println("Nothing from new \(identifier)")
            }
            
            // Sort tasks which are within each category by modificationDate
            tasks = category?.tasksWithinCategory.sorted("orderingDate", ascending: true)
            
        }
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if (segue.identifier == "editTask") {
            let targetVC = segue.destinationViewController as! EditTaskViewController
            
            // Set the editedTask as selectedTask
            let selectedIndexPath = taskHomeTableView.indexPathForSelectedRow()!
            let selectedTask = tasks[selectedIndexPath.row]
            targetVC.editedTask = selectedTask
            
            //            // Sets selectedDate as selectedDate
            //            targetVC.showSelectedDate = self.showSelectedDate
            //
            //            println("hi \(showSelectedDate)")
            
            realm.write() {
                targetVC.editedTask!.badge = selectedTask.badge
                
                targetVC.editedTask!.modificationDate = selectedTask.modificationDate
            }
            
            targetVC.editButtonImage = self.addButtonColor
            targetVC.addButtonColor = self.addButtonColor
            
        } else if (segue.identifier == "addTask") {
            let targetVC = segue.destinationViewController as! AddNewTaskViewController
            
            // Sets the category for AddNewTaskVC to be the category that has been transferred from CategoryVC
            targetVC.category = self.category
            targetVC.newTask?.category = self.category
            
            targetVC.addButtonColor = self.addButtonColor
        } else if (segue.identifier == "backToCategoryFromTask") {
            let targetVC = segue.destinationViewController as! CategoryViewController
            
            targetVC.category = self.category
            //println("HIHIHIHIHIHI \(category)")
            // Updates the task count when going back to the categoryVC after deleting or completing a task
            //targetVC.taskCount = self.category!.tasksWithinCategory.count
            //println(targetVC.taskCount)
        }
        
        tasks = category?.tasksWithinCategory.sorted("orderingDate", ascending: true)
    }
    
    override func setEditing(editing: Bool, animated: Bool) {
        super.setEditing(editing, animated: animated)
        
        // Sets edit mode for the tableView
        self.taskHomeTableView.setEditing(editing, animated: true)
        
        if (editing == true) {
            
            if (addButtonColor == "addPurple") {
                // Changes the image to a garbage can
                toImage = UIImage(named: "GarbagePurple")
            } else if (addButtonColor == "addTurquoise") {
                // Changes the image to a garbage can
                toImage = UIImage(named: "GarbageTurquoise")
            } else if (addButtonColor == "addRed") {
                // Changes the image to a garbage can
                toImage = UIImage(named: "GarbageRed")
            } else if (addButtonColor == "addBlue") {
                // Changes the image to a garbage can
                toImage = UIImage(named: "GarbageBlue")
            } else {
                // Changes the image to a garbage can
                toImage = UIImage(named: "GarbageDark")
            }
            
            UIView.transitionWithView(self.addImage,
                duration: 0.35,
                options: UIViewAnimationOptions.TransitionFlipFromBottom,
                animations: { self.addImage.image = self.toImage },
                completion: nil)
            
            taskHomeTableView.isEnabled = false
            
            flagForAddOrDelete = false
            println("Flag is \(flagForAddOrDelete)")
            println("Editing is \(editing)")
        } else if (editing == false) {
          
            // Enables the delete button
            addBackgroundButton.enabled = true

            // Changes the image to the addButton
            let backImage = UIImage(named: "addButtonWhite")
            UIView.transitionWithView(self.addImage,
                duration: 0.35,
                options: UIViewAnimationOptions.TransitionFlipFromTop,
                animations: { self.addImage.image = backImage },
                completion: nil)
            
            taskHomeTableView.isEnabled = true
            
            if (deleteAlreadyPressed == true) {
                // Disable edit button again
                self.navigationItem.rightBarButtonItem?.enabled = false
            }
            
            flagForAddOrDelete = true
            println("Flag is \(flagForAddOrDelete)")
            println("Editing is \(editing)")
        }
        
        // Reloads the data for the tableView for cellforrowatindexpath function so enabling the edit can be turned off and on
        //self.taskHomeTableView.reloadData()
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        println(category?.taskCount)
        
        println("ordering date is \(orderingDate)")
        
        // Hides the fadedIconImage and the no task label when loaded
        fadedIconImage.hidden = true
        noTaskLabel.hidden = true
        
        // Sets the right bar button item to be a edit button item.
        self.navigationItem.rightBarButtonItem = self.editButtonItem()
        
        // Navigation color controls
        let navigation = self.navigationController?.navigationBar
        let leftNavigation = self.navigationItem.leftBarButtonItem
        let rightNavigation = self.navigationItem.rightBarButtonItem
        
        // Segues to add task if category tasks is 0
        //        if (category?.tasksWithinCategory.count == 0) {
        //            performSegueWithIdentifier("addTask", sender: self)
        //        }
        
        println("The color is \(addButtonColor)")
        
        if (addButtonColor == "addPurple") {
            // Sets the button color!
            self.addBackgroundButton.setBackgroundImage(UIImage(named: "\(addButtonColor)"), forState: .Normal)
            
            // Sets the navbar color to purple
            navigation?.barTintColor = purpleColor
            
            navigation?.titleTextAttributes = [NSForegroundColorAttributeName: UIColor.whiteColor()]
            rightNavigation?.tintColor = UIColor.whiteColor()
            
            // Changes the fill color of checkmark in edit mode
            self.taskHomeTableView.tintColor = purpleColor
            
            // Intializes the add button
            addImage.image = UIImage(named: "addButtonWhite")
            
        } else if (addButtonColor == "addTurquoise") {
            // Sets the button Color
            self.addBackgroundButton.setBackgroundImage(UIImage(named: "\(addButtonColor)"), forState: .Normal)
            
            // sets the navbar color to turquoise
            navigation?.barTintColor = turquoiseColor
            
            navigation?.titleTextAttributes = [NSForegroundColorAttributeName: UIColor.whiteColor()]
            rightNavigation?.tintColor = UIColor.whiteColor()
            
            // Changes the fill color of checkmark in edit mode
            self.taskHomeTableView.tintColor = turquoiseColor
            // Intializes the add button
            addImage.image = UIImage(named: "addButtonWhite")
            
        } else if (addButtonColor == "addRed") {
            // Sets the button Color
            self.addBackgroundButton.setBackgroundImage(UIImage(named: "\(addButtonColor)"), forState: .Normal)
            
            // sets the navbar color to red
            navigation?.barTintColor = redColor
            
            navigation?.titleTextAttributes = [NSForegroundColorAttributeName: UIColor.whiteColor()]
            rightNavigation?.tintColor = UIColor.whiteColor()
            
            // Changes the fill color of checkmark in edit mode
            self.taskHomeTableView.tintColor = redColor
            
            // Intializes the add button
            addImage.image = UIImage(named: "addButtonWhite")
            
        } else if (addButtonColor == "addBlue") {
            // Sets the button Color
            self.addBackgroundButton.setBackgroundImage(UIImage(named: "\(addButtonColor)"), forState: .Normal)
            
            // sets the navbar color to blue
            navigation?.barTintColor = blueColor
            
            navigation?.titleTextAttributes = [NSForegroundColorAttributeName: UIColor.whiteColor()]
            rightNavigation?.tintColor = UIColor.whiteColor()
            
            // Changes the fill color of checkmark in edit mode
            self.taskHomeTableView.tintColor = blueColor
            
            // Intializes the add button
            addImage.image = UIImage(named: "addButtonWhite")
            
        } else {
            // If the bar has no color
            // Changes the navbar controls
            rightNavigation?.tintColor = UIColor.whiteColor()
            leftNavigation?.tintColor = UIColor.whiteColor()
            
            // Changes the fill color of checkmark in edit mode
            self.taskHomeTableView.tintColor = darkColor
            
            // Intializes the add button
            addImage.image = UIImage(named: "addButtonWhite")
        }
        
        
        
        //navigation?.barTintColor = UIColor(red: 48/255, green: 220/255, blue: 107/255, alpha: 80)
        // Disables the interaction with the image so that the image is basically transparent
        addImage.userInteractionEnabled = false
        
        
        // Sets title to the categoryTitleForNavBar
        //self.title = "\(categoryTitleForNavBar) Category"
        self.title = categoryTitleForNavBar
        
        // Sets the multiple editing feature
        self.taskHomeTableView.allowsMultipleSelectionDuringEditing = true
        
        taskHomeTableView.delegate = self
        taskHomeTableView.dataSource = self
        
        // Calls setupIcons method
        setupIcons()
        
        // The replace cell function
        replaceCell = {(tableView: SBGestureTableView, cell: SBGestureTableViewCell) -> Void in
            
            let indexPath = tableView.indexPathForCell(cell)
            
            let selectedCell = self.tasks[indexPath!.row]
            
            // Animation for the replaceCell Function
            tableView.replaceCell(cell, duration: 0.3, bounce: 0.2, completion: nil)
            
            //let cell = tableView.dequeueReusableCellWithIdentifier("taskCell", forIndexPath: indexPath!) as! TaskTableViewCell
            
            // Unhides the crossOutmark
            //cell.crossOutTask.hidden = false
            //self.prepareForSegue(segue, sender: self)
            //            self.selectedTask = self.tasks[indexPath!.row]
            
            
            // For the grey background.
            cell.backgroundColor = UIColor(red: 44.3/255, green: 197.3/255, blue: 93.9/255, alpha: 1.0)
//            cell.backgroundColor = UIColor(
//            cell.userInteractionEnabled = false
            if let cell = cell as? TaskTableViewCell {
//                cell.taskLabel.text = "POTATOgfhbfhfghfh"
//                let attributes = [NSStrikethroughStyleAttributeName : NSUnderlineStyle.StyleSingle.rawValue]
//                cell.taskLabel.attributedText = NSAttributedString(string: "POTATOJFDKLSJFDKLSFJDKSLFJDKSLFSJDF", attributes: attributes)
                cell.badgeImage.image = UIImage(named: "badgeComplete")
                cell.taskLabel.textColor = UIColor.whiteColor()
                cell.dateLabel.textColor = UIColor.whiteColor()
                //cell.userInteractionEnabled = false
                println("user interaction false")
//              cell.crossOutTask.hidden = false
                self.realm.write() {
                    selectedCell.complete = true
                    selectedCell.badge = 12
                    println(selectedCell.badge)
                }
            }
            println(selectedCell)
        }
        
        // The remove block function
        removeCellBlock = {(tableView: SBGestureTableView, cell: SBGestureTableViewCell) -> Void in
            // indexPath = int, sets up indexPath
            let indexPath = tableView.indexPathForCell(cell)
            
            // let category = the category object at indexPath.row AS AN OBJECT
            let tasks = self.tasks[indexPath!.row] as Object
            
            // Pass the object we just created to delete
            self.realm.write() {
                self.realm.delete(tasks)
                
                // Subtracts 1 count from the taskCount when removecellBlock is called
                self.category!.tasksWithinCategory.count - 1
                
                println(self.category!.tasksWithinCategory.count)
            }
            // The animation to delete (manditory/ needed)
            tableView.removeCell(cell, duration: 0.3, completion: nil)
        }
        
        // Sort tasks which are within each category by modificationDate
        tasks = category?.tasksWithinCategory.sorted("orderingDate", ascending: true)
    }
    
    // Customizes the title Bar
    override func viewDidAppear(animated: Bool) {
        // Selects the nav bar
        let navigation = self.navigationController?.navigationBar
        
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        
        // Sorts tasks based on their modification Date
        tasks = category?.tasksWithinCategory.sorted("orderingDate", ascending: true)
        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    override
}

extension TaskViewController: UITableViewDataSource {
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        // Initialize Cell
        let cell = tableView.dequeueReusableCellWithIdentifier("taskCell", forIndexPath: indexPath) as! TaskTableViewCell
        let completedCell = tasks[indexPath.row]
        
        // Sets size for the image when we swipe
        let size = CGSizeMake(30, 30)
        
        // If editing is on, dont let the user swipe to delete or complete tasks. Vice Versa.
        // The Actions for the cells
        if (editing == false) {
            cell.firstRightAction = SBGestureTableViewCellAction(icon: deleteIcon.imageWithSize(size), color: redColor, fraction: 0.3, didTriggerBlock: removeCellBlock)
            cell.firstLeftAction = SBGestureTableViewCellAction(icon: completeIcon.imageWithSize(size), color: greenColor, fraction: 0.3, didTriggerBlock: replaceCell)
            // A bool to see if the editing is enabled
        }
        
        println(completedCell)
        if (completedCell.complete == true) {
            // Change the text and blah blah
            //cell.badgeImage.image = UIImage(named: "badgeComplete")
            cell.taskLabel.textColor = UIColor.whiteColor()
            cell.dateLabel.textColor = UIColor.whiteColor()
            cell.backgroundColor = UIColor(red: 44.3/255, green: 197.3/255, blue: 93.9/255, alpha: 1.0)
            cell.chevronRight.image = UIImage(named: "chevronRightWhite")

        } else {
            // nothing
            println("not completed")
        }
        
        // Configure cell
        let row = indexPath.row
        let task = tasks[row] as Task
        cell.task = task
        
        return cell
    }
    
    // How many rows are in the table view
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        // If the number of tasks are 0
        if (tasks.count == 0) {
            // Set the background hidden view to show up
            fadedIconImage.hidden = false
            noTaskLabel.hidden = false
            
            // Disable the edit button
            self.navigationItem.rightBarButtonItem?.enabled = false
            
        } else {
            // Set the background hidden view to dissapear
            fadedIconImage.hidden = true
            noTaskLabel.hidden = true
            
            // Enbales the edit button
            self.navigationItem.rightBarButtonItem?.enabled = true
        }
        
        return Int(tasks?.count ?? 0)
    }
}

extension TaskViewController: UITableViewDelegate {
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        
        // Assigns the task object at the cell to selectedTask
        let selectedTask = tasks[indexPath.row]
        
        if (editing == true) {
            
            // If its in the selectedRow array, then remove, else add. Fixes problem with overlapping objects in the array
            if let index = find(selectedRows, selectedTask) {
                // Removing at index "index" the selectedTask form selectedRows
                selectedRows.removeAtIndex(index)
                println(selectedRows.count)
                //println("\(selectedTask) at index \(index)")
            } else {
                // Appending selectedTask to the array of selectedRows
                selectedRows.append(selectedTask)
                println(selectedRows.count)
                //println("\(selectedTask) at index \(indexPath.row)")
            }
            
//            if (selectedRows.count > 0) {
//                addBackgroundButton.enabled = true
//            } else {
//                addBackgroundButton.enabled = false
//            }
            
        } else {
            // Performs the segue to editTaskVC
            self.performSegueWithIdentifier("editTask", sender: self)
            
            // To deselect a cell after it's tapped
            tableView.deselectRowAtIndexPath(indexPath, animated: true)
        }
        
        if (selectedTask.badge == 12) {
            
            let cannotEditAlertView = SCLAlertView()
            
            // The delete button
            cannotEditAlertView.addButton("Ok") {
                println("Ok has been tapped")
                
                // Closes the alertView
                cannotEditAlertView.close()
                
            }
            
            cannotEditAlertView.showWarning("Are you sure?", subTitle: "This will delete the list and all its tasks")

            
        }
    }
    
    func tableView(tableView: UITableView, didDeselectRowAtIndexPath indexPath: NSIndexPath) {
        
        // taskTodeselect is the task at indexPath.row
        let taskToDeselect = tasks[indexPath.row]
        if let index = find(selectedRows, taskToDeselect) {
            //println(index)
            //println("this is indexpath.row \(indexPath.row)")
            // Removing from selectedRows the selectedRow at index
            selectedRows.removeAtIndex(index)
            println(selectedRows.count)
        }
        
//        if (selectedRows.count == 0) {
//            addBackgroundButton.enabled = false
//        }
    }
    
    func tableView(tableView: UITableView, canEditRowAtIndexPath indexPath: NSIndexPath) -> Bool {
        return true
    }
}



