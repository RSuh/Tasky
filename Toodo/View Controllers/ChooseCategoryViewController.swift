//
//  NewTaskViewController.swift
//  Toodo
//
//  Created by Reginald Suh on 2015-07-10.
//  Copyright (c) 2015 ReginaldSuh. All rights reserved.
//

import UIKit
import RealmSwift

class ChooseCategoryViewController: UIViewController {
    
    var newTask: Task?
    var newList: List?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        //        // Create a Task object
        //        newTask = Task()
        //        newTask!.taskTitle = "New Task"
        //
        
        // Create a new List object
        newList = List()
        newList?.listTitle = "New List"
        newList?.taskCount = 1
        //newList?.taskArray = ["hi"]
    }
}
