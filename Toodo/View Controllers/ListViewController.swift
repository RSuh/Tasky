//
//  ListViewController.swift
//  Toodo
//
//  Created by Reginald Suh on 2015-07-14.
//  Copyright (c) 2015 ReginaldSuh. All rights reserved.
//

import UIKit
import RealmSwift

class ListViewController: UIViewController {
    
    let realm = Realm()
    
    @IBOutlet weak var listTableView: UITableView!
    
    // Reloads the lists everytime the page loads.
    var lists: Results<List>! {
        didSet {
            listTableView?.reloadData()
        }
    }
    
    // A var of type List which indicates the selectedList
    var selectedList: List?
    
    @IBAction func backToListFromAddingList(segue: UIStoryboardSegue) {
        if let identifier = segue.identifier {
            switch identifier {
            case "exitToListFromAdd":
                println("exit to list from add")
                
            case "saveToListFromAdd":
                println("save to list from add")
                
                let saveSourceFromAdd = segue.sourceViewController as! AddNewListViewController
                
                realm.write() {
                    // Adds a newList
                    self.realm.add(saveSourceFromAdd.addNewList!)
                }
                
            default:
                println("failed")
                
                // Sort by number of tasks, able to sort by count.
                lists = realm.objects(List).sorted("taskCount", ascending: false)
            }
        }
    }
    
    @IBAction func backToListFromEdit(segue: UIStoryboardSegue) {
        if let identifier = segue.identifier {
            switch identifier {
                case "exitToListFromEdit":
                println("exit to list from edit")
                
                case "saveToListFromEdit":
                //println("save to list from edit")
                
                let saveSourceFromEdit = segue.sourceViewController as! EditListViewController
                
                // From EditListViewController, saveList as you go back to listViewcontroller
                //saveSourceFromEdit.saveList()
                
            default:
                println("failed")
                
                // Sorts by number of tasks, able to sort by count.
                lists = realm.objects(List).sorted("taskCount", ascending: false)
            }
        }
    }
    
    @IBAction func backToListFromTasks(segue: UIStoryboardSegue) {
        if let identifier = segue.identifier {
            switch identifier {
                case "backtoListFromTask":
                println("Back to list from tasks")
                
            default:
                println("nothing")
            }
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        listTableView.delegate = self
        listTableView.dataSource = self
        
        // Sets up the lists cells by the modificationDate
        lists = realm.objects(List).sorted("taskCount", ascending: false)
    
        // Do any additional setup after loading the view.
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        
        lists = realm.objects(List).sorted("taskCount", ascending: false)
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
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if segue.identifier == "editList" {
            let targetVC = segue.destinationViewController as! EditListViewController
            //let VC = segue.destinationViewController as! ListTableViewCell
            
            // Set the editedTask as the selectedList
            targetVC.editedList = selectedList
            
            println(targetVC.editedList)
            
            // TO FIX: Get the cell to be auto selected, or selected when the user presses the edit button because right now, you have to click the cell before you can do any editing.
        }
    }
    /*
    // MARK: - Navigation
    
    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
    // Get the new view controller using segue.destinationViewController.
    // Pass the selected object to the new view controller.
    }
    */
}

extension ListViewController: UITableViewDataSource {
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {

        // Initialize cell
        let cell = listTableView.dequeueReusableCellWithIdentifier("listCell", forIndexPath: indexPath) as! ListTableViewCell
        
        // Set up cell
        let row = indexPath.row
        let list = lists[row] as List
        cell.list = list
        
        cell.listEditButton.tag = indexPath.row

        // Custom separator lines between cells
        tableView.separatorInset = UIEdgeInsetsZero
        tableView.layoutMargins = UIEdgeInsetsZero
        cell.layoutMargins = UIEdgeInsetsZero
        
        return cell
    }
    
    // How many rows are in the tableView
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return Int(lists?.count ?? 0)
    }
}

extension ListViewController: UITableViewDelegate {
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        selectedList = lists[indexPath.row]
        self.performSegueWithIdentifier("listToTask", sender: self)
        println("selected List is \(selectedList!)")
        
        listTableView.deselectRowAtIndexPath(indexPath, animated: true)
    }
    
    func tableView(tableView: UITableView, canEditRowAtIndexPath indexPath: NSIndexPath) -> Bool {
        return true
    }
    
    func tableView(tableView: UITableView, commitEditingStyle editingStyle: UITableViewCellEditingStyle, forRowAtIndexPath indexPath: NSIndexPath) {
        if editingStyle == .Delete {
            let list = lists[indexPath.row] as Object
            
            realm.write() {
                self.realm.delete(list)
            }
            
            lists = realm.objects(List).sorted("taskCount", ascending: false)
        }
        
    }
    
}