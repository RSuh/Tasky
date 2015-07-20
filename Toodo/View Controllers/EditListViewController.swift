//
//  EditListViewController.swift
//  Toodo
//
//  Created by Reginald Suh on 2015-07-17.
//  Copyright (c) 2015 ReginaldSuh. All rights reserved.
//

import UIKit
import RealmSwift
import Foundation

class EditListViewController: UIViewController, UICollectionViewDataSource, UICollectionViewDelegate, UITextFieldDelegate {

    // Initialize realm
    let realm = Realm()
    
    @IBOutlet weak var listTitle: UITextField!
    
    // Counter for the image
    var badge = 0
    
    var editedList: List? {
        didSet {
            // didSet is called whenever editedList changes/ whenever editedList is stored
            // It calls displayList and displayBadge on the newly editedList
            displayList(editedList)
            displayBadge(editedList)
        }
    }
    
    // A function to update the text of the editedList by using realm.write()
    func displayList(list: List?) {
        if let editedList = editedList, list = list, listTitle = listTitle {
            realm.write() {
                listTitle.text = self.editedList!.listTitle
            }
        }
    }
    
    // A function to update the badge of the editedList by using realm.write()
    func displayBadge(list: List?) {
        if let list = list, editedList = editedList {
            realm.write() {
                list.badge = self.editedList!.badge
            }
        }
    }
    
    // Saves the task
    func saveList() {
        if let editedList = editedList {
            println(editedList)
            realm.write() {
                if ((editedList.listTitle != self.listTitle.text) || (editedList.badge != self.badge)) {
                    editedList.listTitle = self.listTitle.text
                    editedList.badge = self.badge
                } else {
                    println("Nothing was changed")
                }
            }
        }
    }
    
    // Passing image to ListViewController
    //    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
    //        let realm = Realm()
    //        editedList = List()
    //        editedList?.badge = self.badge
    //        //println("\(listTitle.text)")
    //    }
    
    func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return arrayConstants.cellImagesUnselected.count
    }
    
    func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCellWithReuseIdentifier("badgeImage", forIndexPath: indexPath) as! ListCollectionViewCell
        cell.chooseBadgeImage.image = UIImage(named: arrayConstants.cellImagesUnselected[indexPath.row])
        return cell
    }
    
    func collectionView(collectionView: UICollectionView, didSelectItemAtIndexPath indexPath: NSIndexPath) {
        //println("You have selected cell \(indexPath.row)")
        badge = indexPath.row
        //println(badge)
        let cell = collectionView.cellForItemAtIndexPath(indexPath) as! ListCollectionViewCell
        cell.chooseBadgeImage.image = UIImage(named: "badgeFinance")
    }
    
    func collectionView(collectionView: UICollectionView, didDeselectItemAtIndexPath indexPath: NSIndexPath) {
        let cell = collectionView.cellForItemAtIndexPath(indexPath) as! ListCollectionViewCell
        
        cell.backgroundColor = UIColor.clearColor()
        
        (collectionView.cellForItemAtIndexPath(indexPath) as! ListCollectionViewCell).chooseBadgeImage.image = UIImage(named: arrayConstants.cellImagesUnselected[indexPath.row])
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func viewWillAppear(animated: Bool) {
        // Calls displayList on editedList
        displayList(editedList)
        displayBadge(editedList)
        listTitle.delegate = self
    }
    
    override func viewWillDisappear(animated: Bool) {
        super.viewWillDisappear(animated)
        
        // Saves before the view disappears
        saveList()
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
