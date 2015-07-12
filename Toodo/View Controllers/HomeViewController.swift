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
    
    // When a cell is pressed, then the user can save, or exit without saving.
    @IBAction func backToHomeFromEdit(segue: UIStoryboardSegue) {
        if let identifier = segue.identifier {
            let realm = Realm()
            switch identifier {
                // If the Save button is pressed from Edit
            case "saveFromEdit":
                println("Save from Edit")
//                let editSource = segue.sourceViewController as! EditTaskViewController
//                
//                realm.write() {
//                    realm.add(editSource.editTask!)
//                }
                
                // If the Exit button is pressed
            case "exitFromEdit":
                println("Exit from Edit")
                // Else
            default:
                println("Nothing from edit \(identifier)")
            }
            //tasks = realm.objects(Task).sorted("modificationDate", ascending: false)
        }
    }
    
    @IBAction func backToHomeFromNew(segue: UIStoryboardSegue) {
        if let identifier = segue.identifier {
            let realm = Realm()
            switch identifier {
                // If the Save button is pressed from New
            case "saveFromNew":
                println("Save from New!")
                let newSource = segue.sourceViewController as! ChooseCategoryViewController
                realm.write() {
                    realm.add(newSource.newTask!)
                }
                
                
                
            case "exitFromNew":
                println("Exit from New!")
                
            default:
                println("Nothing from new \(identifier)")
            }
            
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
        homeTableView.delegate = self
        let realm = Realm()
        tasks = realm.objects(Task).sorted("modificationDate", ascending: true)
        
        //        let myTask = Task()
        //        myTask.taskTitle = "Test task"
        //
        //        //Deletes all tasks *For testing*
        //        realm.write() {
        //            realm.add(myTask)
        //            realm.deleteAll()
        //        }
        
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

extension HomeViewController: UITableViewDelegate {
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
//        selectedTask = tasks[indexPath.row]
//        self.performSegueWithIdentifier("segueidentifier", sender: self)
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

