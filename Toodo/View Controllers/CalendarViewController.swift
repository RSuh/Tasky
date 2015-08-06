//
//  CalendarViewController.swift
//  Toodo
//
//  Created by Reginald Suh on 2015-07-29.
//  Copyright (c) 2015 ReginaldSuh. All rights reserved.
//

import UIKit
import FSCalendar

class CalendarViewController: UIViewController {

    @IBOutlet weak var dateLabel: UILabel!
    @IBOutlet weak var calendar: FSCalendar!
    
    var addButtonColor = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Makes the calendar vertical flow
        calendar.flow = .Vertical
        
        //calendar.appearance.autoAdjustTitleSize = false
        //calendar.appearance.titleFont = UIFont(name: "HelveticaNeue-UltraLight", size: 11.0)
        
        let todayDate = NSDate()
    
        var dateFormatter = NSDateFormatter()
        // if date is tomorrow, then display, due tomorrow, else display the date.
        
        // If date is today, then display, due today, else display the date
        dateFormatter.dateFormat = "EEEE, MMMM d"
        var dateString = dateFormatter.stringFromDate(todayDate)
        self.dateLabel.text = "Due: \(dateString)"

        
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
        var dateFormatter = NSDateFormatter()
        // if date is tomorrow, then display, due tomorrow, else display the date.
        
        // If date is today, then display, due today, else display the date
        dateFormatter.dateFormat = "EEEE, MMMM d"
        var dateString = dateFormatter.stringFromDate(date)
        self.dateLabel.text = "Due: \(dateString)"
    }
}
