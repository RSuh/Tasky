//
//  NewTaskViewController.swift
//  Toodo
//
//  Created by Reginald Suh on 2015-07-10.
//  Copyright (c) 2015 ReginaldSuh. All rights reserved.
//

import UIKit
import RealmSwift

class AddNewListViewController: UIViewController {
    
    @IBOutlet weak var listTitle: UITextField!
    
    var addNewList: List? {
        didSet {
            displayNewList(addNewList)
        }
    }
    
    func displayNewList(list: List?) {
        if let list = list, listTitle = listTitle {
            addNewList!.listTitle = list.listTitle
        }
    }
    
    // Saves the task
    func saveList() {
        if let addNewList = addNewList {
            let realm = Realm()
            realm.write() {
                if (addNewList.listTitle != self.listTitle.text) {
                    addNewList.listTitle = self.listTitle.text
                    println("changes are saved")
                } else {
                    println("nothing to save")
                }
            }
        }
    }
    
    // Passing list object to Home View Controller
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        let realm = Realm()
        addNewList = List()
        println("list is created")
        saveList()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Placeholder text for textfield in Add
        listTitle.placeholder = "Title of your Category..."
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
}
