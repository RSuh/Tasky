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
    
    //@IBOutlet weak var dateLabel: UILabel!
    @IBOutlet weak var calendar: FSCalendar!
    @IBOutlet weak var datePicker: UIDatePicker!
    
    var addButtonColor = ""
    var orderingDate: NSDate?
    var numberDate = ""
    var dateString = ""
    var dateTime = ""
    var datePickerDate: NSDate?
    var calendarDate: NSDate?
    var calendarComponents: NSDateComponents?
    var timeComponents: NSDateComponents?
    
    // Gets todays date
    var todayDate = NSDate()
    var todayComponents: NSDateComponents?
    
    @IBAction func datePickerAction(sender: AnyObject) {
        
        // Enables the save
        let rightNavigation = self.navigationItem.rightBarButtonItem
        rightNavigation?.enabled = true
        
        var dateFormatter = NSDateFormatter()
        
        //dateFormatter.dateFormat = "MMM dd 'at' h:mm a"
        //dateFormatter.dateFormat = "h:mm a"
        
        dateFormatter.timeStyle = .ShortStyle
        
        // This shows the label on the previous VC
        var dateFromDatePicker = dateFormatter.stringFromDate(datePicker.date)
        self.dateTime = dateFromDatePicker
        
        // Datepicker.date is a NSDATE
        //        println(datePicker.timeZone)
        
        
        
        //        /self.dateTime = dateFormatter.
        //println("This is the time from datepicker \(dateFromDatePicker)")
        
        // This gets the components of the NSDate
        let requiredTimeComponents: NSCalendarUnit = .CalendarUnitHour | .CalendarUnitMinute
        
        // This gets the components from the NSDate
        let timeComponents = NSCalendar.currentCalendar().components(requiredTimeComponents, fromDate: datePicker.date)
        self.timeComponents = timeComponents
        //println("This is time \(timeComponents)")
        
        let strippedTime = NSCalendar.currentCalendar().dateFromComponents(timeComponents)
        
        // This is the string of the correct time for notification
        //self.dateTime = dateFormatter.stringFromDate(strippedTime!)
        
        // Sets the datePickerdate to be the strippedtime date.
        self.datePickerDate = strippedTime
        
        //println("This is dateTime \(dateTime)")
        //        orderingDate = dateFormatter.dateFromString(dateString + dateTime)
        //        println(self.dateTime)
        //        println("ORDERING DATE \(orderingDate)")
        
        
        // SEE HOW TO GET CURRENT DATE ON DATESTRING
        
    }
    
    override func viewWillAppear(animated: Bool) {
        //println(addButtonColor)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        
        // On load, the dateLabel is nothing
        //dateLabel.text = ""
        
        // Makes the calendar vertical flow
        calendar.flow = .Vertical
        
        // Initializes the navigation buttons
        let leftNavigation = self.navigationItem.leftBarButtonItem
        let rightNavigation = self.navigationItem.rightBarButtonItem
        
        // Disables the save button if the user doesnt input anything
        rightNavigation?.enabled = false
        
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
        if segue.identifier == "saveFromCalendar" {
            if segue.destinationViewController is AddNewTaskViewController {
                let targetVC = segue.destinationViewController as! AddNewTaskViewController
                
                // Gets the day components for todays Date
                var todayDateComponents: NSCalendarUnit = .CalendarUnitYear | .CalendarUnitMonth | .CalendarUnitDay
                let todayComponents = NSCalendar.currentCalendar().components(todayDateComponents, fromDate: todayDate)
                
//                var todayTimeComponents: NSCalendarUnit = .CalendarUnitHour | .CalendarUnitMinute
//                let todayTimeComponents = NSCalendar.currentCalendar().component(todayTimeComponents, fromDate: todayDate)

                // Sets the dateLabel of AddNewTaskViewController to be the date the user selected
                //targetVC.dateLabel = self.dateString
                
                // Pass the ordering date to AddNewTaskViewController
                targetVC.orderingDate = self.orderingDate
                targetVC.numDateLabel = self.numberDate
                
                // Sets the datestring as the long date
                if (dateString == "") {
                    targetVC.dateLabel = "Today at " + dateTime
                } else if (dateTime == "") {
                    targetVC.dateLabel = dateString + " at 9:00 a.m"
                } else {
                    targetVC.dateLabel = dateString + " at " + dateTime
                }
                
                //println(dateString + " " + dateTime)
                
                var fullNotificationDate: NSDateComponents = NSDateComponents()
                println("full notification date \(fullNotificationDate)")
                fullNotificationDate.timeZone = NSTimeZone.defaultTimeZone()
                
                // If no time is set, set it to be 9:00 am on the day of
                if ((timeComponents?.hour == nil) && (timeComponents?.minute == nil)) {
                    
                    // Sets the hour and minute to be 9:00 AM
                    fullNotificationDate.hour = 9
                    fullNotificationDate.minute = 0
                    println("fullnotificationdate hour \(fullNotificationDate.hour)")
                    println("fullnotification minute \(fullNotificationDate.minute)")
                    
                } else if ((calendarComponents?.day != nil) && (calendarComponents?.month != nil) && (calendarComponents?.year != nil)) {
                    fullNotificationDate.day = calendarComponents!.day
                    fullNotificationDate.month = calendarComponents!.month
                    fullNotificationDate.year = calendarComponents!.year
                } else {
                    // Since we are adding a new date, set the day, month, year to be todays date if no date if specified
                    fullNotificationDate.day = todayComponents.day
                    fullNotificationDate.month = todayComponents.month
                    fullNotificationDate.year = todayComponents.year
                    // Time is still set the same
                    fullNotificationDate.hour = timeComponents!.hour
                    fullNotificationDate.minute = timeComponents!.minute
                    println("time components \(timeComponents)")
                }
                
                
                // This is the date that the push notification should go off
                self.orderingDate = NSCalendar.currentCalendar().dateFromComponents(fullNotificationDate)
                
                // Sets the orderingDate in AddnewtaskVC to be self.orderingdate
                targetVC.orderingDate = self.orderingDate
                
                //                println(fullNotificationDate)
                
                // This shows the notification if app is in background or lock screen is present
                // Schedule the notification
                //                var localNotification: UILocalNotification = UILocalNotification()
                //                localNotification.fireDate = self.orderingDate
                //                localNotification.alertBody = "HI"
                //                localNotification.alertAction = "Show me the item"
                //                localNotification.timeZone = NSTimeZone.localTimeZone()
                //                localNotification.soundName = UILocalNotificationDefaultSoundName
                //                localNotification.alertLaunchImage = "badgeHome"
                //                println("local notification \(localNotification)")
                //                localNotification.applicationIconBadgeNumber = UIApplication.sharedApplication().applicationIconBadgeNumber + 1
                ////                UIApplication.sharedApplication().scheduleLocalNotification(localNotification)
                ////                NSNotificationCenter.defaultCenter().postNotificationName("reloadData", object: self)
                //
                //                targetVC.localNotification = localNotification
                
            } else if segue.destinationViewController is EditTaskViewController {
                let targetVC = segue.destinationViewController as! EditTaskViewController
                
                // Set the date of EditTaskViewController to be the dateString the user selected
                //targetVC.date = self.dateString
                
                // Gets the day components for todays Date
                var todayDateComponents: NSCalendarUnit = .CalendarUnitYear | .CalendarUnitMonth | .CalendarUnitDay
                let todayComponents = NSCalendar.currentCalendar().components(todayDateComponents, fromDate: todayDate)
                
                targetVC.numDateLabel = self.numberDate
                //
                //                if (dateString == "" && dateTime != "") {
                //                    targetVC.date = dateString + " at " + dateTime
                //                }
                //                if (dateTime == "") {
                //                    targetVC.date = dateString
                //                }
                //
                
                if (dateString == "") {
                    targetVC.date = dateTime
                } else if (dateTime == "") {
                    targetVC.date = dateString
                } else {
                    targetVC.date = dateString + " at " + dateTime
                }
                
                println(dateString + " " + dateTime)
                
                // Sets the date for the notification to be run when a user saves from edit.
                var editNotificationDate: NSDateComponents = NSDateComponents()
                //                println(editNotificationDate)
                editNotificationDate.timeZone = NSTimeZone.defaultTimeZone()
                
                // If no time is set, set it to be 9:00 am on the day of
                if ((timeComponents?.hour == nil) && (timeComponents?.minute == nil)) {
                    
                    // Sets the hour and minute to be 9:00 AM
                    editNotificationDate.hour = 9
                    editNotificationDate.minute = 0
                 
                } else if ((calendarComponents?.day != nil) && (calendarComponents?.month != nil) && (calendarComponents?.year != nil)) {
                    editNotificationDate.day = calendarComponents!.day
                    editNotificationDate.month = calendarComponents!.month
                    editNotificationDate.year = calendarComponents!.year
                } else {
                
                editNotificationDate.day = todayComponents.day
                editNotificationDate.month = todayComponents.month
                editNotificationDate.year = todayComponents.year
                editNotificationDate.hour = timeComponents!.hour
                editNotificationDate.minute = timeComponents!.minute
                }
                // This is the date that the push notification should go off
                self.orderingDate = NSCalendar.currentCalendar().dateFromComponents(editNotificationDate)
                
                // Sets the orderingDate in AddnewtaskVC to be self.orderingdate
                targetVC.orderingDate = self.orderingDate
                
            }
            
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
            
        }
    }
}

