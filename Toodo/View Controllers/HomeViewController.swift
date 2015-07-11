//
//  ViewController.swift
//  Toodo
//
//  Created by Reginald Suh on 2015-07-10.
//  Copyright (c) 2015 ReginaldSuh. All rights reserved.
//

import UIKit
import RealmSwift

class HomeViewController: UIViewController {

    @IBOutlet weak var homeTableView: UITableView!
    // The original unwindtoSegue
    @IBAction func unwindtoSegue(segue: UIStoryboardSegue) {
        if let identifier = segue.identifier {
            let realm = Realm()
            switch identifier {
            // If the Save button is pressed
            case "Save":
                println("Save button pressed")
//                let source = segue.sourceViewController as! NewTaskViewController
//                
//                realm.write() {
//                    realm.add(source.newTask!)
                
            // If the Exit button is pressed
            case "Exit":
                println("Exit button pressed")
            // Else
            default:
                println("No one loves \(identifier)")
            }
            
            // Sorting the tasks by date
            tasks = realm.objects(Task).sorted("modificationDate", ascending: false)
        }
    }
    
    // Updates tableView whenever tasks update
    var tasks: Results<Task>! {
        didSet {
            homeTableView?.reloadData()
        }
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        homeTableView.dataSource = self
        
        // Creates a new Task object
        let newTask = Task()
        // Temporarily sets task title
        newTask.taskTitle = "Hi"
        
        let realm = Realm()
        realm.write() {
            // Adds a new task everytime the app is loaded
            realm.add(newTask)
            
            // Delete all tasks
            //realm.deleteAll()
        }
        
        tasks = realm.objects(Task)
        //  homeTableView.dataSource = self
        // Do any additional setup after loading the view, typically from a nib.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
}

extension HomeViewController: UITableViewDataSource {
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        // Initialize Cell
        let cell = tableView.dequeueReusableCellWithIdentifier("taskCell", forIndexPath: indexPath) as! TaskTableViewCell
        
        // Configure cell
        let row = indexPath.row
        let task = tasks[row] as Task
        cell.task = task
        
        return cell
    }
    
    // How many rows are in the table view
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return Int(tasks?.count ?? 0)
    }
    
}

