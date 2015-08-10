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
import FSCalendar

class EditTaskViewController: UIViewController, UITextFieldDelegate, UITextViewDelegate {
    
    @IBOutlet weak var badgeImage: UIImageView!
    @IBOutlet weak var taskTextField: UITextView!
    @IBOutlet weak var dateLabel: UITextField!
    @IBOutlet weak var editImage: UIImageView!
    @IBOutlet weak var calendar: FSCalendar!
    
    // Initialize realm
    let realm = Realm()
    
    var badge = 0
    var showSelectedDate: NSDate?
    var addButtonColor: String = ""
    var editButtonImage: String = ""
    
    var editedTask: Task? {
        didSet {
            displayTask(editedTask)
            displayBadge(editedTask)
            displayDate(editedTask)
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
            }
        }
    }
    
    // Displays the date
    func displayDate(task: Task?) {
        if let task = task, dateLabel = dateLabel {
            realm.write() {
                self.dateLabel.text = self.editedTask!.modificationDate
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
                    (editedTask.modificationDate != self.dateLabel.text)){
                        editedTask.modificationDate = self.dateLabel.text!
                        editedTask.taskTitle = self.taskTextField.text
                        
                        // Saves the badge as the editedTask.badge passed from TaskVC
                        editedTask.badge = self.editedTask!.badge
                } else {
                    println("nothing has changed")
                }
            }
        }
    }
    
    @IBAction func selectDateAction(sender: AnyObject) {
        
        var dateFormatter = NSDateFormatter()
        dateFormatter.dateFormat = "EEEE, MMMM d"
        
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
            let target = segue.destinationViewController as! TaskViewController
            //target.showSelectedDate = self.showSelectedDate
            println("show selected date is \(target.showSelectedDate)")
            saveTask()
            
        } else if (segue.identifier == "tapOnBadge") {
            let targetVC = segue.destinationViewController as! ChangeBadgeViewController
            targetVC.addButtonColor = self.addButtonColor
        }
    }
    
    // Hides keyboard when you press done the view controller ends
    func textFieldShouldReturn(textField: UITextField) -> Bool {
        taskTextField.resignFirstResponder()
        return true
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // println(self.editedTask!.modificationDate)
        // Checks to see if the due date is empty
        
        //calendar.selectedDate = showSelectedDate
        
        // Set delegate for uitextview
        taskTextField.delegate = self
        
        
        
        // Changes the calendar flow to vertical
        calendar.flow = .Vertical
        
        //taskTextField.delegate = self
        taskTextField.returnKeyType = UIReturnKeyType.Default
        
        // Initializes the navigation buttons
        let leftNavigation = self.navigationItem.leftBarButtonItem
        let rightNavigation = self.navigationItem.rightBarButtonItem
        
        // Colors the nav bar items
        leftNavigation
        
        if (addButtonColor == "") {
            leftNavigation?.tintColor = UIColor.whiteColor()
            rightNavigation?.tintColor = UIColor.whiteColor()
        }
        
        if (editButtonImage == "addPurple") {
            editImage.image = UIImage(named: "editPurple")
            // Changes the calendar to purple color
            calendar.appearance.weekdayTextColor = UIColor(red:0.81, green:0.59, blue:0.93, alpha:1.0)
            calendar.appearance.headerTitleColor = UIColor(red:0.81, green:0.59, blue:0.93, alpha:1.0)
            
            // Changes the calendar color to theme color for selection
//            calendar.appearance.todayColor = UIColor(red:0.81, green:0.59, blue:0.93, alpha:1.0)
            calendar.appearance.selectionColor = UIColor(red:0.81, green:0.59, blue:0.93, alpha:1.0)
            
        } else if (editButtonImage == "addTurquoise") {
            editImage.image = UIImage(named: "editTurquoise")
            
            // Changes the calendar to turquoise color
            calendar.appearance.weekdayTextColor = UIColor(red:0.15, green:0.85, blue:0.70, alpha:1.0)
            calendar.appearance.headerTitleColor = UIColor(red:0.15, green:0.85, blue:0.70, alpha:1.0)
            
            // Changes the calendar color to theme color for selection
            calendar.appearance.selectionColor = UIColor(red:0.15, green:0.85, blue:0.70, alpha:1.0)
        } else if (editButtonImage == "addRed") {
            editImage.image = UIImage(named: "editRed")
            
            // Changes the calendar to red color
            calendar.appearance.weekdayTextColor = UIColor(red:1.00, green:0.45, blue:0.45, alpha:1.0)
            calendar.appearance.headerTitleColor = UIColor(red:1.00, green:0.45, blue:0.45, alpha:1.0)
            
            // Changes the calendar color to theme color for selection
            calendar.appearance.selectionColor = UIColor(red:1.00, green:0.45, blue:0.45, alpha:1.0)
        } else if (editButtonImage == "addBlue") {
            editImage.image = UIImage(named: "editBlue")
            
            // Changes the calendar to blue color
            calendar.appearance.weekdayTextColor = UIColor(red:0.40, green:0.60, blue:1.00, alpha:1.0)
            calendar.appearance.headerTitleColor = UIColor(red:0.40, green:0.60, blue:1.00, alpha:1.0)
            
            // Changes the calendar color to theme color for selection
            calendar.appearance.selectionColor = UIColor(red:0.40, green:0.60, blue:1.00, alpha:1.0)
        } else {
            editImage.image = UIImage(named: "editDark")
            
            // Changes the calendar to dark, default color
            calendar.appearance.weekdayTextColor = UIColor(red:0.23, green:0.26, blue:0.33, alpha:1.0)
            calendar.appearance.headerTitleColor = UIColor(red:0.23, green:0.26, blue:0.33, alpha:1.0)
            
            // Changes the calendar color to theme color for selection
            calendar.appearance.selectionColor = UIColor(red:0.23, green:0.26, blue:0.33, alpha:1.0)
        }
        
        println(editButtonImage)
        
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
    
    override func viewDidAppear(animated: Bool) {
        if (self.editedTask!.modificationDate == "") {
            println("no mod date!")
            
            // Sets label to no due date
            self.dateLabel.text = ""
        }
        
    
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        displayTask(editedTask)
        displayBadge(editedTask)
        displayDate(editedTask)
        
        // keyboard pops up right away
        //taskTextField.becomeFirstResponder()
        
        // Displays the badge image of the selectedTask
        badgeImage.image = UIImage(named: arrayConstants.cellImagesUnselected[editedTask!.badge])
    }
}

