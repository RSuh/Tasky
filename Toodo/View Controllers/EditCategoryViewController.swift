//
//  EditCategoryViewController.swift
//  Toodo
//
//  Created by Reginald Suh on 2015-07-17.
//  Copyright (c) 2015 ReginaldSuh. All rights reserved.
//

import UIKit
import RealmSwift
import Foundation

class EditCategoryViewController: UIViewController, UITextFieldDelegate {
    
    // Initialize realm
    let realm = Realm()
    
    @IBOutlet var categoryTitle: UITextField!
    
    // Counter for the image
    var badge = 0
    
    // The nav title for each category
    var categoryTitleForNavBar: String = ""
    
    var editedCategory: Category? {
        didSet {
            // didSet is called whenever editedCategory changes/ whenever editedCategory is stored
            // It calls displayCategory and displayBadge on the newly editedCategory
            displayCategory(editedCategory)
            displayBadge(editedCategory)
        }
    }
    
    // A function to update the text of the editedCategory by using realm.write()
    func displayCategory(category: Category?) {
        if let editedCategory = editedCategory, categoryTitle = categoryTitle {
            realm.write() {
                categoryTitle.text = self.editedCategory!.categoryTitle
            }
        }
    }
    
    // A function to update the badge of the editedCategory by using realm.write()
    func displayBadge(category: Category?) {
        if let category = category, editedCategory = editedCategory {
            realm.write() {
                category.badge = self.editedCategory!.badge
            }
        }
    }
    
    // Saves the category
    func saveCategory() {
        if let editedCategory = editedCategory {
            realm.write() {
                if ((self.editedCategory!.categoryTitle != self.categoryTitle.text) || (self.editedCategory!.badge != self.badge)) {
                    self.editedCategory!.categoryTitle = self.categoryTitle.text
                    self.editedCategory!.badge = self.badge
                } else {
                    println("Nothing was changed")
                }
            }
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
        // Shows the navigation bar
        self.navigationController?.navigationBarHidden = false
        //categoryTitle.borderStyle = UITextBorderStyle.None
        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func viewWillAppear(animated: Bool) {
        // Calls displayCategory on editedCategory
        displayCategory(editedCategory)
        displayBadge(editedCategory)
    }
    
    override func viewWillDisappear(animated: Bool) {
        super.viewWillDisappear(animated)
        
        // Saves before the view disappears
        saveCategory()
    }
    
    /*
    // MARK: - Navigation
    
    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
    // Get the new view controller using segue.destinationViewController.
    // Pass the selected object to the new view controller.
    }
    */
    
}
