//
//  AddNewTaskViewController.swift
//  Toodo
//
//  Created by Reginald Suh on 2015-07-17.
//  Copyright (c) 2015 ReginaldSuh. All rights reserved.
//

import Foundation
import UIKit
import RealmSwift

class AddNewTaskViewController: UIViewController, UICollectionViewDelegate, UICollectionViewDataSource, UITextFieldDelegate {
    
    @IBOutlet weak var taskTitle: UITextField!
    @IBOutlet weak var badgeImage: UICollectionView!
    @IBOutlet weak var taskNote: UITextView!
    
    // Initialize Realm
    let realm = Realm()
    
    // Var to control the image
    var badge = 0
    
    var category: Category?
    
    var newTask: Task? {
        didSet {
            displayNewTask(newTask)
            displayNewBadge(newTask)
        }
    }
    
    // Displays the contents of the new task
    func displayNewTask(task: Task?) {
        if let task = task, taskTitle = taskTitle, taskNote = taskNote {
            realm.write() {
                task.taskTitle = self.newTask!.taskTitle
                task.taskNote = self.newTask!.taskNote
            }
        }
    }
    
    
    // Displays the badge of the new task
    func displayNewBadge(task: Task?) {
        if let task = task, badgeImage = badgeImage {
            realm.write() {
                task.badge = self.newTask!.badge
            }
        }
    }
    
    // Saves the new task
    func saveNewTask() {
        if let newTask = newTask {
            realm.write() {
                if ((newTask.taskTitle != self.taskTitle.text) ||
                    (newTask.taskNote != self.taskNote.text) ||
                    (newTask.badge != self.badge)) {
                        newTask.taskTitle = self.taskTitle.text
                        newTask.taskNote = self.taskNote.text
                        newTask.badge = self.badge
                        self.category!.tasksWithinCategory.append(newTask)
                        self.category!.taskCount = self.category!.tasksWithinCategory.count
//                        println("Changes saved!")
                } else {
                    println("nothing has changed")
                }
            }
        }
    }
    
    func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return arrayConstants.cellImagesUnselected.count
    }
    
    func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCellWithReuseIdentifier("badgeImage", forIndexPath: indexPath) as! CategoryCollectionViewCell
        cell.chooseBadgeImage.image = UIImage(named: arrayConstants.cellImagesUnselected[indexPath.row])
        return cell
    }
    
    func collectionView(collectionView: UICollectionView, didSelectItemAtIndexPath indexPath: NSIndexPath) {
        println("You have selected cell \(indexPath.row)")
        badge = indexPath.row
        let cell = collectionView.cellForItemAtIndexPath(indexPath) as! CategoryCollectionViewCell
        cell.chooseBadgeImage.image = UIImage(named: "badgeFinance")
    }
    
    func collectionView(collectionView: UICollectionView, didDeselectItemAtIndexPath indexPath: NSIndexPath) {
        let cell = collectionView.cellForItemAtIndexPath(indexPath) as! CategoryCollectionViewCell
        
        cell.backgroundColor = UIColor.clearColor()
        
        (collectionView.cellForItemAtIndexPath(indexPath) as! CategoryCollectionViewCell).chooseBadgeImage.image = UIImage(named: arrayConstants.cellImagesUnselected[indexPath.row])
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        let realm = Realm()
        newTask = Task()
        saveNewTask()
        println(self.category!.taskCount)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        taskTitle.placeholder = "Task Title here..."
        // Do any additional setup after loading the view.
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func viewWillDisappear(animated: Bool) {
    }
}
