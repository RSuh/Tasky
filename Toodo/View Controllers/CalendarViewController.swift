//
//  CalendarViewController.swift
//  Toodo
//
//  Created by Reginald Suh on 2015-07-29.
//  Copyright (c) 2015 ReginaldSuh. All rights reserved.
//

import UIKit
import FSCalendar
import RealmSwift

class CalendarViewController: UIViewController {

    let realm = Realm()
    
    @IBOutlet weak var dateLabel: UILabel!
    @IBOutlet weak var calendar: FSCalendar!
    
    var addButtonColor = ""
    var notificationDate: NSDate?
    var orderingDate: NSDate?
    var numberDate = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // On load, the dateLabel is nothing
        dateLabel.text = ""
        
        // Makes the calendar vertical flow
        calendar.flow = .Vertical
        
        // Initializes the navigation buttons
        let leftNavigation = self.navigationItem.leftBarButtonItem
        let rightNavigation = self.navigationItem.rightBarButtonItem
    
        if (addButtonColor == "") {
            rightNavigation?.tintColor = UIColor.whiteColor()
            leftNavigation?.tintColor = UIColor.whiteColor()
        }
        
        if (addButtonColor == "addPurple") {
                        // Changes the calendar to purple color
            calendar.appearance.weekdayTextColor = UIColor(red:0.81, green:0.59, blue:0.93, alpha:1.0)
            calendar.appearance.headerTitleColor = UIColor(red:0.81, green:0.59, blue:0.93, alpha:1.0)
            
            // Changes the calendar color to theme color for selection
            //            calendar.appearance.todayColor = UIColor(red:0.81, green:0.59, blue:0.93, alpha:1.0)
            calendar.appearance.selectionColor = UIColor(red:0.81, green:0.59, blue:0.93, alpha:1.0)
            
        } else if (addButtonColor == "addTurquoise") {
            
            
            // Changes the calendar to turquoise color
            calendar.appearance.weekdayTextColor = UIColor(red:0.15, green:0.85, blue:0.70, alpha:1.0)
            calendar.appearance.headerTitleColor = UIColor(red:0.15, green:0.85, blue:0.70, alpha:1.0)
            
            // Changes the calendar color to theme color for selection
            calendar.appearance.selectionColor = UIColor(red:0.15, green:0.85, blue:0.70, alpha:1.0)
        } else if (addButtonColor == "addRed") {
            
            
            // Changes the calendar to red color
            calendar.appearance.weekdayTextColor = UIColor(red:1.00, green:0.45, blue:0.45, alpha:1.0)
            calendar.appearance.headerTitleColor = UIColor(red:1.00, green:0.45, blue:0.45, alpha:1.0)
            
            // Changes the calendar color to theme color for selection
            calendar.appearance.selectionColor = UIColor(red:1.00, green:0.45, blue:0.45, alpha:1.0)
        } else if (addButtonColor == "addBlue") {
            
            
            // Changes the calendar to blue color
            calendar.appearance.weekdayTextColor = UIColor(red:0.40, green:0.60, blue:1.00, alpha:1.0)
            calendar.appearance.headerTitleColor = UIColor(red:0.40, green:0.60, blue:1.00, alpha:1.0)
            
            // Changes the calendar color to theme color for selection
            calendar.appearance.selectionColor = UIColor(red:0.40, green:0.60, blue:1.00, alpha:1.0)
        } else {
            
            
            // Changes the calendar to dark, default color
            calendar.appearance.weekdayTextColor = UIColor(red:0.23, green:0.26, blue:0.33, alpha:1.0)
            calendar.appearance.headerTitleColor = UIColor(red:0.23, green:0.26, blue:0.33, alpha:1.0)
            
            // Changes the calendar color to theme color for selection
            calendar.appearance.selectionColor = UIColor(red:0.23, green:0.26, blue:0.33, alpha:1.0)
        }

    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if segue.identifier == "saveFromAddCalendar" {
            
            let targetVC = segue.destinationViewController as! AddNewTaskViewController
            
            targetVC.dateLabel = self.dateLabel.text!
            
            // Pass the ordering date to ADDNEWTASKVIEWCONTROLLER
            targetVC.orderingDate = self.orderingDate
            targetVC.numDateLabel = self.numberDate
            targetVC.notificationDate = self.notificationDate
            
//            let requiredDateComponents: NSCalendarUnit = .CalendarUnitYear | .CalendarUnitMonth | .CalendarUnitDay
//            
//            let components = NSCalendar.currentCalendar().components(requiredDateComponents, fromDate: notificationDate!)
//            
//            let strippedDate = NSCalendar.currentCalendar().dateFromComponents(components)
//            
//            self.realm.write() {
//            // Sets the notification date of newTask to be strippedDate
//                targetVC.newTask?.notificationDate = strippedDate!
//            }
//            
//            var localNotification: UILocalNotification = UILocalNotification()
//            localNotification.alertTitle = targetVC.newTask?.taskTitle
//            localNotification.fireDate = targetVC.newTask?.notificationDate
//            localNotification.userInfo = ["editTask": "\(targetVC.newTask?.taskTitle)"]
//            UIApplication.sharedApplication().scheduleLocalNotification(localNotification)
            
        } else {
            println("date was not saved")
        }
    }
}

extension CalendarViewController: FSCalendarDataSource {
    
}

extension CalendarViewController: FSCalendarDelegate {
    // What happens when the user selects the date
    func calendar(calendar: FSCalendar!, didSelectDate date: NSDate!) {
        
        // Gets rid of todays circle
        calendar.appearance.todayColor = UIColor.clearColor()
        calendar.appearance.titleTodayColor = calendar.appearance.titleDefaultColor;
        calendar.appearance.subtitleTodayColor = calendar.appearance.subtitleDefaultColor;
        
        var numDateFormat = NSDateFormatter()
        var dateFormatter = NSDateFormatter()
        // if date is tomorrow, then display, due tomorrow, else display the date.
        
        
        // If date is today, then display, due today, else display the date
        dateFormatter.dateFormat = "EEEE, MMMM d"
        numDateFormat.dateFormat = "d"
        var dateString = dateFormatter.stringFromDate(date)
        self.dateLabel.text = "Due: \(dateString)"
        
        var numberDate = numDateFormat.stringFromDate(date)
        //var numberDate = dateString.substringFromIndex(advance(dateString.startIndex, 20))
       
        // Takes the date we selected and assigns it to orderingDate
        self.orderingDate = date
        self.numberDate = numberDate
        
        // Set the notification date to be the NSDate that we selected
        notificationDate = date
        println(notificationDate)
    }
}
