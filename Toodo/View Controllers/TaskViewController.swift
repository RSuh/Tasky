//
//  ViewController.swift
//  Toodo
//
//  Created by Reginald Suh on 2015-07-10.
//  Copyright (c) 2015 ReginaldSuh. All rights reserved.
//

import UIKit
import RealmSwift

class TaskViewController: UIViewController {
    
    // REMEMBER TO CONNECT THE OUTLET IN STORYBOARD
    @IBOutlet weak var taskHomeTableView: SBGestureTableView!
    
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
    
    // The task which is currently selected
    var selectedTask: Task?
    
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
            tasks = category?.tasksWithinCategory.sorted("modificationDate", ascending: false)
            //var taskOne = taskList[0]
            
        }
    }
    
    @IBAction func backToTaskFromAdd(segue: UIStoryboardSegue) {
        if let identifier = segue.identifier {
            switch identifier {
                // If the Save button is pressed from New
            case "saveFromAdd":
                println("Save from add!")
                
                let newSource = segue.sourceViewController as! AddNewTaskViewController
                
                realm.write() {
                    // Creates a newTask
                    self.realm.add(newSource.newTask!)
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
            tasks = category?.tasksWithinCategory.sorted("modificationDate", ascending: false)
            
        }
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if (segue.identifier == "editTask") {
            let targetVC = segue.destinationViewController as! EditTaskViewController
            
            // Set the editedTask as selectedTask
            targetVC.editedTask = self.selectedTask
            println(targetVC.editedTask)
            realm.write() {
                targetVC.editedTask!.badge = self.selectedTask!.badge
                println(targetVC.editedTask!.badge)
            }
            
        } else if (segue.identifier == "addTask") {
            let targetVC = segue.destinationViewController as! AddNewTaskViewController
            
            // Sets the category for AddNewTaskVC to be the category that has been transferred from CategoryVC
            targetVC.category = self.category
            targetVC.newTask?.category = self.category
        }
//        else if (segue.identifier == "backToCategoryFromTask") {
//            let targetVC = segue.destinationViewController as! CategoryViewController
//            
//            // Updates the task count when going back to the categoryVC after deleting or completing a task
//            targetVC.categoryTableView.reloadData()
//            
        }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Sets title to the categoryTitleForNavBar
        //self.title = "\(categoryTitleForNavBar) Category"
        self.title = categoryTitleForNavBar
        
        // Calls setupIcons method
        setupIcons()
        
        // The replace cell function
        replaceCell = {(tableView: SBGestureTableView, cell: SBGestureTableViewCell) -> Void in
            let indexPath = tableView.indexPathForCell(cell)
            
            //self.prepareForSegue(segue, sender: self)
            self.selectedTask = self.tasks[indexPath!.row]
            
            // For the grey background.
            cell.backgroundColor = UIColor(red: 220/255, green: 216/255, blue: 216/255, alpha: 100)
            
            // Animation for the replaceCell Function
            tableView.replaceCell(cell, duration: 0.3, bounce: 0.2, completion: nil)
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
            }
            // The animation to delete (manditory/ needed)
            tableView.removeCell(cell, duration: 0.3, completion: nil)
        }
        
        // Sort tasks which are within each category by modificationDate
        tasks = category?.tasksWithinCategory.sorted("modificationDate", ascending: false)
    }
    
    // Customizes the title Bar
    override func viewDidAppear(animated: Bool) {
        // Selects the nav bar
        let navigation = self.navigationController?.navigationBar
        
        // Customizes the color of the navbar
        navigation?.barTintColor = UIColor(red: 48/255, green: 220/255, blue: 107/255, alpha: 80)
        
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        
        // Sorts tasks based on their modification Date
        tasks = category?.tasksWithinCategory.sorted("modificationDate", ascending: false)
         
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
}

extension TaskViewController: UITableViewDataSource {
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        // Initialize Cell
        let cell = tableView.dequeueReusableCellWithIdentifier("taskCell", forIndexPath: indexPath) as! TaskTableViewCell
        
        // Sets size for the image when we swipe
        let size = CGSizeMake(30, 30)
        
        // The Actions for the cells
        cell.firstRightAction = SBGestureTableViewCellAction(icon: deleteIcon.imageWithSize(size), color: redColor, fraction: 0.3, didTriggerBlock: removeCellBlock)
        cell.firstLeftAction = SBGestureTableViewCellAction(icon: completeIcon.imageWithSize(size), color: greenColor, fraction: 0.3, didTriggerBlock: removeCellBlock)
        
        // Configure cell
        let row = indexPath.row
        let task = tasks[row] as Task
        cell.task = task
        
        // Sets custom separators between cells on viewDidLoad
        taskHomeTableView.separatorInset = UIEdgeInsetsZero
        taskHomeTableView.layoutMargins = UIEdgeInsetsZero
        
        
        
        // This makes the separator be centered between the cells.
        //tableView.separatorInset.right = tableView.separatorInset.left
        
        return cell
    }
    
    // How many rows are in the table view
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return Int(tasks?.count ?? 0)
    }
}

extension TaskViewController: UITableViewDelegate {
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        // Assigns the task object at the cell to selectedTask
        selectedTask = tasks[indexPath.row]
        
        // Performs the segue to editTaskVC
        self.performSegueWithIdentifier("editTask", sender: self)
        
        // To deselect a cell after it's tapped
        tableView.deselectRowAtIndexPath(indexPath, animated: true)
    }
    
    func tableView(tableView: UITableView, canEditRowAtIndexPath indexPath: NSIndexPath) -> Bool {
        return true
    }
}

