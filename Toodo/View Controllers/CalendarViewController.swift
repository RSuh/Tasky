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
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
//        var date = NSDate()
//        var dateFormatter = NSDateFormatter()
//        dateFormatter.dateFormat = "EEEE, MMMM d"
//        
//        var todaysDate = dateFormatter.stringFromDate(date)
        
        dateLabel.text = "Due Today"
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
