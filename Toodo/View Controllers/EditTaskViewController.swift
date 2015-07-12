//
//  EditTaskViewController.swift
//  Toodo
//
//  Created by Reginald Suh on 2015-07-10.
//  Copyright (c) 2015 ReginaldSuh. All rights reserved.
//

import UIKit

class EditTaskViewController: UIViewController {

    var editTask: Task?
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        
        // Create a new edited task
        editTask = Task()
        editTask!.taskTitle = "Edited task"
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
}
