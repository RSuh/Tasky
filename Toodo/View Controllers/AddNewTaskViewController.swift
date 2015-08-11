//
//  AddNewTaskViewController.swift
//  Toodo
//
//  Created by Reginald Suh on 2015-07-17.
//  Copyright (c) 2015 ReginaldSuh. All rights reserved.
//

import Foundation
import UIKit
import RealmSwift
import SCLAlertView

class AddNewTaskViewController: UIViewController, UICollectionViewDelegate, UICollectionViewDataSource, UITextFieldDelegate {
    
    @IBOutlet weak var taskTitle: UITextField!
    @IBOutlet weak var badgeImage: UICollectionView!
    @IBOutlet weak var date: UILabel!
    @IBOutlet weak var calendarDateLabel: UILabel!
    
    // Initialize Realm
    let realm = Realm()
    
    var newTask: Task? {
        didSet {
            displayNewTask(newTask)
            displayNewBadge(newTask)
            displayDate(newTask)
        }
    }
    
    // Var to control the image
    var badge = 0
    var numDateLabel = ""
    var addButtonColor = ""
    var orderingDate: NSDate?
    var category: Category?
    
    var selectedRow: Int = 0
    
    var dateLabel: String = ""
//    var taskTitleMutable: NSMutableString =
    
    // A bool which determines whether or not the keyboard should automatically popup
    var keyboardPopUp: Bool = true
    
    // Displays the contents of the new task
    func displayNewTask(task: Task?) {
        if let task = task, taskTitle = taskTitle {
            realm.write() {
                task.taskTitle = self.newTask!.taskTitle
            }
        }
    }
    
    // Displays the badge of the new task
    func displayNewBadge(task: Task?) {
        if let task = task, badgeImage = badgeImage {
            realm.write() {
                task.badge = self.newTask!.badge
            }
        }
    }
    
    // Displays the due date of the task
    func displayDate(task: Task?) {
        if let task = task {
            realm.write() {
                task.modificationDate = self.dateLabel
            }
        }
    }
    
    // Saves the new task
    func saveNewTask() {
        if let newTask = newTask {
            realm.write() {
                if ((newTask.taskTitle != self.taskTitle.text) ||
                    (newTask.badge != self.badge) ||
                    (newTask.modificationDate != self.dateLabel) ||
                    (newTask.orderingDate != self.orderingDate)) {
                        newTask.taskTitle = self.taskTitle.text
                        newTask.badge = self.badge
                        self.category!.tasksWithinCategory.append(newTask)
                        self.category!.taskCount = self.category!.tasksWithinCategory.count
                        //self.category!.tasksWithinCategory.count = self.category!.numberOfTasksWithinCategory
                        newTask.modificationDate = self.dateLabel
                        println(self.category!.taskCount)
                        // Sets the ordering date
                        if (self.orderingDate != nil) {
                        newTask.orderingDate = self.orderingDate!
                        }
                        println(newTask.modificationDate)
                } else {
                    println("nothing has changed")
                }
                
            }
        }
    }
    
    func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return arrayConstants.cellImagesUnselected.count
    }
    
    func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCellWithReuseIdentifier("badgeImage", forIndexPath: indexPath) as! CategoryCollectionViewCell
        
        // Dismisses the keyboard on drag
        collectionView.keyboardDismissMode = UIScrollViewKeyboardDismissMode.OnDrag
        
        if (indexPath.row == self.selectedRow) {
            cell.checkmarkImage.hidden = false
        } else {
            cell.checkmarkImage.hidden = true
        }
        cell.chooseBadgeImage.image = UIImage(named: arrayConstants.cellImagesUnselected[indexPath.row])
        
        if (addButtonColor == "addPurple") {
            cell.checkmarkImage.image = UIImage(named: "checkmarkPurple")
        } else if (addButtonColor == "addRed") {
            cell.checkmarkImage.image = UIImage(named: "checkmarkRed")
        } else if (addButtonColor == "addTurquoise") {
            cell.checkmarkImage.image = UIImage(named: "checkmarkTurquoise")
        } else if (addButtonColor == "addBlue") {
            cell.checkmarkImage.image = UIImage(named: "checkmarkBlue")
        } else {
            cell.checkmarkImage.image = UIImage(named: "checkmarkDark")
        }
        
        return cell
    }
    
    func collectionView(collectionView: UICollectionView, didSelectItemAtIndexPath indexPath: NSIndexPath) {
        println("You have selected cell \(indexPath.row)")
        
        // Set badge to indexPath.row
        badge = indexPath.row
        
        let cell = collectionView.cellForItemAtIndexPath(indexPath) as! CategoryCollectionViewCell
        
        // Sets selectedRow to be indexPath.row
        self.selectedRow = indexPath.row
        
        taskTitle.endEditing(true)
        
        // Reloads data
        collectionView.reloadData()
        
    }
    
    
    @IBAction func backToAddFromCalendar(segue: UIStoryboardSegue) {
        if let identifier = segue.identifier {
            switch identifier {
            case "backToAddFromCalendar":
                println("Back to add from calendar")
                keyboardPopUp = false
            
                
            case "saveFromAddCalendar":
                println("Save from add calendar")
                keyboardPopUp = false
                // Makes the Set Date text to be the date
                date.text = self.dateLabel
                println(orderingDate)
                
                // Sets calendar date to be numDate
                calendarDateLabel.text = numDateLabel
                
            default:
                println("failed")
            }
        }
    }
    
    override func shouldPerformSegueWithIdentifier(identifier: String?, sender: AnyObject?) -> Bool {
        if identifier == "saveFromAdd" {
            taskTitle.resignFirstResponder()
            
            if (taskTitle.text.isEmpty) {
                println("EMPTY")
                // Show a popup alert!
                let emptyTextFieldAlertView = SCLAlertView()
                
                // The ok button
                emptyTextFieldAlertView.addButton("Ok") {
                    
                    // Closes the alertView
                    emptyTextFieldAlertView.close()
                
                    self.taskTitle.becomeFirstResponder()
                }
                
                // This is what the type of popup the alert will show
                emptyTextFieldAlertView.showError("No Text", subTitle: "Please Enter Text In The Field")
                
                return false
                
            } else {
                newTask = Task()
                saveNewTask()
                
                
                
                return true
            }
        }
        return true
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if segue.identifier == "setDate" {
            let targetVC = segue.destinationViewController as! CalendarViewController
            targetVC.addButtonColor = self.addButtonColor
        } else if segue.identifier == "exitFromAdd" {
            println("exitFromAdd")
        }

    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        taskTitle.placeholder = "Task Title here..."
        taskTitle.delegate = self
        taskTitle.returnKeyType = UIReturnKeyType.Done
        date.text = "Set Date"
        calendarDateLabel.text = ""

        // Initializes the navigation buttons
        let leftNavigation = self.navigationItem.leftBarButtonItem
        let rightNavigation = self.navigationItem.rightBarButtonItem
        
        if (addButtonColor == "") {
            leftNavigation?.tintColor = UIColor.whiteColor()
            rightNavigation?.tintColor = UIColor.whiteColor()
        }
    }
    
    override func viewWillAppear(animated: Bool) {

        if (keyboardPopUp == true) {
            taskTitle.becomeFirstResponder()
        } else {
            println("Keyboard not showing!")
        }
    }
    
    //Called when 'return' key pressed. return NO to ignore.
    func textFieldShouldReturn(textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
    
    // Hides keyboard whenever you tap outside the keyboard
    override func touchesBegan(touches: Set<NSObject>, withEvent event: UIEvent) {
        self.view.endEditing(true)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func viewWillDisappear(animated: Bool) {
    }
}