extension EditTaskViewController: FSCalendarDataSource {
    
    
    //    func calendar(calendar: FSCalendar!, hasEventForDate date: NSDate!) -> Bool {
    //        return true
    //    }
    
}

extension EditTaskViewController: FSCalendarDelegate {
    
    func calendarCurrentMonthDidChange(calendar: FSCalendar!) {
        
        // If the calendar changes month, then hide textfield
        taskTextField.resignFirstResponder()
    
    }
    
    
    func tomorrowFlag() {
        var tomorrowFlag: Bool = true
        
        //        if (self.dateLabel.text == "Tomorrow") {
        //            tomorrowFlag = false
        //            tomorrowInt = 1
        //        } else {
        //            tomorrowFlag = true
        //        }
        //
        //        if compareTodayDateString == comparePickedDateString {
        //            self.dateLabel.text = "Today"
        //        } else if tomorrowInt > todayInt && tomorrowFlag == true {
        //            self.dateLabel.text = "Tomorrow"
        //            tomorrowFlag = false
        //        }
        //
        //        if ((tomorrowInt > todayInt) && (tomorrowFlag == false)) {
        //            self.dateLabel.text = "Due \(dateString)"
        //        } else
        //    }
        
    }
    
    func calendar(calendar: FSCalendar!, didSelectDate date: NSDate!) {
        
        // Gets rid of todays date circle
        calendar.appearance.todayColor = UIColor.clearColor()
        calendar.appearance.titleTodayColor = calendar.appearance.titleDefaultColor;
        calendar.appearance.subtitleTodayColor = calendar.appearance.subtitleDefaultColor;
        
        // Hides the keyboard when a date is selected
        taskTextField.resignFirstResponder()
        
        var tomorrowFlag: Bool = true
        
        // date = the date which is picked and todays date is todays date
        let todaysDate = NSDate()
        
        // Sets the format for the date which is picked
        var dateFormatter = NSDateFormatter()
        var secondDateFormatter = NSDateFormatter()
        //dateFormatter.timeStyle = NSDateFormatterStyle.MediumStyle
        //dateFormatter.dateStyle = NSDateFormatterStyle.MediumStyle
        dateFormatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
        secondDateFormatter.dateFormat = "EEEE, MMMM dd"
        
        dateFormatter.timeZone = NSTimeZone.defaultTimeZone()
        
        // The proper date, but at 12:00:00 AM each day
        var dateString = secondDateFormatter.stringFromDate(date)
        var longDateString = dateFormatter.stringFromDate(date)
        // The local date plus correct time
        var localTimeDate = secondDateFormatter.stringFromDate(todaysDate)
        var longLocalTimeDate = dateFormatter.stringFromDate(todaysDate)
        // these var gets the string of the dates.
//        var pickedDateString = date.description
//        var todayDateString = localTimeDate
//
//        // Gives tomorrows date
//        var tomorrow = localTimeDate.dateByAddingTimeInterval(24 * 60 * 60)
//        var tomorrowDateString = tomorrow.description
//        //println(tomorrowDateString)
//        
//        // The date for today in string
        var compareTodayDateString = localTimeDate.substringToIndex(advance(localTimeDate.startIndex, 15))
//        //println(compareTodayDateString)
//        
//        // The date which has been picked in string
        var comparePickedDateString = dateString.substringToIndex(advance(dateString.startIndex, 15))
//        
//        // The date for tomorrow in string
//        var frontTomorrowDateString = tomorrowDateString.substringToIndex(advance(tomorrowDateString.startIndex, 10))
        
//        // string to NSDate
//        dateFormatter.dateFormat = "EEEE MMMM d, YYYY"
//        localTimeDate = dateFormatter.stringFromDate(date)
//        dateFormatter.release()
        var dateFromString = dateFormatter.dateFromString(longDateString)
        var todayDateFromString = dateFormatter.dateFromString(longLocalTimeDate)
        
        println(dateFromString!)
        println(todayDateFromString!)
        
        if (dateString == localTimeDate) {
            dateLabel.text = "Due Today"
            //showSelectedDate = todayDateFromString
            println(showSelectedDate)
        } else {
            dateLabel.text = "Due \(dateString)"
            //showSelectedDate = dateFromString
            println(showSelectedDate)
        }
    }
}
