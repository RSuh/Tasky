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

    @IBOutlet weak var badgeImage: UIImageView!
    @IBOutlet weak var taskTextField: UITextView! = nil
   
    
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
    
    func saveTask() {
        if let editedTask = editedTask {
            let realm = Realm()
            realm.write() {
                if (editedTask.taskTitle != self.taskTextField.text) {
                    editedTask.taskTitle = self.taskTextField.text
                    editedTask.modificationDate = NSDate()
                }
            }
        }
    }
    // Hides keyboard when you press done
    func textFieldShouldReturn(textField: UITextField) -> Bool {
        taskTextField.resignFirstResponder()
        return true
    }
    
    // Hides keyboard whenever you tap outside the keyboard
    override func touchesBegan(touches: Set<NSObject>, withEvent event: UIEvent) {
        self.view.endEditing(true)
    }
    
    override func viewWillDisappear(animated: Bool) {
        super.viewWillDisappear(animated)
        
        // Calls save task which saves the task from the edit section
        saveTask()
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        
        // Calls displayTask when the VC is about to appear
        displayTask(self.editedTask)
        
        taskTextField.returnKeyType = UIReturnKeyType.Default
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        //displayTask(editedTask)
        //taskTextField.attributedText = "What's your task?" as NSAttributedString!
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

