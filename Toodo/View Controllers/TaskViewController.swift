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
    
    @IBOutlet weak var taskHomeTableView: UITableView!

    let realm = Realm()
    
    // Updates tableView whenever tasks update
    var tasks: Results<Task>! {
        didSet {
            taskHomeTableView?.reloadData()
        }
    }
    
    // The task which is currently selected
    var selectedTask: Task?
    
    // The title of the nav bar
    var listTitleForNavBar: String = ""
    
    // When a cell is pressed, then the user can save, or exit without saving.
    @IBAction func backToTaskFromEdit(segue: UIStoryboardSegue) {
        if let identifier = segue.identifier {
            switch identifier {
                // If the Save button is pressed from Edit
            case "saveFromEdit":
                println("Save from Edit")
                
                let editSource = segue.sourceViewController as! EditTaskViewController
                
                // Calls save task which saves the task from the edit section
                editSource.saveTask()
                
                // If the Exit button is pressed
            case "exitFromEdit":
                println("Exit from Edit")
                
                // Else
            default:
                println("Nothing from edit \(identifier)")
            }
        }
    }
    
    @IBAction func backToTaskFromAdd(segue: UIStoryboardSegue) {
        if let identifier = segue.identifier {
            switch identifier {
                // If the Save button is pressed from New
            case "saveFromAdd":
                println("Save from add!")
                
                let newSource = segue.sourceViewController as! EditTaskViewController
                
                realm.write() {
                    // Creates a newTask
                    self.realm.add(newSource.editedTask!)
                    
                }
                
                // If the exit button is pressed from New
            case "exitFromAdd":
                println("Exit from add!")
                
                // Else
            default:
                println("Nothing from new \(identifier)")
            }
            
            // Adds new tasks in real-time
            tasks = realm.objects(Task).sorted("modificationDate", ascending: false)
        }
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
        tasks = realm.objects(Task).sorted("modificationDate", ascending: false)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // On load, loads all the tasks from before according to modification Date
        tasks = realm.objects(Task).sorted("modificationDate", ascending: false)
        
        self.title = listTitleForNavBar
        // Do any additional setup after loading the view, typically from a nib.
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if (segue.identifier == "editTask") {
            let targetVC = segue.destinationViewController as! EditTaskViewController
            // Set the editedTask as selectedTask
            targetVC.editedTask = selectedTask
        }
    }
}

extension TaskViewController: UITableViewDataSource {
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        // Initialize Cell
        let cell = tableView.dequeueReusableCellWithIdentifier("taskCell", forIndexPath: indexPath) as! TaskTableViewCell
        
        // Configure cell
        let row = indexPath.row
        let task = tasks[row] as Task
        cell.task = task
        
        // For the grey background.
        //cell.backgroundColor = UIColor(red: 220/255, green: 216/255, blue: 216/255, alpha: 100)
        
        // Custom separator lines between cells
        tableView.separatorInset = UIEdgeInsetsZero
        tableView.layoutMargins = UIEdgeInsetsZero
        cell.layoutMargins = UIEdgeInsetsZero
        
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
    
    // The delete swipe function
    func tableView(tableView: UITableView, commitEditingStyle editingStyle: UITableViewCellEditingStyle, forRowAtIndexPath indexPath: NSIndexPath) {
        if editingStyle == .Delete {
            let task = tasks[indexPath.row] as Object
            
            realm.write() {
                self.realm.delete(task)
            }
            
            tasks = realm.objects(Task).sorted("modificationDate", ascending: false)
        }
    }
}

