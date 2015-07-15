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

    @IBOutlet weak var homeTableView: UITableView!
    
    // Updates tableView whenever tasks update
    var tasks: Results<Task>! {
        didSet {
            homeTableView?.reloadData()
        }
    }
    
    // The task which is currently selected
    var selectedTask: Task?
    
    // When a cell is pressed, then the user can save, or exit without saving.
    @IBAction func backToTaskFromEdit(segue: UIStoryboardSegue) {
        if let identifier = segue.identifier {
            let realm = Realm()
            switch identifier {
                // If the Save button is pressed from Edit
            case "saveFromEdit":
                println("Save from Edit")
                //let editSource = segue.sourceViewController as! EditTaskViewController
                
                // If the Exit button is pressed
            case "exitFromEdit":
                println("Exit from Edit")
                // Else
            default:
                println("Nothing from edit \(identifier)")
            }
            
            // Used to creating a new task when edit is selected right away
            //tasks = realm.objects(Task).sorted("modificationDate", ascending: false)
        }
    }
    
    @IBAction func backToTaskFromNew(segue: UIStoryboardSegue) {
        if let identifier = segue.identifier {
            let realm = Realm()
            switch identifier {
                // If the Save button is pressed from New
            case "saveFromNew":
                println("Save from New!")
//                let newSource = segue.sourceViewController as! ChooseCategoryViewController
//                realm.write() {
//                    realm.add(newSource.newTask!)
//                }
                
                // If the exit button is pressed from New
            case "exitFromNew":
                println("Exit from New!")
                
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
        var navigation = self.navigationController?.navigationBar
        
        // Customizes the color of the navbar
        navigation?.barTintColor = UIColor(red: 48/255, green: 220/255, blue: 107/255, alpha: 80)
        
    }
    
    override func viewWillAppear(animated: Bool) {
        let realm = Realm()
        super.viewWillAppear(animated)
        tasks = realm.objects(Task).sorted("modificationDate", ascending: false)
    }
    
    override func viewDidLoad() {
        let realm = Realm()
        super.viewDidLoad()
        // On load, loads all the tasks from before
        tasks = realm.objects(Task).sorted("modificationDate", ascending: false)
        
        
        //Deletes all tasks *For testing*
//        let myTask = Task()
//        
//        realm.write() {
//            realm.add(myTask)
//            realm.deleteAll()
//        }
        
        // Do any additional setup after loading the view, typically from a nib.
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if (segue.identifier == "editTask") {
            let targetVC = segue.destinationViewController as! EditTaskViewController
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
    
    func tableView(tableView: UITableView, commitEditingStyle editingStyle: UITableViewCellEditingStyle, forRowAtIndexPath indexPath: NSIndexPath) {
        if editingStyle == .Delete {
            let task = tasks[indexPath.row] as Object
            
            let realm = Realm()
            
            realm.write() {
                realm.delete(task)
            }
        
            tasks = realm.objects(Task).sorted("modificationDate", ascending: false)
        }
    }
}