extension CalendarViewController: FSCalendarDataSource {
    
}

extension CalendarViewController: FSCalendarDelegate {
    // What happens when the user selects the date
    func calendar(calendar: FSCalendar!, didSelectDate date: NSDate!) {
        
        // Enables the save
        let rightNavigation = self.navigationItem.rightBarButtonItem
        rightNavigation?.enabled = true
        
        // Gets rid of todays circle
        calendar.appearance.todayColor = UIColor.clearColor()
        calendar.appearance.titleTodayColor = calendar.appearance.titleDefaultColor;
        calendar.appearance.subtitleTodayColor = calendar.appearance.subtitleDefaultColor;
        
        var numDateFormat = NSDateFormatter()
        var dateFormatter = NSDateFormatter()
        // if date is tomorrow, then display, due tomorrow, else display the date.
        
        // Sets the dateFormat for both the dates
        dateFormatter.dateFormat = "EEE, MMM d"
        numDateFormat.dateFormat = "dd"
        
        // This is the actual date
        var dateString = dateFormatter.stringFromDate(date)
        //self.dateLabel.text = "Due: \(dateString)"
        
        // The number of the date
        var numberDate = numDateFormat.stringFromDate(date)
        //var numberDate = dateString.substringFromIndex(advance(dateString.startIndex, 20))
        
        // Takes the date we selected and assign the number
        self.numberDate = numberDate
        
        // Sets the dateString to be the date you selected
        self.dateString = dateString
        println("datestring \(dateString)")
        //        println("This is dateString \(dateString)")
        
        // Set the notification date to be the NSDate that we selected
        //        println(date)
        
        //self.orderingDate = date
        //        println(self.orderingDate)
        
        // Stripping the date from the NSDate, this gets the first portion of the NSDate.
        let requiredDateComponents: NSCalendarUnit = .CalendarUnitYear | .CalendarUnitMonth | .CalendarUnitDay
        
        // gives componenets from requiredDate componenets from the NSDate
        // Ordering date is the NSDate variable that we can move around
        let components = NSCalendar.currentCalendar().components(requiredDateComponents, fromDate: date)
        self.calendarComponents = components
        //println(components)
        
        //        println(calendarComponents?.day)
        //        println(calendarComponents?.month)
        //        
        // Set the strippedCalendarDate to be the NSDate
        let strippedCalendarDate = NSCalendar.currentCalendar().dateFromComponents(components)
        
        self.calendarDate = strippedCalendarDate
        
        //self.calendarDate = strippedCalendarDate
        println("strippedCalendarDate \(strippedCalendarDate)")
    }
}
