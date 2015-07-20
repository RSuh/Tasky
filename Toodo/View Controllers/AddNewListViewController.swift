//
//  NewTaskViewController.swift
//  Toodo
//
//  Created by Reginald Suh on 2015-07-10.
//  Copyright (c) 2015 ReginaldSuh. All rights reserved.
//

import UIKit
import RealmSwift

class AddNewListViewController: UIViewController, UICollectionViewDataSource, UICollectionViewDelegate {
    
    @IBOutlet weak var listTitle: UITextField! = nil
    
    var newTask: Task?
    var newList: List?
    var badge = 0
    
    var addNewList: List? {
        didSet {
            displayList(addNewList)
        }
    }
    
    func displayList(list: List?) {
        if let list = list, listTitle = listTitle {
            listTitle.text = addNewList!.listTitle
        }
    }
    
    // Saves the task
    func saveList() {
        if let addNewList = addNewList {
            let realm = Realm()
            realm.write() {
                if (addNewList.listTitle != self.listTitle.text) && (addNewList.badge != self.badge){
                    addNewList.listTitle = self.listTitle.text
                    addNewList.badge = self.badge
                } else {
                    println("nothing to save")
                }
            }
        }
    }
    
    
    // Passing image to Home View Controller
//    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
//        let realm = Realm()
//        newList = List()
//        newList?.listTitle = addNewList!.listTitle
//        newList?.badge = self.badge
    
        // Save this stuff for another day
        //        if (segue.identifier == "saveToList") {
        //            let targetViewCell = segue.destinationViewController as! ListViewController
        //
        //        } else if (segue.identifier == "editList") {
        //            let targetViewCell = segue.destinationViewController as! ListViewController
        //
        //
        //        }
    
    
    func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return arrayConstants.cellImagesUnselected.count
    }
    
    func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCellWithReuseIdentifier("badgeImage", forIndexPath: indexPath) as! ListCollectionViewCell
        cell.chooseBadgeImage.image = UIImage(named: arrayConstants.cellImagesUnselected[indexPath.row])
        return cell
    }
    
    func collectionView(collectionView: UICollectionView, didSelectItemAtIndexPath indexPath: NSIndexPath) {
        println("You have selected cell \(indexPath.row)")
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
    
    
}
