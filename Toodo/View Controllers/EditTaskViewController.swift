//
//  EditTaskViewController.swift
//  Toodo
//
//  Created by Reginald Suh on 2015-07-10.
//  Copyright (c) 2015 ReginaldSuh. All rights reserved.
//

import UIKit
import RealmSwift

class EditTaskViewController: UIViewController {

    @IBOutlet weak var badgeImage: UIImageView!
    @IBOutlet weak var taskTextField: UITextField!
    
    var editedTask: Task? {
        didSet {
            displayTask(editedTask)
        }
    }
    
    func displayTask(task: Task?) {
        if let task = task, taskTextField = taskTextField {
            taskTextField.text = editedTask!.taskTitle
            println(task)
        }
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        
        // Calls displayTask when the VC is about to appear
        displayTask(editedTask)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        //displayTask(editedTask)
        //taskTextField.placeholder = "What's your task?"
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
}

