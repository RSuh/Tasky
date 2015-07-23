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
    
    @IBAction func goToEditMode(sender: UIBarButtonItem) {
    }
    
    @IBOutlet weak var listTableView: SBGestureTableView!
    
    // Reloads the lists everytime the page loads.
    var lists: Results<List>!
        {
        didSet {
            listTableView?.reloadData()
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
    var replaceCell: ((SBGestureTableView, SBGestureTableViewCell) -> Void)!
    
    // A var of type List which indicates the selectedList
    var selectedList: List?
    
    func performSegueToEdit(identifier: String) {
        self.performSegueWithIdentifier(identifier, sender: self)
    }
    
    // Sets up the icons on initialization, add all customization here
    func setupIcons() {
        // Custom white color
        deleteIcon.addAttribute(NSForegroundColorAttributeName, value: UIColor.whiteColor())
        editIcon.addAttribute(NSForegroundColorAttributeName, value: UIColor.whiteColor())
        completeIcon.addAttribute(NSForegroundColorAttributeName, value: UIColor.whiteColor())
    }
    
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
        
        // Calls setupIcons method
        setupIcons()
        
        replaceCell = {(tableView: SBGestureTableView, cell: SBGestureTableViewCell) -> Void in
            let indexPath = tableView.indexPathForCell(cell)
            //self.prepareForSegue(segue, sender: self)
            self.selectedList = self.lists[indexPath!.row]
            println(self.selectedList)
            self.performSegueToEdit("listToEdit")
            
            
            tableView.fullSwipeCell(cell, duration: 0.3, completion: nil)
        }
        
        removeCellBlock = {(tableView: SBGestureTableView, cell: SBGestureTableViewCell) -> Void in
            // indexPath = int, sets up indexPath
            let indexPath = tableView.indexPathForCell(cell)
            // let list = the list object at indexPath.row AS AN OBJECT
            let list = self.lists[indexPath!.row] as Object
            // Pass the object we just created to delete
            self.realm.write() {
                self.realm.delete(list)
            }
            // The animation to delete (manditory/ needed)
            tableView.removeCell(cell, duration: 0.3, completion: nil)
        }
        
        
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
    
//    self.storyboard.instantiateViewControllerWithString (pass identifier)
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
//                if (segue.identifier == "editList") {
//                    let targetVC = segue.destinationViewController as! EditListViewController
//                    //let VC = segue.destinationViewController as! ListTableViewCell
//        
//                    // Set the editedTask as the selectedList
//                    targetVC.editedList = selectedList
//        
//                } else
        if (segue.identifier == "listToTask") {
            let titleVC = segue.destinationViewController as! TaskViewController
            // Sets the list title in the next VC to be the selected list's title
            titleVC.listTitleForNavBar = selectedList!.listTitle
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
        
        let size = CGSizeMake(30, 30)
        cell.firstRightAction = SBGestureTableViewCellAction(icon: deleteIcon.imageWithSize(size), color: redColor, fraction: 0, didTriggerBlock: removeCellBlock)
        //cell.secondRightAction  = SBGestureTableViewCellAction(icon: deleteIcon.imageWithSize(size), color: redColor, fraction: 0.6, didTriggerBlock: removeCellBlock)
        cell.firstLeftAction = SBGestureTableViewCellAction(icon: completeIcon.imageWithSize(size), color: greenColor, fraction: 0.3, didTriggerBlock: removeCellBlock)
        
        //cell.secondRightAction = SBGestureTableViewCellAction(icon: closeIcon.imageWithSize(size), color: yellowColor, fraction: 0.6, didTriggerblock: removeCellBlock)
        
        //cell.secondRightAction = SBGestureTableViewCellAction(icon: clockIcon.imageWithSize(size), color: brownColor, fraction: 0.6, didTriggerBlock: removeCellBlock)
        // Set up cell
        let row = indexPath.row
        let list = lists[row] as List
        cell.list = list
        
        
        // NOTE: This does not show up on initial load with no lists.
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
        
        listTableView.deselectRowAtIndexPath(indexPath, animated: true)
    }
    
    func tableView(tableView: UITableView, canEditRowAtIndexPath indexPath: NSIndexPath) -> Bool {
        return true
    }
}