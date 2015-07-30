//
//  EditTaskViewController.swift
//  Toodo
//
//  Created by Reginald Suh on 2015-07-10.
//  Copyright (c) 2015 ReginaldSuh. All rights reserved.
//

import Foundation
import UIKit
import RealmSwift

class EditTaskViewController: UIViewController, UITextFieldDelegate {
    
    @IBOutlet weak var dateLabelInEdit: UILabel!
    @IBOutlet weak var datePicker: UIDatePicker!
    @IBOutlet weak var badgeImage: UIImageView!
    @IBOutlet weak var taskTextField: UITextField!
    @IBOutlet weak var taskNoteField: UITextView!
    //    @IBOutlet weak var reminderCell: UITableViewCell!
    
    // Initialize realm
    let realm = Realm()
    
    var badge = 0
    
    var editedTask: Task? {
        didSet {
            displayTask(editedTask)
            displayBadge(editedTask)
            
        }
    }
    
    // Displays the badge
    func displayBadge(task: Task?) {
        if let task = task, editedTask = editedTask {
            realm.write() {
                task.badge = self.editedTask!.badge
            }
        }
    }
    
    // Displays the task
    func displayTask(task: Task?) {
        if let task = task, taskTextField = taskTextField {
            realm.write() {
                self.taskTextField.text = self.editedTask!.taskTitle
                self.taskNoteField.text = self.editedTask!.taskNote
            }
        }
    }
    
    // Saves the task
    func saveTask() {
        if let editedTask = editedTask, taskTextField = taskTextField {
            println(editedTask.badge)
            realm.write() {
                if ((editedTask.taskTitle != self.taskTextField.text) ||
                    (editedTask.badge != self.badge) ||
                    (editedTask.taskNote != self.taskNoteField.text)) {
                        
                        editedTask.taskTitle = self.taskTextField.text
                        // Saves the badge as the editedTask.badge passed from TaskVC
                        editedTask.badge = self.editedTask!.badge
                        editedTask.taskNote = self.taskNoteField.text
                } else {
                    println("nothing has changed")
                }
            }
        }
    }
    
    @IBAction func selectDateAction(sender: AnyObject) {
        
        var dateFormatter = NSDateFormatter()
        dateFormatter.dateFormat = "EEEE, MMMM d"
        
        var labelStr = dateFormatter.stringFromDate(datePicker.date)
        self.dateLabelInEdit.text = labelStr
        
    }
    
    @IBAction func backToEditFromChangeBadge(segue: UIStoryboardSegue) {
        if let identifier = segue.identifier {
            switch identifier {
            case "exitFromChangeBadge":
                println("exit from change badge")
                
            case "saveFromChangeBadge":
                println("save from change badge")
                
                let badgeSaveVC = segue.sourceViewController as! ChangeBadgeViewController
                
                // Sets the new badge as the badge selected from ChangeBadgeVC
                realm.write() {
                    self.editedTask!.badge = badgeSaveVC.badge
                }
                
            default:
                println("failed")
            }
        }
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if (segue.identifier == "saveFromEdit") {
            saveTask()
        } else {
            println("task was not saved")
        }
    }
    
    // Hides keyboard when you press done the view controller ends
    func textFieldShouldReturn(textField: UITextField) -> Bool {
        //taskTextField.resignFirstResponder()
        return true
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
//        // Sets the date to today
//        var date = NSDate()
//        let selectedDate = NSDateFormatter()
//        selectedDate.dateFormat = "EEEE, MMMM d"
//        
//        // Sets the datepicker to today
//        datePicker.setDate(date, animated: true)
//        self.dateLabelInEdit.text = selectedDate.stringFromDate(date)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    // Hides keyboard whenever you tap outside the keyboard
    override func touchesBegan(touches: Set<NSObject>, withEvent event: UIEvent) {
        self.view.endEditing(true)
    }
    
    override func viewWillDisappear(animated: Bool) {
        super.viewWillDisappear(animated)
        
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        displayTask(editedTask)
        displayBadge(editedTask)
        
        // Displays the badge image of the selectedTask
        badgeImage.image = UIImage(named: arrayConstants.cellImagesUnselected[editedTask!.badge])
    }
}

extension EditTaskViewController: FSCalendarDataSource {
    
}

extension EditTaskViewController: FSCalendarDelegate {
    
}

